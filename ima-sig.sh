#!/bin/bash

find  /bin -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /etc -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /lib -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /lib64 -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /opt -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /root -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /sbin -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;
find  /var -fstype ext4 -type f -uid 0 -executable -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;

find  /usr -fstype ext4 -type f -uid 0 -exec evmctl ima_sign -a sha512 -k /etc/MY/efikeys/DB.key '{}' \;

exit
