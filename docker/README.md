# Docker image
This is a wrapper containing all of the dependencies needed to build glow, pytorch and opencv c++ enviroment

## Building container
To build the container, `cd` into the directory containing the Dockerfile and run:
```bash
docker build -t <docker name> .
```
User can run the docker/build.sh directly

User can also build your own container from template.
search pytorch, glow or opencv for docker file template
For example, 
* cpu of pytorch see https://github.com/pytorch/pytorch/blob/9ba2530d426ada36ae4f874689acce40f6ba2b80/.circleci/docker/ubuntu/Dockerfile

if you want to use GPU on docker, please install gpu toolkit. see link here 
https://github.com/NVIDIA/nvidia-docker



## Running container

run docker 
```docker run --restart=always --privileged=true -v ~/Documents/Working:/workspace -d pytorch_opencv_glow sleep infinity & wait```

list all containers to find container id.
```
>>  docker container ls

CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                              NAMES
e4fff25e8cd5        pytorch_opencv_glow         "sleep infinity"    5 seconds ago       Up 5 seconds
```

launch docker and eneter it

```docker exec -it <container_id> bash```


If you want an additional shell to access the container, run `docker ps` to find the container name and then run `docker exec -it container_name /bin/bash`.

Note that this will mount the local  folder into the docker container. Edits made in the container are persistent (since they are effectively made on the host). Similarly, you can edit the files on the host (in your favourite text editor) and have them immediately reflected in the container.


# Other setup

default cc and c++ compiler is clang now. User can switch to gcc if need
>>> update-alternatives --set cc 
>>> update-alternatives --set c++ 
