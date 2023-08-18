#!/bin/bash

#* Simple Script to create backup kernel on removable media. *#
#* Best used after establishing a stable kernel config, in order to backup system functions in case of future outages. *#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
  then echo -e "Please Supply Path to Destination. \n"
  exit
else
  dirpath="$1"
  echo -e "Creating Rescue Kernel at ${dirpath} ... \n"
  if [ ! -d "${dirpath}/EFI/BOOT/" ]
    then echo -e "Required SubDirectories Not Found! \n"
    echo -e "Creating ${dirpath}/EFI/BOOT/ ... \n"
    mkdir -p ${dirpath}/EFI/BOOT/
  else
    echo -e "${dirpath}/EFI/BOOT/ Found ... \n"
  fi

  echo -e "Signing Stub Kernel to ${dirpath}/EFI/BOOT/bootx64.efi ... \n"
  sbsign --key /etc/MY/efikeys/DB.key --cert /etc/MY/efikeys/DB.crt --output ${dirpath}/EFI/BOOT/bootx64.efi /usr/src/linux/arch/x86/boot/bzImage

  if [ $? -ne 0 ]
    then echo -e "Error(s) Detected! \n"
    echo -e "Please Inspect Syntax & Paths and Try Again. \n"
    exit
  else
    echo -e "Signing Complete! \n"
    echo -e "Unmounting Rescue Partition ... \n"
    umount ${dirpath}
    exit
  fi
fi
