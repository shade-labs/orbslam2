FROM ros:foxy
LABEL AUTHOR='Brandon Fan'

ARG VOC_PATH="./Vocabulary/ORBvoc.txt"
ARG SETTINGS_PATH="../ws/src/ros2-ORB_SLAM2/src/monocular/TUM1.yaml"
ARG ALGO_TYPE="mono"

# working directory
ENV HOME /root
WORKDIR $HOME

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# general utilities
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    vim \
    nano \
    python-dev \
    python3-pip

RUN sudo apt-get install libeigen3-dev

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

# create a ros2 workspace
RUN mkdir -p $HOME/ws/src
WORKDIR $HOME/ws

# get some dependencies
RUN apt-get install -y libcanberra-gtk-module libboost-all-dev
RUN pip install numpy

# get source code
RUN git clone https://github.com/alsora/ros2-ORB_SLAM2 src/ros2-ORB_SLAM2
RUN git clone -b ros2 https://github.com/ros-perception/vision_opencv.git src/vision_opencv

# build the workspace
RUN  bash -c 'source /opt/ros/foxy/setup.bash && \
  export LDFLAGS="-Wl,--copy-dt-needed-entries" && \
  export ORB_SLAM2_ROOT_DIR=~/ORB_SLAM2 && \
  colcon build --symlink-install'

#### SET ENVIRONMENT

WORKDIR $HOME

# Source ROS workspaces when opening new terminal
RUN echo ' \n\
echo "Sourcing ROS2 packages..." \n\
source /opt/ros/foxy/setup.bash \n\
source $HOME/ws/install/local_setup.sh' >> $HOME/.bashrc

# Set ORB_SLAM2_ROOT_DIR
RUN echo ' \n\
export ORB_SLAM2_ROOT_DIR=~/ORB_SLAM2' >> $HOME/.bashrc

# add orbslam shared libraries to path
RUN echo ' \n\
export LD_LIBRARY_PATH=~/Pangolin/build/src/:~/ORB_SLAM2/Thirdparty/DBoW2/lib:~/ORB_SLAM2/Thirdparty/g2o/lib:~/ORB_SLAM2/lib:$LD_LIBRARY_PATH' >> $HOME/.bashrc

WORKDIR $HOME/ORB_SLAM2

ENV VOC_PATH=$VOC_PATH
ENV SETTINGS_PATH=$SETTINGS_PATH
ENV ALGO_TYPE=$ALGO_TYPE

SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash", "-c", "source /opt/ros/foxy/setup.bash && source ../ws/install/local_setup.sh && ros2 run ros2_orbslam mono ./Vocabulary/ORBvoc.txt ../ws/src/ros2-ORB_SLAM2/src/monocular/TUM1.yaml"]
