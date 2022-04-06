#/bin/bash -e
sudo docker run -t -v ~/.config/transmission-rss/config.yml:/etc/transmission-rss.conf -v ~/.config/transmission-rss/seen:/var/lib/transmission-rss/seen nning2/transmission-rss
