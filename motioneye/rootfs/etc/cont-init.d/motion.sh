#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Configure motion webcontrol access
# ==============================================================================
readonly motion='/data/motioneye/motion.conf'

if bashio::config.true 'motion_webcontrol'; then
    bashio::log.info "Enabling motion webcontrol..."
    bashio::.log.warning "This opens up an UNSECURE port to the outside world!"
    bashio::.log.warning "This port has NO SSL & NO AUTHENICATION!"
    bashio::.log.warning "YOU HAVE BEEN WARNED!"
    sed -i "s/webcontrol_localhost on/webcontrol_localhost off/" "$motion"
else
    sed -i "s/webcontrol_localhost off/webcontrol_localhost on/" "$motion"
fi

# Creates initial motionEye media folder in case it is non-existing
if ! bashio::fs.directory_exists '/share/motioneye'; then
    mkdir -p /share/motioneye \
        || bashio::exit.nok 'Failed to create initial motionEye media folder'
fi
