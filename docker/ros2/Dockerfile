ARG ROS_DISTRO=foxy

FROM ros:$ROS_DISTRO
LABEL AUTHOR='Brandon Fan'

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


# install deps
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    git \
    vim \
    nano \
    python-dev \
    python3-pip \
    libeigen3-dev \
    libopencv-dev \
    opencv-data \
    libglew-dev \
    ffmpeg \
    libboost-system-dev \
    libcanberra-gtk-module libboost-all-dev

# pip dependencies
RUN pip3 install --upgrade \
    pip \
    numpy

# pangolin
WORKDIR /usr/src/pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build .

# orbslam
WORKDIR /usr/src/orbslam2
RUN git clone https://github.com/open-shade/orbslam2.git ORB_SLAM2 && \
    cd ORB_SLAM2 && \
    LD_LIBRARY_PATH=/usr/src/pangolin/Pangolin/build/src/:$LD_LIBRARY_PATH bash build.sh

# orbslam 2 realsense config files
WORKDIR /usr/src/realsense2-orbslam2
RUN git clone https://github.com/NERanger/ORB-SLAM2-with-D435i.git ORB_SLAM2 && \
    cd ORB_SLAM2 && \
    tar xf Vocabulary/ORBvoc.txt.tar.gz
    

# ros
WORKDIR /usr/src/ros_ws
RUN git clone https://github.com/alsora/ros2-ORB_SLAM2 src/ros2-ORB_SLAM2 && \
    git clone -b ros2 https://github.com/ros-perception/vision_opencv.git src/vision_opencv && \
    bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash && \
        export LDFLAGS="-Wl,--copy-dt-needed-entries" && \
        export ORB_SLAM2_ROOT_DIR=/usr/src/orbslam2/ORB_SLAM2 && \
        colcon build --symlink-install'

WORKDIR /root

# Source ROS workspaces when opening new terminal
RUN echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> .bashrc && \
	echo 'source /usr/src/ros_ws/install/setup.bash' >> .bashrc && \
	echo 'export ORB_SLAM2_ROOT_DIR=/usr/src/orbslam2/ORB_SLAM2' >> .bashrc && \
	echo 'export LD_LIBRARY_PATH=~/usr/src/pangolin/Pangolin/build/src/:/usr/src/orbslam2/ORB_SLAM2/Thirdparty/DBoW2/lib:/usr/src/orbslam2/ORB_SLAM2/Thirdparty/g2o/lib:/usr/src/orbslam2/ORB_SLAM2/lib:$LD_LIBRARY_PATH' >> .bashrc

RUN echo '#!/bin/bash -i' >> run.sh && \
	echo 'ros2 run ros2_orbslam rgbd \' >> run.sh && \
   	echo '    /usr/src/realsense2-orbslam2/ORB_SLAM2/ORBvoc.txt \' >> run.sh && \
   	echo '    /usr/src/realsense2-orbslam2/ORB_SLAM2/Examples/RGB-D/d435i.yaml \' >> run.sh && \
   	echo '    --ros-args -r /camera/rgb:=/camera/color/image_raw \' >> run.sh && \
   	echo '    -r /camera/depth:=/camera/depth/image_rect_raw' >> run.sh && \
	chmod +x ~/run.sh

CMD ["./run.sh"]
