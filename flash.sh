#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPTDIR/chip_nand_scripts_common"

IMAGE_DIR="${1:-.}"

SPL_IMAGE=flash-spl.bin
UBOOT_IMAGE=flash-uboot.bin
UBOOT_ENV_IMAGE=flash-uboot-env.bin
UBI_IMAGE=flash-rootfs.bin
VID="-i 0x1f3a"

require fastboot

#UBOOT_SCRIPT="${SCRIPTDIR}/erasenand.scr.bin" "${SCRIPTDIR}/gotofastboot.sh" "${IMAGE_DIR}" || exit 1
#UBOOT_SCRIPT="${SCRIPTDIR}/gotofastboot.scr.bin" "${SCRIPTDIR}/gotofastboot.sh" "${IMAGE_DIR}" || exit 1
UBOOT_SCRIPT="${SCRIPTDIR}/rawflash.scr.bin" "${SCRIPTDIR}/rawflash.sh" "${IMAGE_DIR}" || exit 1

TIMEOUT=30
wait_for_fastboot

#fastboot ${VID} erase spl-backup
#fastboot ${VID} erase uboot
#fastboot ${VID} erase env
#fastboot ${VID} erase UBI

#fastboot ${VID} flash spl        "${IMAGE_DIR}/${SPL_IMAGE}"
#fastboot ${VID} flash spl-backup "${IMAGE_DIR}/${SPL_IMAGE}"
#fastboot ${VID} flash uboot      "${IMAGE_DIR}/${UBOOT_IMAGE}"
#fastboot ${VID} flash env        "${IMAGE_DIR}/${UBOOT_ENV_IMAGE}"
fastboot ${VID} flash UBI        "${IMAGE_DIR}/${UBI_IMAGE}"
