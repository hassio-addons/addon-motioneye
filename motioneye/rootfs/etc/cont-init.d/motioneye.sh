#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
readonly CONF='/config/motioneye/motioneye.conf'
readonly MOTION='/config/motioneye/motion.conf'

# Ensure configuration exists
if ! bashio::fs.directory_exists '/config/motioneye'; then
    mkdir -p /config/motioneye \
        || bashio::exit.nok 'Failed to create initial motionEye configuration'

    # Copy in template files
    cp /etc/motioneye/* /config/motioneye/.
fi


# Migration
if bashio::fs.file_exists "${CONF}"; then
    bashio::log.debug "Running startup migrations"
    /usr/lib/python2.7/site-packages/motioneye/scripts/migrateconf.sh "${CONF}"
    find /config/motioneye/ \
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
