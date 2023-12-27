ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG MOTION_VERSION="4.5.1"
ARG MOTIONEYE_VERSION="ef1c42b57895324a2fb7129e63d37412061a82e2"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        autoconf=2.71-r1 \
        automake=1.16.5-r1 \
        build-base=0.5-r3 \
        curl-dev=8.1.2-r0 \
        ffmpeg-dev=5.1.3-r0 \
        gettext-dev=0.21.1-r1 \
        git=2.38.5-r0 \
        jpeg-dev=9e-r0 \
        libjpeg-turbo-dev=2.1.4-r0 \
        libmicrohttpd-dev=0.9.75-r0 \
        libwebp-dev=1.2.4-r2 \
        linux-headers=5.19.5-r0 \
        musl-dev=1.2.3-r5 \
        python3-dev=3.10.12-r0 \
        v4l-utils-dev=1.22.1-r2 \
    \
    && apk add --no-cache \
        cifs-utils=7.0-r0 \
        ffmpeg-libs=5.1.3-r0 \
        ffmpeg=5.1.3-r0 \
        libintl=0.21.1-r1 \
        libjpeg-turbo=2.1.4-r0 \
        libjpeg=9e-r0 \
        libmicrohttpd=0.9.75-r0 \
        libwebp=1.2.4-r2 \
        mosquitto-clients=2.0.15-r1 \
        nginx=1.22.1-r0 \
        py3-pip=22.3.1-r1 \
        python3=3.10.12-r0 \
        rsync=3.2.7-r0 \
        v4l-utils=1.22.1-r2 \
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
