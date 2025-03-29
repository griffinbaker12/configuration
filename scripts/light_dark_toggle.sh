#!/bin/bash

KITTY_ROOT="$HOME/dotfiles/kitty/kitty.conf"
NVIM_COLORS_ROOT="$HOME/dotfiles/nvim/lua/plugins/colorscheme.lua"
TMUX_ROOT="$HOME/dotfiles/.tmux.conf"

get_current_theme() {
    # Check kitty config to determine current theme
    light_match=$(grep 'include.*light-gruvbox' ${KITTY_ROOT})
    if [ -n "$light_match" ]; then
        echo "light" # If "light-gruvbox" is found, theme is currently light
    else
        echo "dark" # Otherwise, theme is dark
    fi
}

toggle_theme() {
    current_theme=$(get_current_theme)
    echo "Current theme is: $current_theme"
    
    if [ "$current_theme" = "light" ]; then
        # Switch to dark theme
        echo "Switching to dark theme..."
        
        # Update kitty config
        sed -i '' 's/light-gruvbox/dark-gruvbox/g' ${KITTY_ROOT}
        
        # Update neovim config
        sed -i '' 's/background = "light"/background = "dark"/g' ${NVIM_COLORS_ROOT}
        
        # Update tmux config - from light to dark
        sed -i '' 's/set -g status-style "fg=#7c6f64 bg=#f9f5d7"/set -g status-style "fg=#7C7D83 bg=#1d2021"/g' ${TMUX_ROOT}
        sed -i '' 's/set-option -g window-status-current-style "fg=#654735"/set-option -g window-status-current-style "fg=#dcc7a0"/g' ${TMUX_ROOT}
        sed -i '' 's/#\[fg=#654735\]/#\[fg=#dcc7a0\]/g' ${TMUX_ROOT}
    else
        # Switch to light theme
        echo "Switching to light theme..."
        
        # Update kitty config
        sed -i '' 's/dark-gruvbox/light-gruvbox/g' ${KITTY_ROOT}
        
        # Update neovim config
        sed -i '' 's/background = "dark"/background = "light"/g' ${NVIM_COLORS_ROOT}
        
        # Update tmux config - from dark to light
        sed -i '' 's/set -g status-style "fg=#7C7D83 bg=#1d2021"/set -g status-style "fg=#7c6f64 bg=#f9f5d7"/g' ${TMUX_ROOT}
        sed -i '' 's/set-option -g window-status-current-style "fg=#dcc7a0"/set-option -g window-status-current-style "fg=#654735"/g' ${TMUX_ROOT}
        sed -i '' 's/#\[fg=#dcc7a0\]/#\[fg=#654735\]/g' ${TMUX_ROOT}
    fi
    
    # Reload tmux config
    tmux source-file "$TMUX_ROOT"
    
    echo "Theme toggle complete!"
}

toggle_theme
