#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye media folder in case it is non-existing
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.directory_exists '/share/motioneye'; then
    mkdir -p /share/motioneye \
        || hass.die 'Failed to create initial motionEye media folder'
fi
