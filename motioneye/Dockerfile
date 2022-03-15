ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:11.1.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        autoconf=2.71-r0 \
        automake=1.16.4-r1 \
        build-base=0.5-r2 \
        curl-dev=7.80.0-r0 \
        ffmpeg-dev=4.4.1-r2 \
        gcc=10.3.1_git20211027-r0 \
        gettext-dev=0.21-r0 \
        git=2.34.1-r0 \
        jpeg-dev=9d-r1 \
        libjpeg-turbo-dev=2.1.2-r0 \
        libmicrohttpd-dev=0.9.73-r0 \
        libwebp-dev=1.2.2-r0 \
        linux-headers=5.10.41-r0 \
        musl-dev=1.2.2-r7 \
        python2-dev=2.7.18-r4 \
        v4l-utils-dev=1.22.1-r1 \
    \
    && apk add --no-cache \
        cifs-utils=6.14-r0 \
        ffmpeg-libs=4.4.1-r2 \
        ffmpeg=4.4.1-r2 \
        libcurl=7.80.0-r0 \
        libintl=0.21-r0 \
        libjpeg-turbo=2.1.2-r0 \
        libjpeg=9d-r1 \
        libmicrohttpd=0.9.73-r0 \
        libwebp=1.2.2-r0 \
        mosquitto-clients=2.0.14-r0 \
        nginx=1.20.2-r0 \
        python2=2.7.18-r4 \
        rsync=3.2.3-r5 \
        v4l-utils=1.22.1-r1 \
    \
    && MOTION_VERSION=4.3.2 \
    && curl -J -L -o /tmp/motion.tar.gz \
        https://github.com/Motion-Project/motion/archive/release-${MOTION_VERSION}.tar.gz \
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
            --without-optimizecpu \
    && make install \
    \
    && python -m ensurepip \
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
