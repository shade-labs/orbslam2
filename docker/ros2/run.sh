#!/bin/bash

DOCKER_BUILDKIT=1 docker build -t shaderobotics/orbslam2-ros2 .

export DISPLAY=:0.0
xhost +local:docker

docker run -it --rm \
  -v /dev/shm:/dev/shm \
  --env="DISPLAY" \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  --privileged \
  --net=host \
  shaderobotics/orbslam2-ros2 $@
