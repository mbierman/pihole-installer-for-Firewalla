#!/bin/bash
# v 1.1

path1=/data/pi-hole
if [ ! -d "$path1" ]; then
	sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/pi-hole/
if [ ! -d "$path2" ]; then
	mkdir $path2
fi

if [ "$1" = "doh" ] ; then
	curl https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/DoH_docker-compose.yaml > $path2/docker-compose.yaml

elif [ "$1" = "latest" ] ; then
	# This uses the latest docker image.
	curl https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/latest.yaml > $path2/docker-compose.yaml

else
 	# This is Firewalla's recommended 
 	curl https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/fwrecommended.yaml > $path2/docker-compose.yaml
 
fi
 
cd $path2
sudo systemctl start docker
sudo docker-compose pull
sudo docker-compose up --no-start
sudo ip route add 172.16.0.0/24 dev br-$(sudo docker network inspect pi-hole_default |jq -r '.[0].Id[0:12]') table lan_routable
sudo ip route add 172.16.0.0/24 dev br-$(sudo docker network inspect pi-hole_default |jq -r '.[0].Id[0:12]') table wan_routable
sudo docker-compose up --detach


sudo docker ps

echo address=/pihole/172.16.0.2 > ~/.firewalla/config/dnsmasq_local/pihole
sudo systemctl restart firerouter_dns
sudo docker restart pihole

echo -n "Starting docker (this can take ~ one minute)"
while [ -z "$(sudo docker ps | grep pihole | grep -o Up)" ]
do
        echo -n "."
        sleep 2s
done
echo "Done"

path3=/home/pi/.firewalla/config/post_main.d
if [ ! -d "$path3" ]; then
        mkdir $path3
fi

echo "#!/bin/bash
# v1.0
sudo systemctl start docker
sudo ipset create -! docker_lan_routable_net_set hash:net
sudo ipset add -! docker_lan_routable_net_set 172.16.0.0/24
sudo ipset create -! docker_wan_routable_net_set hash:net
sudo ipset add -! docker_wan_routable_net_set 172.16.0.0/24
sudo systemctl start docker-compose@pi-hole" > /home/pi/.firewalla/config/post_main.d/start_pihole.sh

chmod a+x /home/pi/.firewalla/config/post_main.d/start_pihole.sh

echo -n "Restarting docker"
sudo docker start pihole
while [ -z "$(sudo docker ps | grep pihole | grep Up)" ]
do
        echo -n "."
        sleep 2s
done
echo -e "Done!\n\nYou can open  http://172.16.0.2/admin in your favorite browser and set up your pi-hole now. (\n\nNote it may not have a certificate so the browser may give you a security warning.)\n\n"
