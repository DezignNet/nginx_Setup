#! /usr/bin/env bash

# This script will install the stable version of nginx
# This script can be run on Debian, Ubuntu, CentOS or RedHat

# Check to see if we are running as the root user
if [ $(id -u) <> 0 ]; then
   echo "...you must be root to run this script..."
   exit
fi

# Check to see if nginx is already installed
if [ -e $(which nginx) ]; then
   echo "...nginx is already installed..."
   exit
fi

# Constant variables
CURDIR="$(pwd)"
LOGFILE="/var/log/log_Jenkins_`date '+%F_%H-%M-%S'`.log"
ETC="/etc"
thisArch="$(uname -m)"
myRunLVL=$(runlevel | awk '{ print $2 }')

if [ -e /usr/bin/lsb_release ]; then
   thisDist="$(lsb_release -i | awk '{ print $3 }')"
   thisRel="$(lsb_release -r | awk '{ print $2 }' | cut -d '.' -f1)"
else
   thisDist="$(grep "^NAME=" /etc/os-release | cut -d "=" -f2 | tr -d "\"" | awk '{ print $1 }')"
   thisRel="$(grep "^VERSION=" /etc/os-release | cut -d "=" -f2 | tr -d "\"" | cut -d " " -f1 | cut -d "." -f1)"
fi


case "$thisDist" in
   Debian|Ubuntu)
      wget -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
      apt-get update && apt-get -y install nginx

   ;;

   CentOS*|RedHat*)
      # copy the repo file and edit appropriately
      cp ./nginx.repo /etc/yum.repos.d/

      if [ "$thisDist" = "CentOS" ]; then
         thisOS="centos"
      else
         thisOS="rhel"
      fi

      sed
   ;;

   *)
      echo "This distro is unsupported at this time."
      exit
   ;;
esac
