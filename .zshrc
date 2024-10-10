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
alias ods='vim ~/dotfiles'
bindkey "^D" delete-char-or-list

alias c="clear"
alias sz="source ~/.zshrc"
alias st="tmux source-file ~/.tmux.conf"

alias vim="nvim"

# Function to create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}
