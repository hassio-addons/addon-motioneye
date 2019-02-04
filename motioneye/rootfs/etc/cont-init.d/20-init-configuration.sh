#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.directory_exists '/data/motioneye'; then
    cp -R /etc/motioneye/ /data/motioneye/ \
        || hass.die 'Failed to create initial motionEye configuration'
fi


# Needed for existing installations.
if ! hass.file_exists '/data/motioneye/motion.conf'; then
    cp /etc/motioneye/motion.conf /data/motioneye/motion.conf \
        || hass.die 'Failed to create initial motion configuration'
fi