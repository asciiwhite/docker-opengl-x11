#!/bin/bash

xhost +si:localuser:root

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -ti docker-opengl

xhost -si:localuser:root