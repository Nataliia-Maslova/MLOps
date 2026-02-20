#!/bin/bash

LOG="install.log"
echo "Starting installation..." | tee -a $LOG

check_command() {
    command -v $1 >/dev/null 2>&1
}

# Docker
if ! check_command docker; then
    echo "Installing Docker..." | tee -a $LOG
    sudo apt update
    sudo apt install -y docker.io
else
    echo "Docker already installed." | tee -a $LOG
fi

# Docker Compose
if ! check_command docker-compose; then
    echo "Installing Docker Compose..." | tee -a $LOG
    sudo apt install -y docker-compose
else
    echo "Docker Compose already installed." | tee -a $LOG
fi

# Python
if ! check_command python3; then
    echo "Installing Python..." | tee -a $LOG
    sudo apt install -y python3 python3-pip
else
    echo "Python already installed." | tee -a $LOG
fi

# ML libraries
pip3 show torch >/dev/null 2>&1 || pip3 install torch torchvision pillow

echo "Installation completed." | tee -a $LOG