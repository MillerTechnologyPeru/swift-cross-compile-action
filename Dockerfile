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
RUN set -e; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX='-x86_64'; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    wget "https://github.com/Kitware/CMake/releases/download/v3.22.4/cmake-3.22.4-linux$OS_ARCH_SUFFIX.tar.gz"; \
    tar -xf "cmake-3.22.4-linux$OS_ARCH_SUFFIX.tar.gz"; \
    rm -rf "cmake-3.22.4-linux$OS_ARCH_SUFFIX.tar.gz"; \
    rm -rf "cmake-3.22.4-linux$OS_ARCH_SUFFIX/man"; \
    cp -rf "cmake-3.22.4-linux$OS_ARCH_SUFFIX/*" /usr/local/; \
    rm -rf "cmake-3.22.4-linux$OS_ARCH_SUFFIX"; \

# Modify LLVM headers
RUN cp /usr/lib/llvm-12/include/llvm/Config/llvm-config.h /usr/lib/llvm-12/include/llvm/Config/config.h

# Build Buildroot and Swift package

COPY . .
