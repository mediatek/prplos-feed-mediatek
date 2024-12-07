#!/bin/bash

# Copyright (C) 2024 MediaTek Inc. All rights reserved.
# Author: Evelyn Tsai <evelyn.tsai@mediatek.com>

# Function to handle pwhm patches
mtk_pwhm_patches() {
    echo -e "\033[1;32m === Handling pwhm patches... ===\033[0m"

    # Set pwhm_patch_root variable
    pwhm_patch_root=${prplos_root}/feeds/feed_mediatek/pwhm/patches

    # Copy all files from pwhm_patch_root to the target directory
    cp -r ${pwhm_patch_root}/* ${prplos_root}/feeds/feed_wifi_core/plugins/pwhm
}

# Set prplos_root variable to the current directory
prplos_root="$(pwd)"
echo -e "\033[1;32m === Setting prplos_root to the current directory: ${prplos_root} === \033[0m"

# Construct the prplos_cmd command
prplos_cmd="${prplos_root}/scripts/gen_config.py"

# Add up to four parameters to the prplos_cmd command
for param in "$@"; do
    prplos_cmd+=" $param"
done
echo -e "\033[1;32m === prplos_cmd command: ${prplos_cmd} === \033[0m"

# Execute the prplos_cmd command
echo -e "\033[1;32m === Executing prplos_cmd command...=== \033[0m"
$prplos_cmd

# Call the function to handle pwhm patches
mtk_pwhm_patches

# Execute the make command using 32 threads
echo -e "\033[1;32m === Executing make command... ===\033[0m"
make -j32
