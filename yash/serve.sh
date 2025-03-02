#!/bin/bash -ue

DIR="$(cd "$(dirname "$0")" && pwd)"
source "${DIR}/.env"

CACHE_OPT=(--vfs-cache-mode full --vfs-cache-min-free-space 10G --vfs-cache-max-age 180d)
CMD1=(rclone mount --links "${CACHE_OPT[@]}" combine: R:)
CMD2=(rclone serve sftp --addr :14240 --user raoka --pass ${RAOKA_PASS} "${CACHE_OPT[@]}"    combine: -v)
CMD3=(rclone serve sftp --addr :24240 --user a4yg  --pass ${A4YG_PASS}  --vfs-cache-mode off pcloud_enc_private:)
CMD4=(powershell -ExecutionPolicy RemoteSigned -File "$(cygpath -w "$DIR" | sed 's/\\/\//g')/disable_restart.ps1")

wt new-tab "${CMD1[@]}" \; split-pane -H --size 0.75 "${CMD2[@]}" \; split-pane -H --size 0.66 "${CMD3[@]}" \; split-pane -H --size 0.5 "${CMD4[@]}"
