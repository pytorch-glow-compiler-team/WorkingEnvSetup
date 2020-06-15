set -e

## step 1: build
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug ../
ninja all

# step 2: download all data under build folder if need. Default is off
#python ../utils/download_datasets_and_models.py -D -C -O

# step 3: run all unit test

