FROM ubuntu:latest
LABEL Author="Lonnie L. Souder II"

ARG USER_ID
ARG GROUP_ID
ARG USERNAME=lsouder

ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add user
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y sudo && \
    addgroup --gid $GROUP_ID $USERNAME && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
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

# Install VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    sudo apt-get update && \
    sudo apt-get install -y code libx11-xcb1 libasound2 x11-apps libice6 libsm6 libxaw7 libxft2 libxmu6 libxpm4 libxt6 x11-apps xbitmaps && \
    sudo rm packages.microsoft.gpg && \
    code --version

CMD bash#
