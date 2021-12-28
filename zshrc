#!/usr/bin/env zsh

source $HOME/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

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

setopt share_history
setopt extended_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

unsetopt caseglob
unsetopt promptcr

typeset -U PATH

export LESS="-R"
export LANG="ja_JP.UTF-8"
export EDITOR="vim"
export FCEDIT="vim"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_OPTS="--height 40% --ansi --cycle --reverse --select-1 --exit-0 --bind=tab:down --bind=btab:up"

export XDG_CONFIG_HOME="$HOME/.config"

export PATH="$HOME/.fnm:$PATH"

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif  [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

if [[ -e "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if type fnm > /dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

if type starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

function fzf_history() {
  BUFFER=$(history -n -r 1 | fzf +s +m --query="$LBUFFER" --prompt="history > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf_history
bindkey '^r' fzf_history

function fzf_ghq() {
  local repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="ghq > ")
  if [[ -n "$repository" ]]; then
    BUFFER="cd $(ghq root)/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_ghq
bindkey '^t' fzf_ghq

function fzf_switch() {
  local branch=$(git branch -a --sort=-authordate | grep -v -e '->' -e '*' | sed 's/^[[:space:]]*//' | sed 's/remotes\/origin\///' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | awk '!a[$0]++' | fzf +m --query="$LBUFFER" --prompt="switch > ")
  if [[ -n "$branch" ]]; then
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_switch
bindkey '^y' fzf_switch

if type exa > /dev/null 2>&1; then
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF --sort=type --time-style=long-iso"
  alias lla="exa -bhlHFa --sort=type --time-style=long-iso"
else
  alias ls="ls -hFG"
  alias la="ls -hA"
  alias ll="ls -hl"
  alias lla="ls -hAlF"
fi

if type git > /dev/null 2>&1; then
  alias gs="git status --short --branch"
  alias gl="git log -n 10 --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
  alias ga="git add"
  alias gb="git branch"
  alias gd="git diff"
  alias gpl="git pull"
  alias gps="git push"
  alias gcm="git commit --message"
fi

if type clip.exe > /dev/null 2>&1; then
  alias pbcopy="clip.exe"
fi
