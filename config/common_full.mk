# Inherit common WrathOS stuff
$(call inherit-product, vendor/wrath/config/common.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
