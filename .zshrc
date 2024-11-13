# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Use 'py' as an alias for the pyenv-managed Python
alias py="python"

PROMPT='%F{cyan}%~%f${vcs_info_msg_0_} '
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{green}[%b]%f'
setopt PROMPT_SUBST
setopt autocd
export CLICOLOR=1
export EDITOR='vim'
bindkey -e
alias ggp="git push"
alias venv='[ ! -d "venv" ] && py -m venv venv;source venv/bin/activate'
alias ods='v ~/dotfiles'
bindkey "^D" delete-char-or-list

alias c="clear"
alias sz="source ~/.zshrc"
alias st="tmux source-file ~/.tmux.conf"

alias v="nvim"

# Function to create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

setopt extended_glob

alias set_upstream="git push --set-upstream origin main"

add_origin_remote () {
    git remote add origin "$1"
}

watch() {
    if [ $# -eq 0 ]; then
        echo "Usage: watch <file> [command]"
        return 1
    fi
    local delimiter="$(printf '=%.0s' {1..50})"
    file="$1"
    
    if [ $# -eq 1 ]; then
        # Default to python3 if no command specified
        ls "$file" | entr sh -c 'echo "'"$delimiter"'"; echo "Reloaded at: $(date "+%B %d, %Y at %I:%M %p")"; echo "'"$delimiter"'"; python3 "'"$file"'"'
    else
        # Use the rest of arguments as the command
        shift
        ls "$file" | entr sh -c 'echo "'"$delimiter"'"; echo "Reloaded at: $(date "+%B %d, %Y at %I:%M %p")"; echo "'"$delimiter"'"; '"$*"
    fi
}
