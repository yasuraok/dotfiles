#!/bin/bash -ue

DIR="$(cd "$(dirname "$0")" && pwd)"
source "${DIR}/.env"

CACHE_OPT=(--vfs-cache-mode full --vfs-cache-min-free-space 10G --vfs-cache-max-age 180d)

if [ "${1:-}" = "--verbose" ]; then
  V_OPT=-vvv
  echo "Verbose mode"
else
  V_OPT=-v
fi

CMD1=(rclone mount --links "${CACHE_OPT[@]}" combine: R: --network-mode ${V_OPT})
CMD2=(rclone serve sftp --addr :${SFTP1_PORT} --user ${SFTP1_USER} --pass ${SFTP1_PASS} --vfs-cache-mode off ${SFTP1_SOURCE} ${V_OPT})
CMD3=(rclone serve sftp --addr :${SFTP2_PORT} --user ${SFTP2_USER} --pass ${SFTP2_PASS} --vfs-cache-mode off ${SFTP2_SOURCE})
CMD4=(powershell -ExecutionPolicy RemoteSigned -File "$(cygpath -w "$DIR" | sed 's/\\/\//g')/disable_restart.ps1")

wt new-tab "${CMD1[@]}" \; \
  split-pane -H --size 0.75 "${CMD2[@]}" \; \
  split-pane -H --size 0.66 "${CMD3[@]}" \; \
  split-pane -H --size 0.50 "${CMD4[@]}"
