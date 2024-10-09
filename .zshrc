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
alias ggpush="git push"
alias venv='[ ! -d "venv" ] && py -m venv venv;source venv/bin/activate'
alias ods='vim ~/dotfiles'

bindkey '^D' kill-word
