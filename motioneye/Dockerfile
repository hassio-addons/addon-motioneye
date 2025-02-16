ARG BUILD_FROM=ghcr.io/hassio-addons/base:17.2.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG MOTION_VERSION="4.7.0"
ARG MOTIONEYE_VERSION="0.43.1b2"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        autoconf=2.72-r0 \
        automake=1.17-r0 \
        build-base=0.5-r3 \
        curl-dev=8.12.1-r0 \
        ffmpeg-dev=6.1.2-r1 \
        gettext-dev=0.22.5-r0 \
        git=2.47.2-r0 \
        jpeg-dev=9f-r0 \
        libjpeg-turbo-dev=3.0.4-r0 \
        libmicrohttpd-dev=0.9.77-r0 \
        libwebp-dev=1.4.0-r0 \
        linux-headers=6.6-r1 \
        musl-dev=1.2.5-r9 \
        python3-dev=3.12.9-r0 \
        v4l-utils-dev=1.28.1-r1 \
    \
    && apk add --no-cache \
        cifs-utils=7.1-r0 \
        ffmpeg-libs=6.1.2-r1 \
        ffmpeg=6.1.2-r1 \
        libintl=0.22.5-r0 \
        libjpeg-turbo=3.0.4-r0 \
        libjpeg=9f-r0 \
        libmicrohttpd=0.9.77-r0 \
        libwebp=1.4.0-r0 \
        mosquitto-clients=2.0.20-r0 \
        nginx=1.26.2-r4 \
        py3-pip=24.3.1-r0 \
        python3=3.12.9-r0 \
        rsync=3.4.0-r0 \
        v4l-utils=1.28.1-r1 \
    \
    && curl -J -L -o /tmp/motion.tar.gz \
        "https://github.com/Motion-Project/motion/archive/release-${MOTION_VERSION}.tar.gz" \
    && mkdir -p /tmp/motion \
    && tar zxf /tmp/motion.tar.gz -C \
        /tmp/motion --strip-components=1 \
    && cd /tmp/motion \
    && autoreconf -fiv \
    && ./configure \
            --without-pgsql \
            --without-mysql \
            --without-sqlite3 \
            --prefix=/usr \
            --sysconfdir=/etc \
    && make install \
    \
    && pip install --no-cache-dir \
        "https://github.com/motioneye-project/motioneye/archive/${MOTIONEYE_VERSION}.tar.gz" \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -f -r /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
