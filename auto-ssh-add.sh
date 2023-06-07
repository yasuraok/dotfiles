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
if [[ -z "${SSH_AGENT_PID}" ]]; then
  eval "$(ssh-agent -s)"
  trap 'kill $SSH_AGENT_PID' EXIT HUP INT TERM
fi

# 初回のssh接続時、ssh-addを実行してパスフレーズを要求するラップ関数
ssh() {
  if ! (ssh-add -l >/dev/null 2>&1) ; then
    ssh-add -t 300
  fi
  /usr/bin/ssh "$@"
}