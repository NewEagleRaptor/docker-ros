# neweagle/docker-ros - This is the base ROS runtime image.

######
# Section 1: "Includes"
#
# These are other Dockerfiles that we'd like to
# include, but docker doesn't do that.  So we've cut and pasted them,
# faithfully and commented out their "FROM".
# DO NOT modify, edit, etc unless updating to a newer version

######################################################################
#INCLUDE https://github.com/osrf/docker_images/blob/master/ros/melodic/melodic-ros-core/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:melodic-ros-core
# generated from templates/docker_images/create_ros_core_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
FROM ubuntu:bionic

# setup environment
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

# install packages
RUN apt-get update && apt-get install -q -y dirmngr gnupg2 lsb-release && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y python-rosdep python-rosinstall python-vcstools && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y ros-melodic-ros-core=1.4.1-0* && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/melodic/melodic-ros-base/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:melodic-ros-base
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:melodic-ros-core

# install ros packages
RUN apt-get update && apt-get install -y ros-melodic-ros-base=1.4.1-0* && rm -rf /var/lib/apt/lists/*

######################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/melodic/melodic-desktop/Dockerfile
######################################################################
# This is an auto generated Dockerfile for ros:melodic-desktop
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
##FROM ros:melodic-ros-base

# install ros packages
RUN apt-get update && apt-get install -y ros-melodic-desktop=1.4.1-0* && rm -rf /var/lib/apt/lists/*

#####################################################################
# INCLUDE https://github.com/osrf/docker_images/blob/master/ros/melodic/melodic-desktop-full/Dockerfile
#####################################################################
# This is an auto generated Dockerfile for ros:melodic-desktop-full
# generated from templates/docker_images/create_ros_image.Dockerfile.em
# generated on 2017-01-27 02:33:52 +0000
#FROM osrf/ros:melodic-desktop

# install ros packages
RUN apt-get update && apt-get install -y ros-melodic-desktop-full=1.4.1-0* && rm -rf /var/lib/apt/lists/*

######
# Section 2: Custom
#
# Everthing above this point gives us a clean base image, and everything below
# is New Eagle specific setup.

##    ros-melodic-qglv-toolkit \
# ROS dependencies
RUN apt-get update && apt-get -y install ros-melodic-desktop-full ros-melodic-nmea-msgs ros-melodic-nmea-navsat-driver ros-melodic-sound-play ros-melodic-jsk-visualization ros-melodic-joy ros-melodic-can-msgs ros-melodic-um7 python-rosinstall python-rosinstall-generator libnlopt-dev freeglut3-dev qtbase5-dev libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev libgl1-mesa-dev python-bson python-bson-ext python-openssl python-pam python-twisted-bin python-twisted-core python-zope.interface python3-apt python3-pycurl python3-gi python-setuptools python-pip gir1.2-gtk-3.0 python3-aptdaemon.gtk3widgets linux-headers-generic software-properties-common ubuntu-drivers-common libgtk2-perl dkms && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get --no-install-recommends -y install libhdf5-dev python-h5py git ssh vim gnome-terminal usbutils && rm -rf /var/lib/apt/lists/*

# Cython must be installed as a seperate layer
RUN pip install cython==0.25.2

# AutonomouStuff Packages and dependencies
RUN apt-get update && apt-get -y install apt-transport-https && rm -rf /var/lib/apt/lists/* 
RUN echo "deb [trusted=yes] https://s3.amazonaws.com/autonomoustuff-repo/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/autonomoustuff-public.list
RUN echo "yaml https://s3.amazonaws.com/autonomoustuff-repo/autonomoustuff-public-$ROS_DISTRO.yaml $ROS_DISTRO" > /etc/ros/rosdep/sources.list.d/40-autonomoustuff-public-'$ROS_DISTRO'.list
RUN apt-get update && apt-get -y install ros-$ROS_DISTRO-kvaser-interface && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository ppa:jwhitleyastuff/kvaser-linux

RUN apt-get update -qq && apt-get install -y -q \
    kvaser-canlib-dev \
    kvaser-drivers-dkms \
    && rm -rf /var/lib/apt/lists/*

######
# Add basic user
# # Replace 1000 with your user/group id
ENV USERNAME user
RUN useradd -m $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && usermod --shell /bin/bash $USERNAME && usermod -aG sudo $USERNAME && usermod -aG dialout $USERNAME && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME && usermod --uid 1000 $USERNAME && groupmod --gid 1000 $USERNAME -o

RUN chown -R $USERNAME /home/$USERNAME && chgrp -R $USERNAME /home/$USERNAME

# Change user
USER $USERNAME

# do resdep update as the user
RUN rosdep update

###
# Setup .bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /home/$USERNAME/pacifica-dbw-ros/devel/setup.bash" >> /home/$USERNAME/.bashrc
#Fix for autoware qt and X server errors
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc

WORKDIR /home/user/pacifica-dbw-ros

CMD ["bash"]