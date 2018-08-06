# Mesa3D Software Drivers
#
# VERSION 18.0.1

FROM alpine:3.7

# Build arguments.
ARG MESA_DEMOS="false"

# Install all needed deps and compile the mesa llvmpipe driver from source.
RUN set -xe; \
    apk --update add --no-cache --virtual .runtime-deps llvm5-libs; \
    apk add --no-cache --virtual .build-deps llvm-dev build-base zlib-dev glproto xorg-server-dev python-dev;

RUN set -xe; \
    mkdir -p /var/tmp/build; \
    cd /var/tmp/build; \
    wget "https://mesa.freedesktop.org/archive/mesa-18.0.1.tar.gz"; \
    tar xfv mesa-18.0.1.tar.gz; \
    rm mesa-18.0.1.tar.gz;

RUN cd /var/tmp/build/mesa-18.0.1; \
    ./configure --enable-glx --with-gallium-drivers=swrast,swr --disable-dri --disable-gbm --enable-egl --enable-dri --prefix=/usr/local; \
    make -j$(nproc); \
    make install; \
    cd .. ; \
    rm -rf mesa-18.0.1; \
    if [ "${MESA_DEMOS}" == "true" ]; then \
        apk add --no-cache --virtual .mesa-demos-runtime-deps glu glew \
        && apk add --no-cache --virtual .mesa-demos-build-deps glew-dev freeglut-dev \
        && wget "ftp://ftp.freedesktop.org/pub/mesa/demos/mesa-demos-8.4.0.tar.gz" \
        && tar xfv mesa-demos-8.4.0.tar.gz \
        && rm mesa-demos-8.4.0.tar.gz \
        && cd mesa-demos-8.4.0 \
        && ./configure --prefix=/usr/local \
        && make -j$(nproc) \
        && make install \
        && cd .. \
        && rm -rf mesa-demos-8.4.0 \
        && apk del .mesa-demos-build-deps; \
    fi; \
    apk del .build-deps;

# Setup our environment variables.
ENV LIBGL_ALWAYS_SOFTWARE="1" \
    GALLIUM_DRIVER="llvmpipe" \
    LP_NO_RAST="false" \
    LP_DEBUG="" \
    LP_PERF="" \
    LP_NUM_THREADS=""
