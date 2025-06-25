# dynhost-ovh
A simple (cron) script to update DynHost on OVH hosting

# Prerequisites
This script works with three linux commands : curl, dig, and jq
They can be installed on Debian systems with:
```sh
sudo apt-get update
sudo apt-get install curl dnsutils jq
```

# How to use
1. Download the dynhost.sh script and put it in the folder /etc/cron.hourly (to check every hour)
2. Add execution permissions to file : chmod +x dynhost.sh
3. Rename dynhost.sh to dynhost (because "." at the end of the file name is not allowed in cron)
4. Modify the script with variables `ovhdyn_host`, `ovhdyn_usr`, `ovhdyn_pwd` to the values provided in the OVH control panel and set the `localip` to either `true` or `false` depending on the need to expose the internal or external IP to the dynamic DNS.

# How it works
1. The command `dig` is used to retrieve the IP address of your domain name.
2. The command `curl` (with the website [ifconfig.me](https://ifconfig.me)) is used to retrieve the current public IP address of your machine.
3. The commands `ip` and `jq` are used to retrieve the current private IP address of your machine.
4. The IP retrieved and the IP configured in the dynamic DNS are compared and if necessary a `curl` command to OVH is used to update your DynHost with your current private or external IP address (depending on the configuration).
4. Log file is on ```/var/log/dynhostovh.log```
