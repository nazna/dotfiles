source $HOME/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "b4b4r07/zsh-gomi", as:command, use:bin/gomi, on:junegunn/fzf-bin
zplug "b4b4r07/enhancd", use:init.sh, on:junegunn/fzf-bin
zplug "momo-lab/zsh-replace-multiple-dots"
zplug "simonwhitaker/gibo", use:gibo, as:command

zplug "geometry-zsh/geometry", as:theme

zplug "modules/archive", from:prezto
zplug "modules/history", from:prezto

zplug "zplug/zplug", hook-build: "zplug --self-manage"

if ! zplug check; then
  zplug install
fi

zplug load

autoload -U compinit; compinit
autoload -U colors; colors

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVESIZE=100000

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

export LESS="-R"

# pbcopy, pbpaste
case ${OSTYPE} in
  linux*)
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    ;;
esac

# ls
if [[ -x `which exa` ]]; then
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF"
  alias lla="exa -bhlHFa"
else
  case ${OSTYPE} in
    darwin*)
      alias ls="ls -GF"
      ;;
    linux*)
      alias ls="ls -F --color=auto"
      ;;
  esac

  alias la="ls -A"
  alias ll="ls -l"
  alias lla="ls -lA"
fi

# colordiff
if [[ -x `which colordiff` ]]; then
  alias diff="colordiff"
fi

# gomi
if [[ -x `which gomi` ]]; then
  alias rm="gomi"
fi

# grep
alias grep="grep --color=always"

# git
alias g="git"
alias gs="git status ."
alias gl="git log --oneline --graph --no-merges -7 --pretty=format:'%C(yellow)%h%Creset %C(Blue)%<(8)%ar%Creset %s' | cat"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gd="git diff"
alias gclean="git branch -d $(git branch --merged | grep -v master | grep -v '*')"

# youtube-dl
alias mp3="youtube-dl -x --audio-format mp3 -o $HOME/Music/%(title)s.%(ext)s"
alias mp4="youtube-dl --format 'best[ext=mp4]' -o $HOME/Movies/%(title)s.%(ext)s"

function flv2mp4() {
  ffmpeg -i $1 -codec copy ${1%.flv}.mp4
}

function mp42mp3() {
  ffmpeg -i $1 -ab 256k ${1%.mp4}.mp3
}
