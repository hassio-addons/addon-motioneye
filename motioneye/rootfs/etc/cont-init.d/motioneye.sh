#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
readonly CONF='/data/motioneye/motioneye.conf'

if ! bashio::fs.directory_exists '/data/motioneye'; then
    cp -R /etc/motioneye/ /data/motioneye/ \
        || bashio::exit.nok 'Failed to create initial motionEye configuration'
fi

# Needed for existing installations.
if ! bashio::fs.file_exists "${CONF}"; then
    cp /etc/motioneye/motion.conf "${CONF}" \
        || bashio::exit.nok 'Failed to create initial motion configuration'
fi

# Migration
if bashio::fs.file_exists "${CONF}"; then
    bashio::log.debug "Running startup migrations"
    /usr/lib/python2.7/site-packages/motioneye/scripts/migrateconf.sh "${CONF}"
    find /data/motioneye/ \
        -maxdepth 1 \
        -type f \
        -name "thread-*.conf" \
        -exec \
            /usr/lib/python2.7/site-packages/motioneye/scripts/migrateconf.sh {} \;
fi
