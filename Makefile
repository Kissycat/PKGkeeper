#
# Copyright (C) 2008-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pkgkeeper
# Version == major.minor.patch
# increase on new functionality (minor) or patches (patch)
PKG_VERSION:=1.0.0
# Release == build
# increase on changes of services files or tld_names.dat
PKG_RELEASE:=1

PKG_LICENSE:=
PKG_MAINTAINER:=

include $(INCLUDE_DIR)/package.mk

# no default dependencies
PKG_DEFAULT_DEPENDS=

define Package/pkgkeeper/Default
	MAINTAINER:=Songine
    PKGARCH:=all
endef

###### *************************************************************************
define Package/pkgkeeper
    $(call Package/pkgkeeper/Default)
    TITLE:=Packages keerper while sysupgrade
endef
# shown in LuCI package description
define Package/pkgkeeper/description
    Auto install & remove packages after sysupgrade, keep the installed-list same as before.
endef
# shown in menuconfig <Help>
define Package/pkgkeeper/config
	help
		A script auto install & remove after sysupgrade, keep the installed-list same as before.
		Version: $(PKG_VERSION)-$(PKG_RELEASE)
		Info   : None
endef

###### *************************************************************************
###### *************************************************************************
define Build/Configure
endef
define Build/Compile
	$(CP) ./files $(PKG_BUILD_DIR)
	# remove comments, white spaces and empty lines
	for FILE in `find $(PKG_BUILD_DIR)/files -type f`; do \
		$(SED) 's/^[[:space:]]*//' \
		-e '/^#[[:space:]]\|^#$$$$/d' \
		-e 's/[[:space:]]#[[:space:]].*$$$$//' \
		-e 's/[[:space:]]*$$$$//' \
		-e '/^\/\/[[:space:]]/d'	\
		-e '/^[[:space:]]*$$$$/d'	$$$$FILE; \
	done
endef

define Package/pkgkeeper/conffiles
/etc/config/pkgkeep
endef

###### *************************************************************************
define Package/pkgkeeper/preinst
	#!/bin/sh
	# if NOT run buildroot then stop service
	[ -z "$${IPKG_INSTROOT}" ] && echo "~{QWQ}~"
	exit 0	# suppress errors
endef
define Package/pkgkeeper/install
	$(INSTALL_DIR)  $(1)/etc/init.d
	$(INSTALL_BIN)  $(PKG_BUILD_DIR)/files/init.sh $(1)/etc/init.d/pkgkeeper
	$(INSTALL_DIR)  $(1)/etc/config/pkgkeep
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/local.list $(1)/etc/config/pkgkeep
	$(INSTALL_DIR)  $(1)/lib/upgrade
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/mod.sh $(1)/lib/upgrade

	$(INSTALL_DIR)  $(1)/usr/lib/pkgkeep
	$(INSTALL_BIN)  $(PKG_BUILD_DIR)/files/switch.sh $(1)/usr/lib/pkgkeep
endef
define Package/pkgkeeper/postinst
	#!/bin/sh
	# if NOT run buildroot and PKG_UPGRADE then (re)start service if enabled
	[ -z "$${IPKG_INSTROOT}" -a "$${PKG_UPGRADE}" = "1" ] && {
		/etc/init.d/pkgkeeper enable
	}
	exit 0	# suppress errors
endef
define Package/pkgkeeper/prerm
	#!/bin/sh
	# if run within buildroot exit
	[ -n "$${IPKG_INSTROOT}" ] && exit 0
	# clear LuCI indexcache
	rm -f /tmp/luci-indexcache >/dev/null 2>&1
	exit 0	# suppress errors
endef

###### *************************************************************************
$(eval $(call BuildPackage,pkgkeeper))
