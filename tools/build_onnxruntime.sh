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
        python3-dev \
        doxygen

# clone the code and use product release version
git clone --single-branch --branch v1.4.0 --recursive https://github.com/Microsoft/onnxruntime onnxruntime
cd onnxruntime

/bin/sh ./build.sh --use_openmp --config Release --update --build --parallel --build_shared_lib  \
--cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) CMAKE_INSTALL_PREFIX=/workspace/libonnxruntime
cd build/Linux/Release/ 
make install
mkdir /workspace/libonnxruntime/lib64
cp *.a /workspace/libonnxruntime/lib64/
cp -rf onnx /workspace/libonnxruntime/lib64/
cp -rf external/protobuf/cmake/libprotobuf.a /workspace/libonnxruntime/lib64/
cd -

# copy the c/c++ source code for internal interface headers
cp -rf onnxruntime  /workspace/libonnxruntime/sourcecode
mkdir /workspace/libonnxruntime/third_party
cp -rf cmake/external/protobuf /workspace/libonnxruntime/third_party


# generate doxygen document
cat > doxygen.config <<EOF
DOXYFILE_ENCODING      = UTF-8
PROJECT_NAME           = "ONNXRUNTIME library"
BUILTIN_STL_SUPPORT    = YES

OUTPUT_DIRECTORY = ./doxygen_outputs
INPUT            =  ./onnxruntime ./docs ./build/Linux/Release/onnx cmake/external/onnx \

FILE_PATTERNS          = *.h *.hpp *.md *.cpp *.cc, *.in
RECURSIVE              = YES
GENERATE_TREEVIEW      = YES 

USE_MATHJAX            = YES 
GENERATE_LATEX         = NO 

BRIEF_MEMBER_DESC      = YES
REPEAT_BRIEF           = YES
FULL_PATH_NAMES        = YES
INHERIT_DOCS           = YES
MARKDOWN_SUPPORT       = YES
AUTOLINK_SUPPORT       = YES
SUBGROUPING            = YES
EXTRACT_ALL            = YES
SHOW_INCLUDE_FILES     = YES
SOURCE_BROWSER         = YES
INLINE_SOURCES         = YES
REFERENCED_BY_RELATION = YES
REFERENCES_RELATION    = YES
REFERENCES_LINK_SOURCE = YES
EOF

doxygen doxygen.config
rm doxygen.config
mkdir /workspace/libonnxruntime/docs
cp ./doxygen_outputs /workspace/libonnxruntime/docs




