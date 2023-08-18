# rootscripts
A small collection of basic utility scripts intended to streamline Gentoo personal workstation management

These scripts best function on a build that's based off the Gentoo Installation Guide for Paranoid Dummies (https://forums.gentoo.org/viewtopic-t-1112798.html), namely in that it assumes the user is building a stub kernel, self-signed by user-generated keys that are securely stored on a removeable medium. The scripts assume that two directories are to be found on removeable drives, the ``stage4/`` and ``keystore/`` directories. ``stage4/`` will be used for system backups, whereas ``keystore/`` holds user-generated keys. Most of the included scripts should generate these directories if they are not found.
