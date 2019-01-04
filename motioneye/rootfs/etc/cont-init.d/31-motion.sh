#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Configure motion webcontrol access
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly motion='/data/motioneye/motion.conf'

if hass.config.true 'motion_webcontrol'; then
    hass.log.info "Enabling motion webcontrol"
    sed -i "s/webcontrol_localhost on/webcontrol_localhost off/" "$motion"
else
    sed -i "s/webcontrol_localhost off/webcontrol_localhost on/" "$motion"
fi
