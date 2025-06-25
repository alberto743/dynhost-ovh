#!/bin/sh
set -e -u

# Account configuration
ovhdyn_host=DOMAINE_NAME
ovhdyn_usr=LOGIN
ovhdyn_pwd=PASSWORD
localip=false

# Variables
log_file=/var/log/dynhostovh.log

# Local IP
default_gateway=$(ip --json route | jq -r '.[] | select(.dst == "default") | .gateway')
ip_local=$(ip --json route get $default_gateway | jq -r '.[] | .prefsrc? // empty')

# External IP
ip_external=$(curl --silent --max-time 5 https://ifconfig.me/ip)

# Desired IP
if $localip
then
  ip_toset=$ip_local
else
  ip_toset=$ip_external
fi

# Date & Time
datetime_current=$(date --utc --iso-8601=seconds)

# Current IP
ip_current=$(dig +short $ovhdyn_host)

# Update dynamic IPv4, if needed
if [ -z "$ip_current" ] || [ -z "$ip_toset" ]
then
  echo "[$datetime_current]: No IP retrieved" >> $log_file
elif [ "$ip_current" != "$ip_toset" ]
then
  answer=$(curl --silent --max-time 5 --location --location-trusted --user "$ovhdyn_usr:$ovhdyn_pwd" "https://www.ovh.com/nic/update?system=dyndns&hostname=$ovhdyn_host&myip=$ip_toset")
  echo "[$datetime_current]: Request to OVH DynHost: $answer" >> $log_file
fi
