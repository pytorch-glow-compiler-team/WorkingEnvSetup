FROM ubuntu:18.04

ARG WORKDIR=/root/dev
ARG PYTHON_VERSION=3.7

# Create working folder
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

# Update and install tools
ARG ccache_deps="asciidoc docbook-xml docbook-xsl xsltproc"
ARG numpy_deps="gfortran"
RUN apt-get update && yes|apt-get upgrade && \
    apt-get install -y --no-install-recommends \
        clang clang-8 graphviz libpng-dev \
        libprotobuf-dev llvm-8 llvm-8-dev ninja-build protobuf-compiler wget \
        opencl-headers libgoogle-glog-dev libboost-all-dev \
        libdouble-conversion-dev libevent-dev libssl-dev libgflags-dev \
        libjemalloc-dev libpthread-stubs0-dev \
        # Additional dependencies
        git python-numpy \
        # pytorch need libraries
        build-essential curl ca-certificates libjpeg-dev libpng-dev \
        $ccache_deps \
        $numpy_deps \
        apt-transport-https \
        autoconf \
        automake \
        libatlas-base-dev \
        libc6-dbg \
        libiomp-dev \
        libyaml-dev \
        libz-dev \
        libjpeg-dev \
        libasound2-dev \
        libsndfile-dev \
        python-dev \
        python-setuptools \
        python-wheel \
        software-properties-common \
        sudo vim tmux bzip2 doxygen less && \
    # Delete outdated llvm to avoid conflicts
    apt-get autoremove -y llvm-6.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Valgrind separately since the apt-get version is too old.
ARG VALGRIND_VERSION=3.15.0
RUN mkdir valgrind_build && cd valgrind_build
#RUN wget http://valgrind.org/downloads/valgrind-${VALGRIND_VERSION}.tar.bz2
RUN wget https://sourceware.org/ftp/valgrind/valgrind-${VALGRIND_VERSION}.tar.bz2
RUN tar -xjf valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    cd valgrind-${VALGRIND_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j 4 && sudo make install && cd ../../ && \
    rm -rf valgrind_build && alias valgrind="/usr/local/bin/valgrind"
RUN cd ..

# Install latest cmake 
RUN apt remove -y --purge cmake
RUN mkdir cmake_build && cd cmake_build
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz && \
    tar -zxvf cmake-3.16.5.tar.gz && \
    cd cmake-3.16.5 && \
    ./bootstrap && \
    make && make install 



# Point clang to llvm-8 version
RUN update-alternatives --install /usr/bin/clang clang \
        /usr/lib/llvm-8/bin/clang 50 && \
    update-alternatives --install /usr/bin/clang++ clang++ \
        /usr/lib/llvm-8/bin/clang++ 50

# Point default C/C++ compiler to clang
RUN update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c++ /usr/bin/clang++

# Install fmt
RUN git clone https://github.com/fmtlib/fmt && \
    mkdir fmt/build && \
    cd fmt/build && \
    cmake .. && make && \
    make install

# Clean up
RUN rm -rf fmt


# Install conda
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda config --append channels conda-forge && \
     /opt/conda/bin/conda install -y ipython mkl mkl-include numpy pyyaml scipy ninja cython typing \
     pandas matplotlib  &&\
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH


WORKDIR /workspace
RUN chmod -R a+w .
