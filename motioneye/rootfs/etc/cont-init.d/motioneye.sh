#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
readonly CONF='/data/motioneye/motioneye.conf'
readonly MOTION='/data/motioneye/motion.conf'

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

# Configure motion webcontrol access
if bashio::config.true 'motion_webcontrol'; then
    bashio::log.info "Enabling motion webcontrol..."
    bashio::log.warning "This opens up an UNSECURE port to the outside world!"
    bashio::log.warning "This port has NO SSL & NO AUTHENICATION!"
    bashio::log.warning "YOU HAVE BEEN WARNED!"
    sed -i "s/webcontrol_localhost on/webcontrol_localhost off/" "$MOTION"
else
    sed -i "s/webcontrol_localhost off/webcontrol_localhost on/" "$MOTION"
fi

# Creates initial motionEye media folder in case it is non-existing
if ! bashio::fs.directory_exists '/share/motioneye'; then
    mkdir -p /share/motioneye \
        || bashio::exit.nok 'Failed to create initial motionEye media folder'
fi
