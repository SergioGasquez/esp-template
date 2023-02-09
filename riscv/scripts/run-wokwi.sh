#!/usr/bin/env bash

set -e

BUILD_MODE=""
case "$1" in
"" | "release")
    bash scripts/build.sh
    BUILD_MODE="release"
    ;;
"debug")
    bash scripts/build.sh debug
    BUILD_MODE="debug"
    ;;
*)
    echo "Wrong argument. Only \"debug\"/\"release\" arguments are supported"
    exit 1
    ;;
esac

if [ "${USER}" == "gitpod" ]; then
    gp_url=$(gp url 9012)
    echo "gp_url=${gp_url}"
    export WOKWI_HOST=${gp_url:8}
elif [ "${CODESPACE_NAME}" != "" ]; then
    export WOKWI_HOST=${CODESPACE_NAME}-9012.githubpreview.dev
fi

# TODO: Update with your Wokwi Project
export WOKWI_PROJECT_ID=""
if [ "${WOKWI_PROJECT_ID}" == "" ]; then
    wokwi-server --chip {{ mcu }} target/riscv32imac-unknown-none-elf/${BUILD_MODE}/{{ crate_name }}
else
    wokwi-server --chip {{ mcu }} --id ${WOKWI_PROJECT_ID} target/riscv32imac-unknown-none-elf/${BUILD_MODE}/{{ crate_name }}
fi
