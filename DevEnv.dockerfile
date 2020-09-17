FROM ubuntu:latest
LABEL Author="Lonnie L. Souder II"

ARG USERNAME=lsouder

ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add user
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y sudo && \
    useradd --create-home --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    su - $USERNAME -c "touch mine" && \
    ls -lh /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# General
RUN sudo apt-get install -y git vim python3 python3-pip net-tools nmap

# Install CMake
RUN sudo apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    sudo apt-get update && \
    sudo apt-get install kitware-archive-keyring && \
    sudo rm /etc/apt/trusted.gpg.d/kitware.gpg && \
    sudo apt-get install -y cmake gcc nasm make && \ 
    cmake --version

# Install protobuf
RUN sudo apt-get install -y autoconf automake libtool curl make g++ unzip && \
    wget --no-check-certificate https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protobuf-cpp-3.13.0.tar.gz && \
    ls -lha && \
    tar -xvf protobuf-cpp-3.13.0.tar.gz && \
    cd protobuf-3.13.0 && \
     ./configure && \
     make && \
     make check && \
     sudo make install && \
     sudo ldconfig

# Install OpenCV
RUN wget --no-check-certificate https://github.com/opencv/opencv/archive/3.4.10.tar.gz && \
    tar -xvf 3.4.10.tar.gz && \
    cd opencv-3.4.10 && \
    mkdir build/ && \
    cd build && \
    cmake .. && \
    cmake --build . && \
    sudo make install

CMD bash
