#!/bin/bash

set -e

# Default Settings
NAME="u18-melodic"
CUDA="on"  # "on" or "off"
IMAGE_NAME="zack/ros"
IMAGE_TAG="melodic"
IMAGE=$IMAGE_NAME:$IMAGE_TAG
echo -e "ROS distro: $IMAGE"

SHARED_DOCKER_DIR=/root/shared_dir
SHARED_HOST_DIR=$HOME/shared_dir

RUNTIME=""

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.docker.xauth

echo "Preparing Xauthority data..."
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    echo -e "$XAUTH not exists. Create it now."
    touch $XAUTH
    chmod a+r $XAUTH
fi
if [ ! -z "$xauth_list" ]; then
    echo -e "merge xauth list to file $XAUTH"
    echo $xauth_list | xauth -f $XAUTH nmerge -
fi
echo "Done."
echo -e "\nVerifying file contents:"
file $XAUTH
echo "--> It should say \"X11 Xauthority data\"."
echo -e "\nPermissions:"
ls -FAlh $XAUTH
echo -e "\nRunning docker..."

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
        --env="QT_X11_NO_MITSHM=1" \
        --privileged \
        --net=host \
        --name=$NAME \
        $RUNTIME \
        $IMAGE
fi
