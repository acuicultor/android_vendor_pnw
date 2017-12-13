# Copyright (C) 2017 Project New World
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# PNW_BUILDTYPE belongs to the pnw.mk
ifeq ($(PNW_BUILDTYPE), Official)
    PNW_TAG := Official
else ifeq ($(PNW_BUILDTYPE), Alpha)
    PNW_TAG := Alpha
else ifeq ($(PNW_BUILDTYPE), Beta)
    PNW_TAG := Beta
else ifeq ($(PNW_BUILDTYPE), Test)
    PNW_TAG := Test
else ifeq ($(PNW_BUILDTYPE), EOL)
    PNW_TAG := EOL
else
    PNW_TAG := Unofficial
endif

# Include versioning information
# Format: Major.minor.maintenance(-TAG)
PNW_VERSION_TAG := 8.0.0
export PNW_VERSION := $(PNW_VERSION_TAG)-$(PNW_TAG)
ROM_POSTFIX := $(shell date -u +%Y%m%d)

export PNW_BUILD_VERSION := Project-New-World-$(PNW_VERSION)-$(TARGET_PRODUCT)-$(ROM_POSTFIX)
export ROM_VERSION := $(PNW_VERSION)-$(ROM_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(ROM_VERSION) \
    ro.pnw.version=$(PNW_VERSION)

# Override old AOSP default sounds with newer Google stock ones
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Ariel.ogg \
    ro.config.alarm_alert=Osmium.ogg

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# Allow tethering without provisioning app
PRODUCT_PROPERTY_OVERRIDES += net.tethering.noprovisioning=true

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/pnw/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/pnw/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/pnw/prebuilt/bin/50-pnw.sh:system/addon.d/50-pnw.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += vendor/pnw/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Bootanimation
PRODUCT_COPY_FILES += vendor/pnw/prebuilt/bootanimation/placeholder.zip:system/media/bootanimation.zip

# Copy PNW specific init file
PRODUCT_COPY_FILES += vendor/pnw/prebuilt/root/init.pnw.rc:root/init.pnw.rc

# Enable SIP+VoIP
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Include vendor overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/pnw/overlay/common

# init.d support
PRODUCT_COPY_FILES += \
    vendor/pnw/prebuilt/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/pnw/prebuilt/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/pnw/prebuilt/bin/sysinit:system/bin/sysinit

# Signature compatibility validation
PRODUCT_COPY_FILES += vendor/pnw/prebuilt/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Packages
PRODUCT_PACKAGES += \
    AudioFX \
    WallpaperPicker

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include support for additional filesystems
PRODUCT_PACKAGES += \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Custom off-mode charger
ifneq ($(WITH_LINEAGE_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    lineage_charger_res_images \
    font_log.png \
    libhealthd.lineage
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

$(call prepend-product-if-exists, vendor/extra/product.mk)
