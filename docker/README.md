# Docker image
This is a wrapper containing all of the dependencies needed to build glow, pytorch and opencv c++ enviroment

## Building container
To build the container, `cd` into the directory containing the Dockerfile and run:
```bash
docker build -t <docker name> .
```
User can run the docker/build.sh directly

## Dockerfile config

User can search pytorch, glow or opencv for docker file template
For example, 
* cpu of pytorch see https://github.com/pytorch/pytorch/blob/9ba2530d426ada36ae4f874689acce40f6ba2b80/.circleci/docker/ubuntu/Dockerfile


## Running container
1. Clone glow repository to some `/my/path/glow`
2. Create `/my/path/build_Debug` and `/my/path/build_Release`
3. Run container using
```bash
docker run -it -v /my/path/:/root/dev pytorch/glow
```

Use the shell to build glow in the `/root/dev` folder as you normally would. All dependencies should already be satisfied. 

If you want an additional shell to access the container, run `docker ps` to find the container name and then run `docker exec -it container_name /bin/bash`.

Note that this will mount the local glow source folder into the docker container. Edits made in the container are persistent (since they are effectively made on the host). Similarly, you can edit the files on the host (in your favourite text editor) and have them immediately reflected in the container.
