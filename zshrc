source "$(dirname $(dirname $(which brew)))/opt/zplug/init.zsh"

zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:0
zplug "zsh-users/zsh-history-substring-search", defer:1
zplug "zdharma/fast-syntax-highlighting", defer:1
zplug "b4b4r07/enhancd", use:init.sh

if ! zplug check; then
  zplug install
fi

zplug load

if [[ "$OSTYPE" == "darwin"* ]]; then
  if builtin command -v brew > /dev/null; then
    FPATH="/usr/local/share/zsh/site-functions:$FPATH"
  fi

  if builtin command -v starship > /dev/null; then
    eval "$(starship init zsh)"
  fi
elif  [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if builtin command -v brew > /dev/null; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi

  if builtin command -v starship > /dev/null; then
    eval $(/home/linuxbrew/.linuxbrew/bin/starship init zsh)
  fi
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

setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

unsetopt caseglob
unsetopt promptcr

function fzf-history() {
  BUFFER=$(history -n -r 1 | fzf +s +m --query="$LBUFFER" --prompt="history > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-history
bindkey '^r' fzf-history

function fzf-ghq() {
  local repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="repository > ")
  if [ -n "$repository" ]; then
    BUFFER="cd $(ghq root)/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-ghq
bindkey '^t' fzf-ghq


function fzf-git-switch() {
  local branch=$(git branch -a | tr -d " " | fzf +m --query="$LBUFFER" --prompt="switch > " --preview "git log --oneline --graph --decorate" | sed -e "s/^\*\s*//g" | sed -e "s/remotes\/origin\///g")
  if [ -n "$branch" ]; then
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-git-switch
bindkey '^y' fzf-git-switch

if builtin command -v exa > /dev/null; then
  alias l="exa -F"
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF"
  alias lla="exa -bhlHFa"
  alias llg="exa -bhlHFa --sort=type"
else
  alias l="ls -FG"
  alias ls="ls -FG"
  alias la="ls -A"
  alias ll="ls -l"
  alias lla="ls -AlF"
fi

if builtin command -v git > /dev/null; then
  alias gs="git status --short --branch"
  alias gl="git log -n 10 --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
  alias glg="git log --graph --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn%C(magenta)%d %C(reset)%s'"
  alias ga="git add"
  alias gc="git commit"
  alias gd="git diff"
  alias gp="git push"
  alias gf="git fetch"
  alias gb="git branch"
  alias gcm="git commit --message"
fi

if builtin command -v clip.exe > /dev/null; then
  alias pbcopy="clip.exe"
fi
