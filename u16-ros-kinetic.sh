#!/bin/bash

set -e

# Default Settings
NAME="u16-kinetic"
CUDA="on"  # "on" or "off"
IMAGE_NAME="ros"
IMAGE_TAG="kinetic-robot"
IMAGE=$IMAGE_NAME:$IMAGE_TAG
echo -e "ROS distro: $IMAGE"

RUNTIME=""

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

SHARED_DOCKER_DIR=/root/shared_dir
SHARED_HOST_DIR=$HOME/shared_dir

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"

DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' | cut --delimiter=. --fields=1,2)
if [ $CUDA == "on" ]; then
    if [[ ! $DOCKER_VERSION < "19.03" ]] && ! type nvidia-docker; then
        RUNTIME="--gpus all"
    else
        RUNTIME="--runtime=nvidia"
    fi
fi

# Create the shared directory in advance to ensure it is owned by the host user
mkdir -p $SHARED_HOST_DIR

if [ "$(docker ps -aq -f name=$NAME)" ]; then
    echo -e "\n***Container $NAME exists.***\n\nPlease use \"docker start $NAME\" to launch this container. And use \"docker exec -it $NAME bash\" to interactive with this container. After usage, please use \"docker stop $NAME\" to stop this container."
    echo -e "Or you may use \"docker rm $NAME\" to remove this container and re-run this script to create the container again."
    # docker rm $NAME
else
    echo "Launching $IMAGE"
    docker run \
        -it \
        $VOLUMES \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY=${DISPLAY}" \
        --privileged \
        --net=host \
        --name=$NAME \
        $RUNTIME \
        $IMAGE
fi
