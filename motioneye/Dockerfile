ARG BUILD_FROM=hassioaddons/base:3.1.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
RUN \
    apk add --no-cache --virtual .build-dependencies \
        curl-dev=7.64.0-r1 \
        gcc=8.3.0-r0 \
        jpeg-dev=8-r6 \
        musl-dev=1.1.20-r4 \
        py2-pip=18.1-r0 \
        python-dev=2.7.15-r3 \
    \
    && apk add --no-cache \
        cifs-utils=6.8-r0 \
        ffmpeg@edge=4.0.2-r0 \
        libcurl=7.64.0-r1 \
        libjpeg=8-r6 \
        mosquitto-clients=1.5.6-r0 \
        motion@edge=4.2.2-r0 \
        nginx=1.14.2-r0 \
        py-setuptools=40.6.3-r0 \
        python2=2.7.15-r3 \
    \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -f -r /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="motionEye" \
    io.hass.description="Simple, elegant and feature-rich CCTV/NVR for your cameras" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Simple, elegant and feature-rich CCTV/NVR for your cameras" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="motionEye" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-motioneye/71826?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-motioneye/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-motioneye" \
    org.label-schema.vendor="Community Hass.io Add-ons"
