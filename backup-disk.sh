#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
  then echo -e "Please Supply Path to Destination. \n"
  exit
else
  dirpath="$1"
  echo -e "Initating System Backup at ${dirpath} ... \n"
  if [ ! -d "${dirpath}/stage4" ] || [ ! -d "${dirpath}/keystore" ]
    then echo -e "Required SubDirectories Not Found! \n"
    echo -e "Creating SubDirectories ... \n"
    mkdir -pv ${dirpath}/{stage4,keystore}
    echo -e "\n"
  else
    echo -e "Required SubDirectories Found ... \n"
  fi

  today=$( date +%Y%m%d )
  echo -e "Creating Stage4 ... \n"
  echo -e "Location: ${dirpath}/stage4 ... \n"
  echo -e "Date: $today ... \n"
  cd ${dirpath}/stage4
  mkstage4 -q -s ${today}

  if [ $? -ne 0 ]
    then echo -e "Error(s) Detected! \n"
    echo -e "Please Inspect Syntax, Paths, & Output and Try Again. \n"
    exit
  else
    echo -e "Backup Complete! \n"
    sleep 3
    umount -v ${dirpath}
    exit
  fi
fi

