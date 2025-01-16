# Copyright (c) 2015 OpenWrt.org
#
include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=mediatek
BOARDNAME:=MediaTek ARM
SUBTARGETS:=filogic mt7622 mt7623 mt7629
FEATURES:=dt-overlay emmc fpu gpio nand pci pcie rootfs-part separate_ramdisk squashfs usb

KERNEL_PATCHVER:=6.6

GENERIC_BACKPORT_DIR := $(TOPDIR)/target/linux/feeds/$(BOARD)/backport-$(KERNEL_PATCHVER)
GENERIC_PATCH_DIR := $(TOPDIR)/target/linux/feeds/$(BOARD)/pending-$(KERNEL_PATCHVER)
GENERIC_HACK_DIR := $(TOPDIR)/target/linux/feeds/$(BOARD)/hack-$(KERNEL_PATCHVER)
GENERIC_LINUX_CONFIG := $(TOPDIR)/target/linux/feeds/$(BOARD)/config-$(KERNEL_PATCHVER)
GENERIC_FILES_DIR := $(TOPDIR)/target/linux/feeds/$(BOARD)/files-generic

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	kmod-leds-gpio kmod-gpio-button-hotplug

$(eval $(call BuildTarget))
