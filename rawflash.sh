#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPTDIR/chip_nand_scripts_common"

require fel

INPUT_DIR="${1:-.}"

SPL="${SPL:-${INPUT_DIR}/sunxi-spl.bin}"
UBOOT="${UBOOT:-${INPUT_DIR}/flash-uboot.bin}"
FLASH_SPL="${FLASH_SPL:-${INPUT_DIR}/flash-spl.bin}"
FLASH_ENV="${FLASH_ENV:-${INPUT_DIR}/flash-uboot-env.bin}"
UBOOT_SCRIPT="${UBOOT_SCRIPT:-${SCRIPTDIR}/rawflash.scr.bin}"

file_exists_or_quit "${SPL}"
file_exists_or_quit "${UBOOT}"
file_exists_or_quit "${FLASH_SPL}"
file_exists_or_quit "${FLASH_ENV}"
file_exists_or_quit "${UBOOT_SCRIPT}"

wait_for_fel
 
echo == upload the SPL to SRAM and execute it ==
"${FEL}" spl "${SPL}"

sleep 1 # wait for DRAM initialization to complete

echo == upload the main u-boot binary to DRAM: $UBOOT ==
"${FEL}" -p write 0x4a000000 "${UBOOT}"

echo == upload the spl flash image to DRAM: $FLASH_SPL ==
"${FEL}" -p write 0x43000000 "${FLASH_SPL}"

echo == upload the uboot-env to DRAM: $FLASH_ENV  ==
"${FEL}" -p write 0x43400000 "${FLASH_ENV}"

echo == upload the boot.scr file ==
"${FEL}" write 0x43100000 "${UBOOT_SCRIPT}"

echo == execute the main u-boot binary ==
"${FEL}" exe   0x4a000000
