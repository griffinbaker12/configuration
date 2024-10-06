alias py="python3"
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%b]'
setopt PROMPT_SUBST
PROMPT='%~ ${vcs_info_msg_0_}$ '
export CLICOLOR=1
export PS1=$'%n@%m:\e[0;36m%~\e[0m$ '
export EDITOR='vim'
bindkey -e
alias ggpush="git push"
alias venv='[ ! -d "venv" ] && py -m venv venv;source venv/bin/activate'
alias ods='vim ~/dotfiles'
