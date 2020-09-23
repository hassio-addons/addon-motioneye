ARG BUILD_FROM=hassioaddons/base:8.0.3
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
        autoconf=2.69-r2 \
        automake=1.16.2-r0 \
        build-base=0.5-r2 \
        curl-dev=7.69.1-r1 \
        ffmpeg-dev=4.3.1-r0 \
        gcc=9.3.0-r2 \
        gettext-dev=0.20.2-r0 \
        git=2.26.2-r0 \
        jpeg-dev=9d-r0 \
        libjpeg-turbo-dev=2.0.5-r0 \
        libmicrohttpd-dev=0.9.70-r0 \
        libwebp-dev=1.1.0-r0 \
        linux-headers=5.4.5-r1 \
        musl-dev=1.1.24-r9 \
        python2-dev=2.7.18-r0 \
        v4l-utils-dev=1.20.0-r0 \
    \
    && apk add --no-cache \
        cifs-utils=6.10-r1 \
        ffmpeg=4.3.1-r0 \
        ffmpeg-libs=4.3.1-r0 \
        libcurl=7.69.1-r1 \
        libjpeg=9d-r0 \
        libjpeg-turbo=2.0.5-r0 \
        libintl=0.20.2-r0 \
        libmicrohttpd=0.9.70-r0 \
        libwebp=1.1.0-r0 \
        mosquitto-clients=1.6.9-r0 \
        nginx=1.18.0-r0 \
        python2=2.7.18-r0 \
        v4l-utils=1.20.0-r0 \
    \
    && MOTION_VERSION=4.3.1 \
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
    org.opencontainers.image.title="motionEye" \
    org.opencontainers.image.description="Simple, elegant and feature-rich CCTV/NVR for your cameras" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-motioneye" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-motioneye/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
