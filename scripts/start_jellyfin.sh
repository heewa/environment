#/bin/bash -e
/usr/bin/docker run -v /tmp/jellyfin:/tmp -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v /home/heewa/Videos:/Videos -v /tmp/jellyfin-transcodes:/config/transcodes -p 8096:8096 -p 8920:8920 --device /dev/fb0:/dev/fb0 'jellyfin/jellyfin:latest'
