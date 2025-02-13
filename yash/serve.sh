#!/bin/bash -ue

source "$(dirname $0)/.env"

CMD1="rclone mount --links --vfs-cache-mode full --vfs-cache-min-free-space 10G combine: R:"
CMD2="rclone serve sftp --addr :14240 --user raoka --pass ${RAOKA_PASS} --vfs-cache-mode off R: -v"
CMD3="rclone serve sftp --addr :24240 --user a4yg  --pass ${A4YG_PASS}  --vfs-cache-mode off pcloud_enc_private:"

wt new-tab ${CMD1} \; split-pane -H --size 0.66 ${CMD2} \; split-pane -H --size 0.50 ${CMD3}
