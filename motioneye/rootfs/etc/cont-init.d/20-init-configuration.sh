#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: motionEye
# Creates initial motionEye configuration in case it is non-existing
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.directory_exists '/data/motioneye'; then
    cp -R /etc/motioneye /data/motioneye \
        || hass.die 'Failed to create initial motionEye configuration'
fi

if hass.config.true 'motion_api'; then
    hass.log.info "Enabling motion webcontrol"
    sed -i "s/motion_control_localhost true/motion_control_localhost false/" \
        "/data/motioneye/motioneye.conf"
else
    sed -i "s/motion_control_localhost flase/motion_control_localhost true/" \
        "/data/motioneye/motioneye.conf"
fi