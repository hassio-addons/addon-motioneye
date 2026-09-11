ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG MOTION_VERSION="4.7.1"
ARG MOTIONEYE_VERSION="0.44.0"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        autoconf=2.73-r0 \
        automake=1.18.1-r1 \
        build-base=0.5-r4 \
        curl-dev=8.22.0-r0 \
        ffmpeg-dev=8.1.2-r0 \
        gettext-dev=1.0-r0 \
        git=2.54.0-r0 \
        jpeg-dev=9f-r0 \
        libjpeg-turbo-dev=3.1.3-r0 \
        libmicrohttpd-dev=1.0.5-r0 \
        libwebp-dev=1.6.0-r0 \
        linux-headers=7.0.0-r1 \
        musl-dev=1.2.6-r2 \
        python3-dev=3.14.7-r1 \
        v4l-utils-dev=1.32.0-r1 \
    \
    && apk add --no-cache \
        cifs-utils=7.5-r0 \
        ffmpeg-libs=8.1.2-r0 \
        ffmpeg=8.1.2-r0 \
        libintl=1.0-r0 \
        libjpeg-turbo=3.1.3-r0 \
        libjpeg=9f-r0 \
        libmicrohttpd=1.0.5-r0 \
        libwebp=1.6.0-r0 \
        mosquitto-clients=2.1.2-r1 \
        nginx=1.30.4-r1 \
        py3-pip=26.1.2-r0 \
        python3=3.14.7-r1 \
        rsync=3.5.0-r0 \
        v4l-utils=1.32.0-r1 \
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
    maintainer="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Apps" \
    org.opencontainers.image.authors="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://frenck.dev/home-assistant-apps" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
