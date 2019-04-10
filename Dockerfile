# neweagle/ros - This is the base ROS runtime image.

FROM ubuntu:trusty

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

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-base=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop-full=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*


######
# Section 2: Custom
#
# Everthing above this point gives us a clean base image, and everything below
# is specific to New Eagle.

# ROS dependencies
RUN apt-get update && apt-get -y install \
    ros-indigo-desktop-full \
    ros-indigo-jsk-visualization \
    ros-indigo-qglv-toolkit \
    ros-indigo-joy \
    ros-indigo-can-msgs \
    python-rosinstall \
    python-rosinstall-generator \
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
    ros-indigo-rosauth \
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

# NOTE: install pip with easy_install rather than apt-get, so that
# we can update it with itself later
# Cython must be installed as a seperate layer
RUN easy_install pip && pip install cython==0.25.2

# local packages

# might need linux_can package?
COPY ./debs /debs
RUN dpkg -i /debs/linux-can.deb 

# AutonomouStuff Packages
#RUN dpkg -i /debs/ros-indigo-lusb_1.0.9-0trusty-20171020-102527-0400_amd64.deb

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
RUN echo "source /home/$USERNAME/commander/devel/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "if [[ \"\$PRIME_SELECT_INTEL\" -eq 1 ]]; then sudo prime-select intel; fi" >> /home/$USERNAME/.bashrc
#Fix for autoware qt and X server errors
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc

# setup rviz defaults
RUN mkdir /home/$USERNAME/.rviz
RUN ln -s /home/$USERNAME/commander/rviz/default.rviz /home/$USERNAME/.rviz/default.rviz

WORKDIR /home/$USERNAME/

## setup entrypoint
##COPY ./ros_entrypoint.sh /
##
##ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
