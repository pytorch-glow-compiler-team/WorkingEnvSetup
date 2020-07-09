set -e

## step 1: build
mkdir -p build
cd build
cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DPYTHON3_EXECUTABLE=/opt/conda/bin/python3 \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ../
ninja all -j6
make install
