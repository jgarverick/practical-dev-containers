#!/bin/bash

echo '[INFO] Setting up zsh as default shell...'
echo 'export SHELL=`which zsh`' >> ~/.bashrc
echo '[ -z "$ZSH_VERSION" ] && exec "$SHELL" -l' >> ~/.bashrc

echo '[INFO] Setting up Powerlevel10k...'
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

echo '[INFO] Setting up pre-commit...'
pre-commit install && pre-commit install-hooks

echo '[INFO] Copying p10k.zsh...'
cp ./.devcontainer/p10k.zsh ~/.p10k.zsh

echo '[INFO] Setting up oh-my-zsh...'
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

echo '[INFO] Setting aliases...'
source ./.devcontainer/aliases.sh

echo '[INFO] postCreateCommand.sh finished!'
