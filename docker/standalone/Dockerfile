FROM ubuntu:focal
LABEL AUTHOR='Emerson Dove'

# working directory
ENV HOME /root
WORKDIR $HOME

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get install -y tzdata

# general utilities
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python-dev \
    python3-pip \
    sudo \
    cmake

RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get install libeigen3-dev -y

# pip
RUN pip3 install --upgrade pip

WORKDIR $HOME

# install pangolin depenendencies
RUN apt-get update && apt-get install -y \
  libopencv-dev opencv-data \
  libglew-dev \
  ffmpeg

# get pangolin sources
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
RUN mkdir -p $HOME/Pangolin/build
WORKDIR $HOME/Pangolin/build

# build pangolin
RUN cmake ..
RUN cmake --build .

WORKDIR $HOME

# working directory
ENV HOME /root
WORKDIR $HOME

# get orbslam sources
RUN git clone https://github.com/open-shade/orbslam2.git ORB_SLAM2

# install orbslam depenendencies
RUN apt-get install -y \
  libboost-system-dev

# build orbslam
WORKDIR $HOME/ORB_SLAM2
# Note, you might have to change build.sh to be make -j1 at the end depending on your memory constraints
RUN chmod +x $HOME/ORB_SLAM2/build.sh
RUN /bin/bash -c 'export LD_LIBRARY_PATH=~/Pangolin/build/src/:$LD_LIBRARY_PATH; \
  bash $HOME/ORB_SLAM2/build.sh'
