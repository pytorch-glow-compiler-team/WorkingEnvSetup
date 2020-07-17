#!/usr/bin/env bash

# install common dep. see this link: https://github.com/microsoft/onnxruntime/blob/master/dockerfiles/scripts/install_common_deps.sh
apt-get update && apt-get install -y --no-install-recommends \
        wget \
        zip \
        ca-certificates \
        build-essential \
        curl \
        libcurl4-openssl-dev \
        libssl-dev \
        python3-dev

# clone the code and use product release version
git clone --single-branch --branch v1.4.0 --recursive https://github.com/Microsoft/onnxruntime onnxruntime
cd onnxruntime

/bin/sh ./build.sh --use_openmp --config Release --update --build --parallel --build_shared_lib  \
--cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) CMAKE_INSTALL_PREFIX=/workspace/libs/

# copy the c/c++ source code for internal interface headers
cp -rf onnxruntime  /workspace/libs/usr/local/source_code
mv /workspace/libs/usr/local  /workspace/onnxruntime_shared_lib

echo "Use CMake variable ONNXRUNTIME_ROOT_DIR to find onnxruntime library"





