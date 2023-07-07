#!/bin/bash
podman run -d \
  --name=syncthing \
  --label io.containers.autoupdate=registry \
  -e PUID=0 \
  -e PGID=0 \
  -p 127.0.0.1:8384:8384 \
  -p 22000:22000/tcp \
  -p 22000:22000/udp \
  -p 21027:21027/udp \
  -v ~/.config/syncthing:/config:Z \
  -v ~/Documents:/Documents:Z \
  -v ~/Sync:/Sync:Z \
  -v ~/Pictures:/Pictures:Z \
  lscr.io/linuxserver/syncthing:latest
