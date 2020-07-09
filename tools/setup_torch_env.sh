ln -s /usr/local/bin/cmake /usr/bin/cmake
cd /tmp
wget https://download.pytorch.org/libtorch/nightly/cpu/libtorch-cxx11-abi-shared-with-deps-latest.zip
unzip libtorch-cxx11-abi-shared-with-deps-latest.zip
rm -rf libtorch-cxx11-abi-shared-with-deps-latest.zip
echo "finish downloading libtorch and extraction\n"
echo "please set Torch_DIR=/tmp/libtorch/share/cmake/Torch/"