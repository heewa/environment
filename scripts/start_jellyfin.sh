#/bin/bash -e
sudo /usr/bin/docker run -v /tmp/jellyfin:/tmp -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v /media/heewa:/media -v /home/heewa/Videos:/Videos -v /tmp/jellyfin-transcodes:/config/transcodes --net=host jellyfin/jellyfin:latest
