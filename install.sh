#!/bin/bash -xe

# auto ssh-add
if ! grep -q "^# auto ssh-add$" ~/.bashrc; then
  {
    echo "";
    echo "# auto ssh-add";
    echo "source ~/dotfiles/auto-ssh-add.sh";
  } >> ~/.bashrc
fi

# devcontainer固有の設定
if [ -n "$REMOTE_CONTAINERS" ]; then
  sudo apt update
  sudo apt install -y vim git bash-completion
  
  # dotfiles/install.shのタイミングでは早すぎて動かない処理をスクリプトに書き出す
  {
    echo "git config --global core.editor vim";
    echo "code --install-extension mhutchie.git-graph";
    echo "code --install-extension yzhang.markdown-all-in-one";
    echo "code --install-extension dzhavat.css-flexbox-cheatsheet";
    echo "code --install-extension genieai.chatgpt-vscode";
    echo "code --install-extension gitHub.copilot";
    echo "code --install-extension github.copilot-chat";
  } >> ~/dotfiles/devcontainer_init.sh
  
  # devcontainer起動後に一回だけ上記を実行するように.bashrcに仕込む
  {
    echo "";
    echo "# hook only once after devcontainer created";
    echo 'if [ -f "${HOME}/dotfiles/devcontainer_init.sh" ]; then'
    echo '  bash -xe ${HOME}/dotfiles/devcontainer_init.sh'
    echo '  rm ${HOME}/dotfiles/devcontainer_init.sh'
    echo 'fi'
  } >> ~/.bashrc
fi