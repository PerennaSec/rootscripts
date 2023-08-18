#!/bin/bash

#* Manual signing key removal *#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

rm -v /etc/MY/efikeys/DB.{key,crt}
rm -v /etc/MY/signing_key.{pem,x509}

exit
