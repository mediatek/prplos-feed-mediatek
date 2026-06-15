#!/bin/bash

# Copyright (C) 2024 MediaTek Inc. All rights reserved.
# Author: Evelyn Tsai <evelyn.tsai@mediatek.com>

# Function to apply patches
mtk_prplos_patch() {
    echo -e "\033[1;32m === Applying patches... ===\033[0m"

    # Set the patches directory
    patches_dir="${prplos_root}/autobuild/prplos/patches"

    # Apply each .patch file in the patches directory
    for patch in "${patches_dir}"/*.patch; do
        if [ -f "$patch" ]; then
            echo -e "\033[1;34m Applying patch: ${patch}... \033[0m"
            # Apply the patch
            patch -p1 < "$patch"
            if [ $? -ne 0 ]; then
                echo -e "\033[1;31m Failed to apply patch: ${patch} \033[0m"
                exit 1
            fi
        else
            echo -e "\033[1;33m No patches found in ${patches_dir} \033[0m"
        fi
    done
}

mtk_secure_sdk_patch() {
    echo -e "\033[1;32m === Applying secure sdk patches... ===\033[0m"

    # Set the patches directory
    patches_dir="${prplos_root}/autobuild/prplos/secure/patches-base"

    # Apply each .patch file in the patches directory
    for patch in "${patches_dir}"/*.patch; do
        if [ -f "$patch" ]; then
            echo -e "\033[1;34m Applying patch: ${patch}... \033[0m"
            # Apply the patch
            patch -p1 < "$patch"
            if [ $? -ne 0 ]; then
                echo -e "\033[1;31m Failed to apply patch: ${patch} \033[0m"
                exit 1
            fi
        else
            echo -e "\033[1;33m No patches found in ${patches_dir} \033[0m"
        fi
    done
}

mtk_secure_feed_patch() {
    echo -e "\033[1;32m === Applying secure feed patches... ===\033[0m"

    # Set the patches directory
    patches_dir="${prplos_root}/autobuild/prplos/secure/patches-feeds"

    # Apply each .patch file in the patches directory
    for patch in "${patches_dir}"/*.patch; do
        if [ -f "$patch" ]; then
            echo -e "\033[1;34m Applying patch: ${patch}... \033[0m"
            # Apply the patch
            patch -p1 < "$patch"
            if [ $? -ne 0 ]; then
                echo -e "\033[1;31m Failed to apply patch: ${patch} \033[0m"
                exit 1
            fi
        else
            echo -e "\033[1;33m No patches found in ${patches_dir} \033[0m"
        fi
    done
}

mtk_secure_prepare() {
    echo -e "\033[1;32m === add scripts and mkimage for secure boot... ===\033[0m"

    # Set secure_tool_root variable
    secure_tool_root=${prplos_root}/autobuild/prplos/secure/tools

    # Copy all files from secure_tool_root to the target directory
    cp -r ${secure_tool_root}/* ${prplos_root}/tools

    # Set secure_script_root variable
    secure_script_root=${prplos_root}/autobuild/prplos/secure/scripts

    # Copy all files from secure_script_root to the target directory
    cp -r ${secure_script_root}/* ${prplos_root}/scripts
}

change_feed_mtk_revision() {
    echo -e "\033[1;32m === Hack feed_mtk to latest revision... ===\033[0m"
    REPO_URL="https://github.com/mediatek/prplos-feed-mediatek"
    BRANCH="main"
    YAML_FILE="profiles/mtk_filogic.yml"

    # Get the latest commit hash from the specified branch
    LATEST_COMMIT=$(git ls-remote $REPO_URL refs/heads/$BRANCH | awk '{print $1}')

    # Check if the commit hash was successfully retrieved
    if [ -z "$LATEST_COMMIT" ]; then
        echo -e "\033[1;31m Failed to get the latest commit for branch $BRANCH \033[0m"
        exit 1
    fi

    # Update the YAML file with the new revision
    sed -i "s/revision: .*/revision: $LATEST_COMMIT/" ${prplos_root}/$YAML_FILE

    echo "Updated $YAML_FILE with latest commit: $LATEST_COMMIT"
}

# Set prplos_root variable to the current directory
prplos_root="$(pwd)"
echo -e "\033[1;32m === Setting prplos_root to the current directory: ${prplos_root} === \033[0m"
mtk_prplos_patch

change_feed_mtk_revision

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

mtk_secure_prepare
mtk_secure_sdk_patch
mtk_secure_feed_patch

# Create symbolic link
if test -d "${prplos_root}/../dl"; then
	if ! test -d "${prplos_root}/dl" -o -L "${prplos_root}/dl"; then
		 echo -e "\033[1;32m === Executing symbolic link command... ===\033[0m"
		 ln -sf ../dl ${prplos_root}/dl
	fi
fi


# Execute the make command using 32 threads
echo -e "\033[1;32m === Executing make command... ===\033[0m"
make -j32 V=s
