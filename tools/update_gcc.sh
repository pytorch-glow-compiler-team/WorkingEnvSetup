apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt update
apt install g++-7 -y
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60                          --slave /usr/bin/g++ g++ /usr/bin/g++-7
