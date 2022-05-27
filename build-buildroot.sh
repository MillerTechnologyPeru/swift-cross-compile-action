#!/bin/sh

# Configuration
SWIFT_ARCH="${SWIFT_ARCH:=armv7}"

echo "Building Swift for ${SWIFT_ARCH}"

# exit for failures
set -e

# fetch buildroot
mkdir -p ./downloads
BUILDROOT_DOWNLOAD_FILE=./downloads/buildroot.zip
BUILDROOT_SRCDIR=./buildroot-${SWIFT_ARCH}
BUILDROOT_SRCURL=https://github.com/MillerTechnologyPeru/buildroot/archive/refs/heads/2022.02-swift.zip
if test -f "$BUILDROOT_SRCDIR/.config"; then
    echo "$BUILDROOT_SRCDIR exists"
else
    echo "Download Buildroot"
    wget $BUILDROOT_SRCURL -O $BUILDROOT_DOWNLOAD_FILE

    echo "Extract Buildroot"
    cd ./downloads
    unzip ./buildroot.zip
    cd ../
    mv ./downloads/buildroot-2022.02-swift $BUILDROOT_SRCDIR
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
