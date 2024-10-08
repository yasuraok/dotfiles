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
# -xオプションが付いていると表示が増えて鬱陶しいので、一時的にオフにする: https://www.robario.com/2016/04/20
# ssh-addは~/.ssh/以下の秘密鍵が無い場合に何も表示せずエラーになる。-eが付いているとssh到達前に終了してしまいデバッグがしづらくなるので、|| trueでエラーを無視する
ssh() {
  { local xtrace_=+x; test -o xtrace && xtrace_=-x; set +x; } 2>/dev/null
  (! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600) || true
  /usr/bin/ssh "$@"
  { local xtrace_r=$?; set $xtrace_; return $xtrace_r; } 2>/dev/null
}
export -f ssh

scp() {
  { local xtrace_=+x; test -o xtrace && xtrace_=-x; set +x; } 2>/dev/null
  (! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600) || true
  /usr/bin/scp "$@"
  { local xtrace_r=$?; set $xtrace_; return $xtrace_r; } 2>/dev/null
}
export -f scp

sftp() {
  { local xtrace_=+x; test -o xtrace && xtrace_=-x; set +x; } 2>/dev/null
  (! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600) || true
  /usr/bin/sftp "$@"
  { local xtrace_r=$?; set $xtrace_; return $xtrace_r; } 2>/dev/null
}
export -f sftp

rsync() {
  { local xtrace_=+x; test -o xtrace && xtrace_=-x; set +x; } 2>/dev/null
  for arg in "$@"
  do
    if [[ $arg =~ .+\:.+ ]]; then
      (! (ssh-add -l >/dev/null 2>&1) && ssh-add -t 3600) || true
    fi
  done
  /usr/bin/rsync "$@"
  { local xtrace_r=$?; set $xtrace_; return $xtrace_r; } 2>/dev/null
}
export -f rsync
