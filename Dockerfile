FROM swift:5.6.1-focal

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    llvm-12-dev \
    wget \
    build-essential \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    g++ \
    gcc \
    git \
    gzip \
    libncurses5-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python \
    rsync \
    sed \
    tar \
    unzip \
    && rm -r /var/lib/apt/lists/*

WORKDIR /usr/src/buildroot-external

# Install latest Cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4-linux-x86_64.tar.gz && \
    tar -xf cmake-3.22.4-linux-x86_64.tar.gz && \
    rm -rf cmake-3.22.4-linux-x86_64.tar.gz && \
    rm -rf cmake-3.22.4-linux-x86_64/man && \
    cp -rf cmake-3.22.4-linux-x86_64/* /usr/local/ && \
    rm -rf cmake-3.22.4-linux-x86_64

# Modify LLVM headers
RUN cp /usr/lib/llvm-12/include/llvm/Config/llvm-config.h /usr/lib/llvm-12/include/llvm/Config/config.h

# Build Buildroot and Swift package


COPY . .
