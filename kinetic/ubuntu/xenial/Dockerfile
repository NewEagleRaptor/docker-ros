# voyage/ros - This is the base ROS runtime image.

######
# Section 1: "Includes"
#
# These are other Dockerfiles that we'd like to
# include, but docker doesn't do that.  So we've cut and pasted them,
# faithfully and commented out their "FROM".
# DO NOT modify, edit, etc unless updating to a newer version

######################################################################
#INCLUDE https://github.com/osrf/docker_images/blob/master/ros/indigo/indigo-ros-core/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:indigo-ros-core
# generated from templates/docker_images/create_ros_core_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
FROM ubuntu:xenial

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# setup keys
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list

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
ENV ROS_DISTRO indigo
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-core=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/indigo/indigo-ros-base/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:indigo-ros-base
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:indigo-ros-core

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-base=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/indigo/indigo-desktop/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:indigo-desktop
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:indigo-ros-base

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*

#####################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/indigo/indigo-desktop-full/Dockerfile
#####################################################################
# This is an auto generated Dockerfile for ros:indigo-desktop-full
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
#FROM osrf/ros:indigo-desktop

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop-full=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*


######
# Section 2: Custom
#
# Everthing above this point gives us a clean base image, and everything below
# is voyage specific setup.

######
# First: do the rest of the cuda install (and apsell first, because it screws
# up dependencies for some reason)
##RUN apt-get update && apt-get install -y aspell

# ROS dependencies
RUN apt-get update && apt-get -y install \
    ros-indigo-desktop-full \
    ros-indigo-nmea-msgs \
    ros-indigo-nmea-navsat-driver \
    ros-indigo-sound-play \
    ros-indigo-jsk-visualization \
    ros-indigo-qglv-toolkit \
    ros-indigo-joy \
    ros-indigo-libsensors-monitor \
    ros-indigo-can-msgs \
    ros-indigo-um7 \
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
    libgeos-dev \
    libgeographiclib-dev \
    libspatialindex-dev \
    libcanberra-gtk-module \
    gnome-terminal \
    usbutils \
    && rm -rf /var/lib/apt/lists/*

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
RUN echo "source /opt/ros/indigo/setup.bash" >> /home/$USERNAME/.bashrc
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