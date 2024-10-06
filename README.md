# Install Pi-Hole in Docker on Firewalla Gold or Purple

This is a script for installing pi-hole container on Firewalla Gold or Purple. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360051625034-Guide-How-to-install-Pi-Hole-on-Gold-Purple-Beta-) and has been tested on 1.974.

# Notes
- Pi-hole runs fine on all Purple or Gold models. (see below) 
- Understand that Firewalla and Pihole have some overlapping features which means you have two options:
     1. Set the Firewalla LAN DNS settings to point to pihole. Pihole will see only firewalla, not individiual devices. So that means you can't tweak pihole per device. 
     2. Disable DNS Booster This will allow Pihole to see individual devices but will disable many firewalla features. 
Given the options, I strongly recommend the first. Some people may find this tradeoff unacceptable. There is another option. [nextDNS](https://nextdns.io) can be used with the best of both worlds see [my installer](https://github.com/mbierman/Firewalla-NextDNS-CLI-install) for using nextDNS with Fireawlla.

Assuming you want to go on with pihole, given the above:
- Firewalla uses pi-hole v5.1.2 in their example. I have set up the option for using the latest or Firewalla's default. You can choose when you install. I have had no issues installing or using the latest Pihole release. 
- The Pi-hole password will be, `firewalla`.

![image](https://user-images.githubusercontent.com/1205471/180276302-1dfdb91f-952c-4194-8d06-371f1c14912d.png)

# Installation
To install:
1. SSH into your Firewalla ([learn how](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.)

2. If you want regular pi-hole with the version Firewalla recommends, copy the line below and paste into the Firewalla shell and then hit enter. 

```
curl -s -L -C- https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/pihole_docker_install.sh | cat <(cat <(bash))
```

If you want pi-hole with the latest pihole image, copy the line below instead and paste into the Firewalla shell and then hit enter.
```
curl -s -L -C- https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/pihole_docker_install.sh | cat <(cat <(bash -s -- latest))
```

If you want pi-hole with DoH, copy the line below instead and paste into the Firewalla shell and then hit enter.
```
curl -s -L -C- https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/pihole_docker_install.sh | cat <(cat <(bash -s -- doh))
```

3. Now go to the network settings on Firewalla App, assign `172.16.0.2` as the primary DNS server for all networks that you want to enable Pi-Hole and disable DoH or Unbound on these networks.

     1. Tap on Network Manager. 
     1. Tap on the Top right edit button.
     1. Tap on each LAN or VLAN segment you want to use pi-hole on.
     1. Scroll down and change the primary DNS to `172.16.0.2`. Leave the secondary DNS empty.
     

# Testing
1. After completing the steps above, you should be able to see DNS requests coming up in the pi-hole management console [172.16.0.2/admin](http://172.16.0.2/admin).
2. Try to block something obvious in pi-hole like facebook.com and try to reach it you should be blocked. 
3. If you go to [browserleaks.com/dns](https://browserleaks.com/dns) you should see the upstream DNS servers you set in pi-hole if you are using unencrypted DNS. 


**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or comprimise security. Happy to answer questions though if I can. :)

# Debugging Tips
Use the fillowing to debug. If you have any issues, please provide: 
1. Go to [http://172.16.0.2/admin/](http://172.16.0.2/admin/) ? [http://172.16.0.2](http://172.16.0.2) will not work.
1. Get the logs. When SSH'd to Firewalla, `sudo docker logs pihole`
1. Try `sudo docker inspect pihole | grep "IPAddress"`
1. Try `sudo docker ps` you hould get something like:<br/>
```
CONTAINER ID   IMAGE                  COMMAND      CREATED          STATUS                    PORTS                            NAMES
a5fe91e7a8ab   pihole/pihole:latest   "/s6-init"   11 minutes ago   Up 11 minutes (healthy)   53/udp, 53/tcp, 80/tcp, 67/udp   pihole
```
1. Try `sudo docker inspect pihole`

# Uninstalling

You can run this by copying this line and run it on firewalla to uninstall. 
```
curl -s -L -C- https://raw.githubusercontent.com/mbierman/pihole-installer-for-Firewalla/main/uninstall_pihole.sh | cat <(cat <(bash))
```

There are lots of pihole communities on [Reddit](https://www.reddit.com/r/pihole/). If you have pi-hole questions, please check there. 


