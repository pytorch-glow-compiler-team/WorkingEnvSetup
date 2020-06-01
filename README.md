# WorkingEnvSetup

### Step 1 create docker virtual envoriment 

Setup docker
step by step flow:

get docker image from https://hub.docker.com/r/pytorch/pytorch
docker pull pytorch/pytorch

you can use command docker image ls to see all those images in your system

Run docker image, please provide your personal folder as workdir
docker run --restart=always --privileged=true -v ~/Documents/Working:/workspace -d pytorch/pytorch sleep infinity & wait

start virtual linux env bash
use docker container ls to find the container id

run bash: docker exec -it 9b2c73057ff0 /bin/bash
