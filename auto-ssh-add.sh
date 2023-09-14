#!/bin/bash -e

# 共用のssh-agentを使いまわす場合はこちら
# # ssh-agentが起動していなければ起動する
# if ! pgrep -u "$(id -u)" ssh-agent > /dev/null; then
#   eval "$(ssh-agent -s)"
#   echo "${SSH_AGENT_PID}" > ~/.ssh/agent_pid
# else
#   export SSH_AGENT_PID=$(cat ~/.ssh/agent_pid)
#   export SSH_AUTH_SOCK=$(find /tmp/ssh-*/agent.*)
# fi

# 端末ごとに個別にssh-agentを立ち上げ、端末ごとにパスフレーズ記憶を独立に持つ
if [[ -z "${SSH_AGENT_PID}" ]] || ! kill -0 "${SSH_AGENT_PID}" 2>/dev/null; then
  eval "$(ssh-agent -s)"
  trap 'kill $SSH_AGENT_PID' EXIT
fi

# 初回のssh接続時、ssh-addを実行してパスフレーズを要求するラップ関数
ssh() {
  ! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600
  /usr/bin/ssh "$@"
}
export -f ssh

scp() {
  ! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600
  /usr/bin/scp "$@"
}
export -f scp

rsync() {
  for arg in "$@"
  do
    if [[ $arg =~ .+\:.+ ]]; then
      ! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600
    fi
  done
  /usr/bin/rsync "$@"
}
export -f rsync