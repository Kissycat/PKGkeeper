#!/bin/sh
opkg list-installed | cut -f 1 -d ' ' > /etc/config/pkgkeep/mod.list