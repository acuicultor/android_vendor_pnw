# Inherit common pnw stuff
$(call inherit-product, vendor/pnw/config/common.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
