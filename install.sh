#!/bin/bash -xe

if ! grep -q "^# auto ssh-add$" ~/.bashrc; then
  {
    echo "";
    echo "# auto ssh-add";
    echo "source ~/dotfiles/auto-ssh-add.sh";
  } >> ~/.bashrc
fi

sudo apt update
sudo apt install -y vim git bash-completion
git config --global core.editor vim