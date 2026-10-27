#
# Copyright (C) 2024 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wifi-scripts
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_URL:=https://github.com/mediatek/softmac_wifi-scripts
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=mp4.3-6.12
PKG_SOURCE_HASH:=skip

PKG_VERSION:=4.3.6.12
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>
PKG_CONFIG_DEPENDS:=CONFIG_WIFI_SCRIPTS_UCODE

include $(INCLUDE_DIR)/package.mk

define Package/wifi-scripts
  SECTION:=utils
  CATEGORY:=Base system
  DEPENDS:=+netifd +ucode +ucode-mod-nl80211 +ucode-mod-rtnl +ucode-mod-ubus +ucode-mod-uci +ucode-mod-digest
  TITLE:=Wi-Fi configuration scripts
  PKGARCH:=all
endef

define Package/wifi-scripts/config
	source "$(SOURCE)/Config.in"
endef

define Package/wifi-scripts/description
 A set of scripts that handle setup and configuration of Wi-Fi devices.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/wifi-scripts/install
	$(INSTALL_DIR) $(1) $(1)/usr/share/hostap
	$(CP) $(PKG_BUILD_DIR)/files/* $(1)/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hostapd/hostapd.uc $(1)/usr/share/hostap/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hostapd/wpa_supplicant.uc $(1)/usr/share/hostap/
ifeq ($(CONFIG_WIFI_SCRIPTS_UCODE),y)
	$(CP) $(PKG_BUILD_DIR)/files-ucode/* $(1)/
endif
ifeq ($(CONFIG_WIFI_SCRIPTS_WPS_BUTTON_DISABLED),y)
	rm -f $(1)/etc/rc.button/wps
endif
endef

$(eval $(call BuildPackage,wifi-scripts))
