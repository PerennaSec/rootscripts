#!/bin/bash

#* MANUAL MODULE SIGNING *#

/usr/src/linux/scripts/sign-file sha512 /usr/src/linux/certs/signing_key.pem /usr/src/linux/certs/signing_key.x509 $1

exit
