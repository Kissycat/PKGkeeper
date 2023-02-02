#!/bin/sh /etc/rc.common
USE_PROCD=1
START=99
STOP=01

start_service() {
procd_open_instance
procd_set_param command /bin/sh "/usr/lib/pkgkeep/switch.sh"
procd_set_param stdout 1
procd_set_param stderr 1
procd_close_instance
}
