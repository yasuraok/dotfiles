#!/bin/bash -xe

# auto ssh-add
if ! grep -q "^# auto ssh-add$" ~/.bashrc; then
  {
    echo "";
    echo "# auto ssh-add";
    echo "source ~/dotfiles/auto-ssh-add.sh";
  } >> ~/.bashrc
fi

# setup devcontainer
if [ -n "$REMOTE_CONTAINERS" ]; then
  sudo apt update
  sudo apt install -y vim git bash-completion
  git config --global core.editor vim
  code --install-extension eamodio.gitlens
fi