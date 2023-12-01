#!/bin/bash
# check if the docker engine is available for current user
if ! docker info > /dev/null 2>&1; then
  echo "$(tput setaf 1)ERROR: This script uses docker, and it isn't running - please start docker and try again!$(tput sgr0)"
  exit 1
fi

if [[ $(id -nG | grep -wq "docker"; echo $?) -ne 0 ]]; then
    echo "$(tput setaf 1)ERROR: You do not have the docker access right now, please contact your system admin to obtain!"
    exit 1
fi

if [ "$(ip -4 addr show | grep "wlp")" = "" ]; then
    PROXY_IPV4="127.0.0.1"
else
    PROXY_IPV4=$(ip -4 addr show wlp0s20f3 | grep -Po 'inet \K[\d.]+')
fi
PROXY_PORT="7890"
read -p "$(tput setaf 2)> Do you prefer using Network Proxy? (y/n): $(tput sgr0)" PREFER_PROXY
if [ "$PREFER_PROXY" = "y" -o "$PREFER_PROXY" = "" ]; then
    read -p "$(tput setaf 2)> Please specify your proxy ip addr: (default: $PROXY_IPV4)$(tput sgr0)" CUSTOM_PROXY_IPV4
    read -p "$(tput setaf 2)> Please specify your proxy port: (default: $PROXY_PORT)$(tput sgr0)" CUSTOM_PROXY_PORT
fi
if [ -n "$CUSTOM_PROXY_IPV4" ]; then PROXY_IPV4="$CUSTOM_PROXY_IPV4"; fi
if [ -n "$CUSTOM_PROXY_PORT" ]; then PROXY_PORT="$CUSTOM_PROXY_PORT"; fi

NVIM_IDE_NAME="nvim_ide"
if [ "$(docker images | awk '{ print $1 }' | grep "$NVIM_IDE_NAME")" = "" ];then
    if [ "$PREFER_PROXY" = "y" -o "$PREFER_PROXY" = "" ]; then
        docker build -t $NVIM_IDE_NAME . --build-arg https_proxy=http://$PROXY_IPV4:$PROXY_PORT --build-arg http://$PROXY_IPV4:$PROXY_PORT
    else
        docker build -t $NVIM_IDE_NAME .
    fi
fi

NVIM_IDE_CONTAINER_NAME="nvim_ide_runner"
if [ "$(docker ps -a -q -f name=$NVIM_IDE_CONTAINER_NAME)" ]; then
    if [ "$(docker inspect -f {{.State.Running}} $NVIM_IDE_CONTAINER_NAME 2>/dev/null)" = "true" ]; then
        docker attatch $NVIM_IDE_CONTAINER_NAME
    else
        docker start $NVIM_IDE_CONTAINER_NAME
    fi
else
    if [ "$PREFER_PROXY" = "y" -o "$PREFER_PROXY" = "" ]; then
        docker run -itd --privileged -P                             \
               -h pennix --name $NVIM_IDE_CONTAINER_NAME            \
               -e "DOCKER_HOST=${PROXY_IPV4}" \
               -e "http_proxy=http://${PROXY_IPV4}:${PROXY_PORT}"   \
               -e "https_proxy=https://${PROXY_IPV4}:${PROXY_PORT}" \
               $NVIM_IDE_NAME:latest /bin/zsh
    else
        docker run -itd --privileged -P                             \
               -h pennix --name $NVIM_IDE_CONTAINER_NAME            \
               $NVIM_IDE_NAME:latest /bin/zsh
    fi
fi