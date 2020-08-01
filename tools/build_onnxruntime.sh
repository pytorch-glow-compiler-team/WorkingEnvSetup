#!/usr/bin/env bash
# paramters for cmake command
BUILD_TYPE=Debug
BRANCH=v1.4.0
[[ -z "$1" ]] || BUILD_TYPE = "$1"
[[ -z "$2" ]] || BRANCH = "$2"

# install common dep. see this link: https://github.com/microsoft/onnxruntime/blob/master/dockerfiles/scripts/install_common_deps.sh
apt-get update && apt-get install -y --no-install-recommends \
        wget \
        zip \
        ca-certificates \
        build-essential \
        curl \
        libcurl4-openssl-dev \
        libssl-dev \
        python3-dev python3-pip \
        doxygen


pip3 install --upgrade pip
pip3 install numpy onnx onnxruntime ipython setuptools
# clone the code and use product release version
cd /workspace
git clone --single-branch --branch ${BRANCH} --recursive https://github.com/Microsoft/onnxruntime onnxruntime
cd onnxruntime

/bin/sh ./build.sh --use_openmp --config ${BUILD_TYPE} --update --build --parallel --build_shared_lib  \
--cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) CMAKE_INSTALL_PREFIX=/workspace/libonnxruntime
cd build/Linux/${BUILD_TYPE}/ 
make install
mkdir /workspace/libonnxruntime/lib64
cp *.a /workspace/libonnxruntime/lib64/
cp -rf onnx /workspace/libonnxruntime/lib64/
cp -rf external/protobuf/cmake/libprotobuf.a /workspace/libonnxruntime/lib64/
cp -rf external/re2/libre2.a /workspace/libonnxruntime/lib64/
cp -rf external/nsync/libnsync_cpp.a /workspace/libonnxruntime/lib64/
cp -rf external/protobuf/cmake/libprotobufd.a  /workspace/libonnxruntime/lib64/libprotobuf.a
cp onnxruntime_config.h /workspace/libonnxruntime/include/onnxruntime
cd -

# copy the c/c++ source code for internal interface headers
cp -rf onnxruntime  /workspace/libonnxruntime/sourcecode
cp -rf include /workspace/libonnxruntime
mkdir /workspace/libonnxruntime/third_party
cp -rf cmake/external/protobuf /workspace/libonnxruntime/third_party
cp -rf cmake/external/nsync /workspace/libonnxruntime/third_party
cp -rf cmake/external/SafeInt /workspace/libonnxruntime/third_party
cp -rf cmake/external/onnx /workspace/libonnxruntime/third_party
cp -rf cmake/external/eigen /workspace/libonnxruntime/third_party
echo "Default onnx namespace is ONNX_NAMESPACE::, suggest do global replace to onnx::\n"
echo "For example: ONNX_NAMESPACE:: -> onnx::, namespace ONNX_NAMESPACE -> namespace onnx\n"
find /workspace/libonnxruntime -type f \( -name \*.cc -o -name \*.h -o -name \*.cpp \) -exec sed -i 's/ONNX_NAMESPACE::/onnx::/g' {} \;
find /workspace/libonnxruntime -type f \( -name \*.cc -o -name \*.h -o -name \*.cpp \) -exec sed -i 's/namespace ONNX_NAMESPACE/namespace onnx/g' {} \;

# generate doxygen document
echo "step: generate the doxygen document on ./doxygen_outputs"
cat > doxygen.config <<EOF
DOXYFILE_ENCODING      = UTF-8
PROJECT_NAME           = "ONNXRUNTIME library"
BUILTIN_STL_SUPPORT    = YES

OUTPUT_DIRECTORY = ./doxygen_outputs
INPUT            =  /workspace/libonnxruntime/sourcecode  \
                    /workspace/libonnxruntime/third_party \
                    /workspace/libonnxruntime/include \
                    /workspace/libonnxruntime/lib64/onnx \
                    /workspace/onnxruntime/docs

FILE_PATTERNS          = *.h *.hpp *.md *.cpp *.cc, *.in, *.c
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
SHOW_FILES             = YES

QUIET                  = YES
SEPARATE_MEMBER_PAGES  = YES
BUILTIN_STL_SUPPORT    = YES
EXTRACT_PRIVATE        = YES
EXTRACT_STATIC         = YES
EOF

doxygen doxygen.config
rm doxygen.config
mkdir /workspace/libonnxruntime/docs
cp ./doxygen_outputs /workspace/libonnxruntime/docs


echo "step: provide the cmake config template how to ONNXRuntime library: \n"
