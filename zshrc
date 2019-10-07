source "$ZPLUG_HOME/init.zsh"

zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:0
zplug "zsh-users/zsh-history-substring-search", defer:1
zplug "zdharma/fast-syntax-highlighting", defer:1

zplug "b4b4r07/enhancd", use:init.sh
zplug "mafredri/zsh-async", from:github

if ! zplug check; then
  zplug install
fi

zplug load

if builtin command -v brew > /dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

if builtin command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi

autoload -Uz compinit; compinit
autoload -Uz colors; colors

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt auto_menu
setopt list_packed
setopt list_types
setopt pushd_ignore_dups

setopt correct
setopt magic_equal_subst
setopt complete_aliases
setopt extended_glob
setopt nonomatch

setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

unsetopt caseglob
unsetopt promptcr

[ -s "$NVM_HOME/nvm.sh" ] && . "$NVM_HOME/nvm.sh"
[ -s "$NVM_HOME/etc/bash_completion" ] && . "$NVM_HOME/etc/bash_completion"

function history-fzf() {
  BUFFER=$(history -n -r 1 | fzf +s +m --query="$LBUFFER" --prompt="history > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

function ghq-fzf() {
  local selected=$(ghq list | fzf +m --query="$LBUFFER" --prompt="ghq > ")
  if [ -n "$selected" ]; then
    BUFFER="cd ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey '^t' ghq-fzf

if builtin command -v colordiff > /dev/null; then
  alias diff="colordiff"
fi

if builtin command -v nvim > /dev/null; then
  alias vi="nvim"
  alias vim="nvim"
fi

if builtin command -v exa > /dev/null; then
  alias l="exa -F"
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF"
  alias lla="exa -bhlHFa"
  alias llg="exa -bhlHFa --sort=type"
else
  alias l="ls -F --color=auto"
  alias ls="ls -F --color=auto"
  alias la="ls -A"
  alias ll="ls -l"
  alias lla="ls -AlF"
fi

alias g="git"
alias gs="git status --short --branch"
alias gl="git log --date=short --pretty=format:'%C(yellow)%h %Cgreen%cd %Cblue%cn %Creset%s'"
alias gc="git cz"
alias ga="git add"
alias gd="git diff"
alias gf="git fetch"
alias gb="git branch"
alias gco="git checkout"
alias gcm="git commit -m"
