# Inherit full common Pnw stuff
$(call inherit-product, vendor/pnw/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Pnw LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/pnw/overlay/dictionaries
