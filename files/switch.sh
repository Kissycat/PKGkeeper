#!/bin/sh
start() {
ls /etc/config/pkgkeep/on >/dev/null 2>&1 || ln -s /usr/lib/pkgkeep/switch.sh /usr/sbin/pkgkeep
ls /usr/sbin/pkgkeep >/dev/null 2>&1 && exit 0

opkg list-installed | cut -f 1 -d ' ' > /etc/config/pkgkeep/origin.list
grep -v -f /etc/config/pkgkeep/origin.list /etc/config/pkgkeep/mod.list > /etc/config/pkgkeep/install.list
tail +2 /etc/config/pkgkeep/local.list >> /etc/config/pkgkeep/install.list
grep -v -f /etc/config/pkgkeep/mod.list /etc/config/pkgkeep/origin.list > /etc/config/pkgkeep/remove.list
[ ! -s /etc/config/pkgkeep/install.list ] && _install=0
[ ! -s /etc/config/pkgkeep/remove.list ] && [ $_install -eq 0 ] && echo "Nothing different." && ln -s /usr/lib/pkgkeep/switch.sh /usr/sbin/pkgkeep && exit 0
_remove=1
opkg update
[ $_remove -ne 0 ] && opkg remove `cat /etc/config/pkgkeep/remove.list` && _remove=0
[ $_install -ne 0 ] && opkg install `cat /etc/config/pkgkeep/install.list` && _install=0
[ $_remove -eq $_install ] && ln -s /usr/lib/pkgkeep/switch.sh /usr/sbin/pkgkeep
}
mod=$1
[ -n "$1" ] || mod=run && case "$mod" in
		run) start;;
    on) touch /etc/config/pkgkeep/on >/dev/null 2>&1 && /etc/init.d/pkgkeeper enable;;
    off) rm /etc/config/pkgkeep/on >/dev/null 2>&1;;
    force) rm /usr/sbin/pkgkeep; start || ln -s /usr/lib/pkgkeep/switch.sh /usr/sbin/pkgkeep >/dev/null 2>&1;;
    *) cat <<INFO;;        
      *  Usage:
      *    run --- Run manually.
      *    on  --- Enable the auto install & remove after sysupgrade.
      *    off --- Disable the auto install & remove.      
      *  force --- Force run scripts although not the first boot after sysupgrade.

      PKGkeeper · A script auto install & remove after sysupgrade, keep the installed-list same as before.

INFO
    esac
