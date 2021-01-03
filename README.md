# dockerfile-env-setup
used to setup ubuntu+ros environment and enable display setting and shared folder

Please use u18-ros-melodic.sh to launch ubuntu18+ros-melodic;
Please use u16-ros-kinetic.sh to launch ubuntu16+ros-kinetic;

Or you may specify your own docker image version;
The shared folder location is: $HOME/shared_dir in host system and /root/shared_dir in docker container;

Please use "docker start $NAME" to launch this container. 
And use "docker exec -it $NAME bash" to interactive with this container. 
After usage, please use "docker stop $NAME" to stop this container.
Please use "docker rm $NAME" to remove this container.
