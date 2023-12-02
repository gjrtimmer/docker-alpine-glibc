ARG DOCKER_IMAGE_BASE
FROM ${DOCKER_IMAGE_BASE}

ARG GLIBC=2.35-r1

ENV LANG=C.UTF-8 \
    GLIBC_VERSION=${GLIBC}

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$GLIBC_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$GLIBC_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$GLIBC_VERSION.apk" && \
    apk add --no-cache --force-overwrite --virtual=.build-dependencies wget ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget \
    "$ALPINE_GLIBC_BASE_URL/$GLIBC_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BASE_URL/$GLIBC_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BASE_URL/$GLIBC_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache --force-overwrite \
    "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n && \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm  "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"    

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF
ARG DOCKER_IMAGE_BASE

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    build_version="${BUILD_DATE}" \
    org.opencontainers.image.authors="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="${CI_PROJECT_NAME}" \
    org.opencontainers.image.url="${CI_PROJECT_URL}" \
    org.opencontainers.image.documentation="${CI_PROJECT_URL}" \
    org.opencontainers.image.source="${CI_PROJECT_URL}.git" \
    org.opencontainers.image.ref.name=${VCS_REF} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.base.name="${DOCKER_IMAGE_BASE}" \
    org.opencontainers.image.licenses=MIT \
    org.opencontainers.image.vendor=timmertech.nl \
    org.gnu.glibc=${GLIBC}
