#!/bin/bash

xhost +si:localuser:$(id -un)

docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
           -e DISPLAY=$DISPLAY \
           --user=$(id -u):$(id -g) \
           -ti docker-opengl-x11

xhost -si:localuser:$(id -un)