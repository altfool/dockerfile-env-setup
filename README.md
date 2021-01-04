# dockerfile-env-setup
used to setup ubuntu+ros environment and enable display setting and shared folder

# build docker images
u18: "docker build -t zack/ros:melodic -f u18-ros-melodic-dockerfile ."

u16: "docker build -t zack/ros:kinetic -f u16-ros-kinetic-dockerfile ."

# launch images
Please use u18-ros-melodic-run.sh to launch ubuntu18+ros-melodic;

Please use u16-ros-kinetic-run.sh to launch ubuntu16+ros-kinetic;

Or you may specify your own docker image version;

The shared folder location is: $HOME/shared_dir in host system and /root/shared_dir in docker container;

Please use "docker start $NAME" to launch this container. 
And use "docker exec -it $NAME bash" to interactive with this container. 
After usage, please use "docker stop $NAME" to stop this container.
Please use "docker rm $NAME" to remove this container.

# problems
If you encounter any problem related to the XAUTH file, please use the shell script fix-auth.sh to fix this.
