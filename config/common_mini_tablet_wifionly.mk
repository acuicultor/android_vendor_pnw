# Inherit mini common Pnw stuff
$(call inherit-product, vendor/pnw/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
