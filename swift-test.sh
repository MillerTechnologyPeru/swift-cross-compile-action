#!/bin/sh

# Configuration
SWIFT_ARCH="${SWIFT_ARCH:=armv7}"

# exit for failures
set -e

# build swift package
echo "Test Swift package"
BUILDROOT_SRCDIR=./buildroot-${SWIFT_ARCH}
chroot ${BUILDROOT_SRCDIR}/output/target /usr/bin/qemu-arm-static /usr/bin/*.xctest
