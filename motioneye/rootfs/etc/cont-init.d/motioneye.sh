#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
readonly CONF='/data/motioneye/motioneye.conf'
readonly MOTION='/data/motioneye/motion.conf'
declare button_type
declare camera_number
declare button_command

# Ensure configuration exists
if ! bashio::fs.directory_exists '/data/motioneye'; then
    cp -R /etc/motioneye/ /data/motioneye/ \
        || bashio::exit.nok 'Failed to create initial motionEye configuration'
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

# Remove any existing action buttons before recreating
for old_action in lock unlock light alarm up right down left zoom preset; do
    find /data/motioneye/. -name "${old_action}*" -delete
done

# Creates action button scripts if any are configured
if bashio::config.has_value 'action_buttons'; then
    bashio::log.info "Configuring action buttons."
    for button in $(bashio::config "action_buttons|keys"); do
        button_type=$(bashio::config "action_buttons[${button}].type")
        camera_number=$(bashio::config "action_buttons[${button}].camera")
        button_command=$(bashio::config "action_buttons[${button}].command")
        bashio::log.debug "File: ${button_type}_${camera_number}, Command: ${button_command}"
        {
            echo "#!/usr/bin/with-contenv bashio"
            echo "${button_command}"
        } > "/data/motioneye/${button_type}_${camera_number}"
        chmod +x "/data/motioneye/${button_type}_${camera_number}"
    done
fi
