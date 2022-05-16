#!/bin/sh

# Configuration
SWIFT_ARCH="${SWIFT_ARCH:=armv7}"
SWIFT_BUILD_MODE="${SWIFT_BUILD_MODE:=release}"
SWIFT_PACKAGE_PATH="${SWIFT_PACKAGE_PATH:=../}"

echo "Building Swift for ${SWIFT_ARCH}"
echo "Swift Package ${SWIFT_PACKAGE_PATH} in ${SWIFT_BUILD_MODE} mode"

# exit for failures
set -e

# fetch buildroot
mkdir -p ./downloads
BUILDROOT_DOWNLOAD_FILE=./downloads/buildroot.zip
BUILDROOT_SRCDIR=./buildroot
BUILDROOT_SRCURL=https://github.com/MillerTechnologyPeru/buildroot/archive/refs/heads/feature/swift-wip.zip
if test -f "$BUILDROOT_DOWNLOAD_FILE"; then
    echo "$BUILDROOT_DOWNLOAD_FILE exists"
else
    echo "Download Buildroot"
    wget $BUILDROOT_SRCURL -O $BUILDROOT_DOWNLOAD_FILE

    echo "Extract Buildroot"
    cd ./downloads
    unzip ./buildroot.zip
    mv ./buildroot-feature-swift-wip ../buildroot
    cd ../
fi

# configure buildroot
cd $BUILDROOT_SRCDIR
if test -f ".config"; then
    echo "Buildroot already configured"
else
    echo "Configure Buildroot"
    SWIFT_DEFCONFIG="swift_${SWIFT_ARCH}_defconfig"
    make BR2_EXTERNAL=../ $SWIFT_DEFCONFIG
fi

# build buildroot
echo "Build Buildroot"
make
cd ../

# build swift package
echo "Build Swift Package"
HOST_SWIFT_SUPPORT_DIR="${BUILDROOT_SRCDIR}/output/host/usr/share/swift"
SWIFT_BIN="${HOST_SWIFT_SUPPORT_DIR}/bin/swift"
SWIFT_DESTINATION_FILE="${HOST_SWIFT_SUPPORT_DIR}/toolchain.json"

swift build --package-path ${SWIFT_PACKAGE_PATH} \
    --build-path ${SWIFT_PACKAGE_PATH}/.build \
    -c ${SWIFT_BUILD_MODE} \
    -Xswiftc -enable-testing \
    --destination ${SWIFT_DESTINATION_FILE} \
 #   --build-tests \

