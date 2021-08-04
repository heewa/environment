#!/bin/bash -e
sudo /usr/bin/docker run -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v /media/heewa:/media --net=host jellyfin/jellyfin:latest
