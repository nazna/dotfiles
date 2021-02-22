source "$HOME/.zinit/bin/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-history-substring-search"
zinit light "zdharma/fast-syntax-highlighting"
zinit light "b4b4r07/enhancd"

if [[ "$OSTYPE" == "darwin"* ]]; then
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

if [ -e "$HOME/.cargo" ]; then
  source "$HOME/.cargo/env"
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

export LESS="-R"
export LANG="ja_JP.UTF-8"
export EDITOR="vim"
export FCEDIT="vim"

export HISTFILE="$HOME/.zsh_history"
export FISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_OPTS="--height 40% --ansi --cycle --reverse --select-1 --exit-0 --bind=tab:down --bind=btab:up"

export XDG_CONFIG_HOME="$HOME/.config"
export VOLTA_HOME="$HOME/.volta"

export PATH="$HOME/.cargo/bin:$VOLTA_HOME/bin:$PATH"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

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
  local branch=$(git branch -a | tr -d " " | fzf +m --query="$LBUFFER" --prompt="switch > ")
  if [ -n "$branch" ]; then
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-git-switch
bindkey '^y' fzf-git-switch

if builtin command -v exa > /dev/null; then
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bhlHF"
  alias lla="exa -bhlHFa"
else
  alias ls="ls -FG"
  alias la="ls -A"
  alias ll="ls -l"
  alias lla="ls -AlF"
fi

if builtin command -v git > /dev/null; then
  alias gs="git status --short --branch"
  alias gl="git log -n 10 --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
  alias ga="git add"
  alias gc="git commit"
  alias gp="git push"
  alias gd="git diff"
  alias gb="git branch"
  alias gcm="git commit --message"
fi

if builtin command -v clip.exe > /dev/null; then
  alias pbcopy="clip.exe"
fi
