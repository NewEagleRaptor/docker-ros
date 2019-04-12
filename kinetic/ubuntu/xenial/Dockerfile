# neweagle/docker-ros - This is the base ROS runtime image.

######
# Section 1: "Includes"
#
# These are other Dockerfiles that we'd like to
# include, but docker doesn't do that.  So we've cut and pasted them,
# faithfully and commented out their "FROM".
# DO NOT modify, edit, etc unless updating to a newer version

######################################################################
#INCLUDE https://github.com/osrf/docker_images/blob/master/ros/kinetic/kinetic-ros-core/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:kinetic-ros-core
# generated from templates/docker_images/create_ros_core_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
FROM ubuntu:xenial

# setup environment
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
##RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
  RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
##RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list
##RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list
  RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-core=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/kinetic/kinetic-ros-base/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:kinetic-ros-base
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:kinetic-ros-core

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-base=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/kinetic/kinetic-desktop/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:kinetic-desktop
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:kinetic-ros-base

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

#####################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/kinetic/kinetic-desktop-full/Dockerfile
#####################################################################
# This is an auto generated Dockerfile for ros:kinetic-desktop-full
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
#FROM osrf/ros:kinetic-desktop

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*


######
# Section 2: Custom
#
# Everthing above this point gives us a clean base image, and everything below
# is New Eagle specific setup.

##    ros-kinetic-qglv-toolkit \
# ROS dependencies
RUN apt-get update && apt-get -y install \
    ros-kinetic-desktop-full \
    ros-kinetic-nmea-msgs \
    ros-kinetic-nmea-navsat-driver \
    ros-kinetic-sound-play \
    ros-kinetic-jsk-visualization \
    ros-kinetic-joy \
    ros-kinetic-libsensors-monitor \
    ros-kinetic-can-msgs \
    ros-kinetic-um7 \
    python-rosinstall \
    python-rosinstall-generator \
    libnlopt-dev \
    freeglut3-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libssh2-1-dev \
    libarmadillo-dev \
    libpcap-dev \
    gksu \
    libgl1-mesa-dev \
    python-bson \
    python-bson-ext \
    python-openssl \
    python-pam \
    python-twisted-bin \
    python-twisted-core \
    python-zope.interface \
    python3-apt \
    python3-pycurl \
    python3-gi \
    gir1.2-gtk-3.0 \
    python3-aptdaemon.gtk3widgets \
    linux-headers-generic \  
    software-properties-common \  
    ubuntu-drivers-common \
    libgtk2-perl \
    dkms \ 
    && rm -rf /var/lib/apt/lists/*

# 1. h5
# 2. Devel Essentials
# 3. Autoware Deps
RUN apt-get update && apt-get --no-install-recommends -y install \
    libhdf5-dev \
    python-h5py \
    git \
    ssh \
    vim \
    gnome-terminal \
    usbutils \
    && rm -rf /var/lib/apt/lists/*

##    libgeos-dev \
##    libgeographiclib-dev \
##    libspatialindex-dev \
##    libcanberra-gtk-module \

# Cython must be installed as a seperate layer
RUN easy_install pip && pip install cython==0.25.2

# local packages
COPY ./debs /debs
RUN dpkg -i /debs/libsbp_2.2.12-1_amd64.deb
RUN dpkg -i /debs/linux-can.deb

# AutonomouStuff Packages and dependencies
RUN dpkg -i /debs/python3-software-properties_0.96.20.8_all.deb
RUN dpkg -i /debs/software-properties-gtk_0.96.20.8_all.deb
RUN dpkg -i /debs/software-properties-common_0.96.20.8_all.deb
RUN dpkg -i /debs/linuxcan-dkms_5.26.679-0ubuntu0~ppa1_amd64.deb

######
# Add basic user
# # Replace 1000 with your user/group id
ENV USERNAME user
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        usermod -aG dialout $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        usermod  --uid 1000 $USERNAME && \
        groupmod --gid 1000 $USERNAME -o

RUN chown -R $USERNAME /home/$USERNAME && chgrp -R $USERNAME /home/$USERNAME

# Change user
USER $USERNAME

# do resdep update as the user
RUN rosdep update

###
# Setup .bashrc
RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /home/$USERNAME/pacifica-dbw-ros/devel/setup.bash" >> /home/$USERNAME/.bashrc
#Fix for autoware qt and X server errors
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc

# setup rviz defaults
RUN mkdir /home/$USERNAME/.rviz
RUN ln -s /home/$USERNAME/pacifica-dbw-ros/rviz/default.rviz /home/$USERNAME/.rviz/default.rviz

WORKDIR /home/$USERNAME/pacifica-dbw-ros

## setup entrypoint
##COPY ./ros_entrypoint.sh /
##
##ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]