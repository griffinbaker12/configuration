#!/bin/bash

create_symlink() {
    if [ -L "$2" ]; then
        echo "Symlink already exists for $2, skipping..."
    elif [ -e "$2" ]; then
        echo "File already exists at $2 (not a symlink), skipping..."
    else
        ln -s "$1" "$2"
        echo "Created symlink: $2 -> $1"
    fi
}

create_symlink ~/dotfiles/.vimrc ~/.vimrc
create_symlink ~/dotfiles/.zshrc ~/.zshrc
create_symlink ~/dotfiles/.tmux.conf ~/.tmux.conf
create_symlink ~/dotfiles/nvim ~/.config/nvim
create_symlink ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
create_symlink ~/dotfiles/kitty/current-theme.conf ~/.config/kitty/current-theme.conf
