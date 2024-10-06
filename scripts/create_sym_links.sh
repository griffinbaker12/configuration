#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_BACKUP_DIR="$HOME/dotfile_backups"

# Function to create symlink
create_symlink() {
    local src="$1"
    local dest="$2"
    if [ -e "$dest" ]; then
        if [ ! -L "$dest" ]; then
            mv "$dest" "${dest}.backup"
            echo "Backed up existing $dest to ${dest}.backup"
        fi
    fi
    ln -sf "$src" "$dest"
    echo "Created symlink: $dest -> $src"
}

# Create symlinks
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

echo "Dotfiles setup complete!"
