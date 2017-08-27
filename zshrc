source $HOME/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug "b4b4r07/zsh-gomi"
zplug "rupa/z", use:z.sh
zplug "mafredri/zsh-async", from:github
zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
# zplug "pecigonzalo/pure-spaceship-zsh-theme", use:pure.zsh, from:github, as:theme

zplug "modules/archive", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/git", from:prezto
zplug "modules/history", from:prezto
zplug "modules/node", from:prezto
zplug "modules/prompt", from:prezto
zplug "modules/python", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/utility", from:prezto

zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:module:prompt' theme 'sorin'
zstyle ':prezto:module:node:info:version' format 'version:%v'

if ! zplug check; then
  zplug install
fi

zplug load


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


autoload -U compinit; compinit
autoload -U colors; colors

bindkey -e

setopt auto_menu
setopt complete_aliases
setopt correct
setopt hist_reduce_blanks
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt no_beep
setopt nonomatch

unsetopt caseglob
unsetopt promptcr


export LESS="-R"


case ${OSTYPE} in
  linux*)
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    ;;
esac

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

alias rm="gomi"
alias rd="gomi"

alias diff="colordiff -u"
alias grep="grep --color"

alias vi="nvim"
alias vim="nvim"

alias g="git"
alias gs="git status ."
alias gl="git log --oneline --graph --no-merges -7 --pretty=format:'%C(yellow)%h%Creset %C(Blue)%<(8)%ar%Creset %s' | cat"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gd="git diff"
alias gld="git branch -d $(git branch --merged | grep -v master | grep -v '*')"

alias mp3="youtube-dl -x --audio-format mp3 -o ~/Music/%(title)s.%(ext)s"
alias mp4="youtube-dl --format 'best[ext=mp4]' -o ~/Videos/%(title)s.%(ext)s"

function flv2mp4() {
  ffmpeg -i $1 -codec copy ${1%.flv}.mp4
}

function mp42mp3() {
  ffmpeg -i $1 -ab 256k ${1%.mp4}.mp3
}
