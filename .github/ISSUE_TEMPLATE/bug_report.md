---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Desktop (please complete the following information):**
 - What version of the pihole docker did you try to install : [e.g. latest]
- What Firewalla are you using? 

**Provide**
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
