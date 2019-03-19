#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
if ! bashio::fs.directory_exists '/data/motioneye'; then
    cp -R /etc/motioneye/ /data/motioneye/ \
        || bashio::exit.nok  'Failed to create initial motionEye configuration'
fi


# Needed for existing installations.
if ! bashio::fs.directory_exists '/data/motioneye/motion.conf'; then
    cp /etc/motioneye/motion.conf /data/motioneye/motion.conf \
        || bashio::exit.nok 'Failed to create initial motion configuration'
fi