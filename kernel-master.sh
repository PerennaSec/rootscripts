#!/bin/bash

#* Handy script to update kernel configuration before saving to a backup location and signing to a new stub kernel *#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo -e "Initiating Kernel Config ... \n"

cd /usr/src/linux
make menuconfig

echo -e "Kernel Config Complete.\n"
echo -e "Kernel Update Beginning in 10 Seconds.\n"
echo -e "Press CTRL-C Now to Stop Script.\n"

sleep 10

#--------------------]
# BEGIN KERNEL UPDATE
#--------------------]

# check root user

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
  then echo "Supply Path To Keystore."
  exit
fi

dirpath="$1"

# script prelim

echo -e "Initiating Kernel Update ... \n"
echo -e "Please Ensure Power Supply is Sufficient for Sensitive Operations!\n"

sleep 5

today=$( date +%Y%m%d )
file_name=config_${today}

if [ -f /usr/src/linux/certs/signing_key.pem ] && [ -f /usr/src/linux/certs/signing_key.x509 ]; then
  echo -e "Module Signing Keys Found.\n"
else
  echo -e "No Module Keys Found. \n"
  echo -e "Copying Module Keys to /usr/src/linux/certs/ ... \n"
  cp -v ${dirpath}/keystore/signing_key.{pem,x509} /usr/src/linux/certs/
fi

cd /usr/src/linux

#--------------------]
# BEGIN KERNEL BUILD
#--------------------]

echo -e "Initiating Kernel Build ... \n"

make -j 8
make modules_install

# sign stub kernel

echo -e "Signing Stub Kernel ... \n"

sbsign --key ${dirpath}/keystore/efikeys/DB.key --cert ${dirpath}/keystore/efikeys/DB.crt --output /boot/EFI/Boot/bzImage.efi arch/x86/boot/bzImage

echo -e "\n"

# backup config

echo -e "Creating Config Backup for Date: ${today} ... \n"

cp ./.config /etc/MY/$file_name

# backup to grub bootloader

echo -e "Creating Grub Entry ... \n"

make install

grub-mkconfig -o /boot/grub/grub.cfg

# rm module keys

emerge -v virtualbox-modules

# done

echo -e "Finalizing ... "

sleep 5

echo -e "Kernel Update Complete! \n"

exit
