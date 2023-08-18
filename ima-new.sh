#!/bin/bash

#* Sign ALL NEW FILES for use with Integrity Measurement Architecture *#

find / -fstype ext4 -type f -uid 0 -executable -mtime 0 -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \; 

exit
