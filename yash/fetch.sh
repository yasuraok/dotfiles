#!/bin/bash -ue

# fetch rclone config
rclone config show | sed -e /^token/d -e /^password/d > "$(dirname $0)/.rclone.conf"

# ...

git status
