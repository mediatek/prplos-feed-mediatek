#
# MTK- wifi shutdown utility for prplOS
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wifi_shutdown_util
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_CONFIG_DEPENDS:=

include $(INCLUDE_DIR)/package.mk

define Package/wifi_shutdown_util
  SECTION:=net
  CATEGORY:=Network
  TITLE:=mtk wifi shutdown utility for prplOS
  VERSION:=$(PKG_RELEASE)-$(REVISION)
endef

define Package/wifi_shutdown_util/description
  mtk wifi shutdown util add wifi interface down flow into reboot sequence
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile/Default
endef

Build/Compile = $(Build/Compile/Default)

define Package/wifi_shutdown_util/install
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) ./files/wifi_shutdown $(1)/etc/init.d/
endef

$(eval $(call BuildPackage,wifi_shutdown_util))
