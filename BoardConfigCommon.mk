#
# Copyright (C) 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PLATFORM_PATH := device/motorola/msm8998-common

# Architeture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a73
TARGET_CPU_VARIANT_RUNTIME := cortex-a73

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a73
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo

BOARD_USES_QCOM_HARDWARE := true

# A/B updater
AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor

ifeq ($(PRODUCT_RETROFIT_DYNAMIC_PARTITIONS), true)
AB_OTA_PARTITIONS += product
endif

ifneq (,$(filter %lake, $(TARGET_PRODUCT)))
AB_OTA_PARTITIONS += \
    dtbo
endif

AB_OTA_UPDATER := true

# Audio
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

# Build
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Display
TARGET_USES_ION := true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
LOC_HIDL_VERSION := 3.0

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(PLATFORM_PATH)/configs/vintf/framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix_legacy.xml \
    vendor/lineage/config/device_framework_matrix.xml

DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/configs/vintf/manifest.xml
ifdef BOARD_USES_KEYMASTER_4
    DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/configs/vintf/keymaster_4.xml
else
    DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/configs/vintf/keymaster_3.xml
endif
ifdef TARGET_SUPPORTS_MOTO_MODS
    DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/configs/vintf/motomods_manifest.xml
endif
DEVICE_MATRIX_FILE := hardware/qcom-caf/common/compatibility_matrix.xml
TARGET_FS_CONFIG_GEN += \
    $(PLATFORM_PATH)/configs/config.fs \
    $(PLATFORM_PATH)/configs/mot_aids.fs

# Init
TARGET_INIT_VENDOR_LIB := //$(PLATFORM_PATH):libinit_msm8998
TARGET_RECOVERY_DEVICE_MODULES := libinit_msm8998

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom ehci-hcd.park=3
BOARD_KERNEL_CMDLINE += lpm_levels.sleep_disabled=1 service_locator.enable=1
BOARD_KERNEL_CMDLINE += swiotlb=2048 androidboot.configfs=true
BOARD_KERNEL_CMDLINE += sched_enable_hmp=1 sched_enable_power_aware=1
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a800000.dwc3
BOARD_KERNEL_CMDLINE += loop.max_part=7
BOARD_KERNEL_CMDLINE += androidboot.veritymode=eio
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_SOURCE := kernel/motorola/msm8998
BOARD_CUSTOM_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG_MK := $(PLATFORM_PATH)/configs/mkbootimg.mk

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 0x40000
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor

BOARD_ROOT_EXTRA_SYMLINKS := \
    /vendor/fsg:/fsg

ifeq ($(PRODUCT_RETROFIT_DYNAMIC_PARTITIONS), true)
# Metadata
BOARD_USES_METADATA_PARTITION := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM := system
ifeq ($(WITH_GMS), true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 83886080 # 80 MB
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 83886080 # 80 MB
else
BOARD_PRODUCTIMAGE_EXTFS_INODE_COUNT := -1
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 734003200 # 700 MB
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 209715200 # 200 MB
endif
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 41943040 # 40 MB
endif

# Properties
TARGET_ODM_PROP += $(PLATFORM_PATH)/properties/odm.prop
TARGET_PRODUCT_PROP += $(PLATFORM_PATH)/properties/product.prop
TARGET_SYSTEM_EXT_PROP += $(PLATFORM_PATH)/properties/system_ext.prop
TARGET_SYSTEM_PROP += $(PLATFORM_PATH)/properties/system.prop
TARGET_VENDOR_PROP += $(PLATFORM_PATH)/properties/vendor.prop

# Recovery
ifeq ($(PRODUCT_RETROFIT_DYNAMIC_PARTITIONS), true)
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/rootdir/etc/fstab_dynamic.qcom
else
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/rootdir/etc/fstab.qcom
endif

# RIL
ODM_MANIFEST_SKUS += qcril
ODM_MANIFEST_QCRIL_FILES := $(PLATFORM_PATH)/configs/vintf/odm_manifest_qcril.xml

# Root
BOARD_ROOT_EXTRA_SYMLINKS := \
    /mnt/vendor/persist:/persist

# SELinux
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
include device/qcom/sepolicy-legacy-um/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/vendor
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/private
ifeq ($(PRODUCT_RETROFIT_DYNAMIC_PARTITIONS), true)
BOARD_VENDOR_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/dynamic/vendor
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/dynamic/private
endif
ifdef TARGET_SUPPORTS_MOTO_MODS
    PRODUCT_PRIVATE_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/mods/private
    PRODUCT_PUBLIC_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/mods/public
    BOARD_VENDOR_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/mods/vendor
endif

# Treble
BOARD_VNDK_VERSION := current
PRODUCT_FULL_TREBLE_OVERRIDE := true

# Vendor Security Patch Level
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Verified Boot
BOARD_AVB_ENABLE := false
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Wifi
BOARD_WLAN_DEVICE := qcwcn
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
PRODUCT_VENDOR_MOVE_ENABLED := true

# Inherit from the proprietary version
include vendor/motorola/msm8998-common/BoardConfigVendor.mk
