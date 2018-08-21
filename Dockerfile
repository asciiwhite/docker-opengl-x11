FROM alpine:3.8

RUN apk --update add --no-cache \
        mesa-dri-swrast \
        mesa-demos