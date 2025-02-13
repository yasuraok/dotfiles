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
  git config --global core.editor vim
  git config --global rebase.autosquash true

  # 以前はここにcode --install-extensionを入れていたが、VSCodeのsettingのdev.containers.defaultExtensionsを使えばよかったので削除
fi
