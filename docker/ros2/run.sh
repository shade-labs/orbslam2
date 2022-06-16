#!/bin/bash
#
# @author Alberto Soragna (alberto dot soragna at gmail dot com)
# Modified by Emerson Dove
# @2018

XSOCK=/tmp/.X11-unix

# --runtime=nvidia \
docker run -it --rm \
 -e DISPLAY=$DISPLAY \
 -v $XSOCK:$XSOCK \
 -v $HOME/.Xauthority:/root/.Xauthority \
 --privileged \
 --net=host \
 shaderobotics/orbslam2-ros2
