#!/bin/bash

PREFIX=$PWD/tools
mkdir -p $PREFIX/bin

SUNXI_TOOLS_REPO=https://github.com/linux-sunxi/sunxi-tools
SUNXI_TOOLS_BUILD_DIR=sunxi-tools

git clone $SUNXI_TOOLS_REPO $SUNXI_TOOLS_BUILD_DIR
pushd $SUNXI_TOOLS_BUILD_DIR
make sunxi-nand-image-builder
cp sunxi-nand-image-builder $PREFIX/bin/
popd


MTD_UTILS_REPO=http://github.com/nextthingco/chip-mtd-utils
MTD_UTILS_BUILD_DIR=chip-mtd-utils
MTD_UTILS_BRANCH=by/1.5.2/next-mlc-debian

git clone --depth 1 -b $MTD_UTILS_BRANCH $MTD_UTILS_REPO $MTD_UTILS_BUILD_DIR
pushd $MTD_UTILS_BUILD_DIR
make PREFIX=$PREFIX install
popd


UBOOT_REPO=http://github.com/nextthingco/CHIP-u-boot
UBOOT_BUILD_DIR=CHIP-u-boot
UBOOT_BRANCH=production-mlc

git clone --depth 1 -b $UBOOT_BRANCH $UBOOT_REPO $UBOOT_BUILD_DIR
pushd $UBOOT_BUILD_DIR
make CHIP_defconfig
make tools
cp tools/mkimage $PREFIX/bin/
cp tools/mkenvimage $PREFIX/bin/
cp tools/dumpimage $PREFIX/bin/
popd
