#!/bin/sh

# Configuration
SWIFT_ARCH="${SWIFT_ARCH:=armv7}"
SWIFT_BUILD_MODE="${SWIFT_BUILD_MODE:=release}"
SWIFT_PACKAGE_PATH="${SWIFT_PACKAGE_PATH:=../}"

# exit for failures
set -e

# build swift package
echo "Build Swift Package"
BUILDROOT_SRCDIR=./buildroot-${SWIFT_ARCH}
HOST_SWIFT_SUPPORT_DIR="${BUILDROOT_SRCDIR}/output/host/usr/share/swift"
SWIFT_BIN="${HOST_SWIFT_SUPPORT_DIR}/bin/swift"
SWIFT_DESTINATION_FILE="${HOST_SWIFT_SUPPORT_DIR}/toolchain.json"

swift build --package-path ${SWIFT_PACKAGE_PATH} \
    --build-path ${SWIFT_PACKAGE_PATH}/.build \
    -c ${SWIFT_BUILD_MODE} \
    -Xswiftc -enable-testing \
    --destination ${SWIFT_DESTINATION_FILE} \
    --build-tests \
    -Xswiftc -enable-testing \

# Copy unit tests
cp ${SWIFT_PACKAGE_PATH}/.build/${SWIFT_BUILD_MODE}/*.xctest ${BUILDROOT_SRCDIR}/output/target/usr/bin/

# Copy QEMU
cp -rf /usr/bin/qemu-arm-static ${BUILDROOT_SRCDIR}/output/target/usr/bin/
