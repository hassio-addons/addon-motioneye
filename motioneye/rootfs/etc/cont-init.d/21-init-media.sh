#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye media folder in case it is non-existing
if ! bashio::fs.directory_exists '/share/motioneye'; then
    mkdir -p /share/motioneye \
        || bashio::exit.nok  'Failed to create initial motionEye media folder'
fi
