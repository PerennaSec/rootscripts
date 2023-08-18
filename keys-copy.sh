#!/bin/bash

#* Manual signing key copy *#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
  then echo -e "Please Supply Path to Destination. \n"
  exit
fi

dirpath="$1"
if [ ! -d "${dirpath}/keystore" ]
  then echo -e "Keystore Not Found! \n"
  echo -e "Supply Keystore and Try Again. \n"
  exit
else
  cd ${dirpath}/keystore
  cp -v ./efikeys/DB.{key,crt} /etc/MY/efikeys
  cp -v ./signing_key.{pem,x509} /etc/MY/
  exit
fi



