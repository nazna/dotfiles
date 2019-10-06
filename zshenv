export LESS="-R"
export EDITOR=nvim
export FCEDIT=nvim

export LANG="ja_JP.UTF-8"

export HISTFILE=$HOME/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_OPTS="--height 40% --ansi --reverse --preview-window down:1"

export DOTPATH=$HOME/workspace/ghq/github.com/naoya3e/dotfiles

export XDG_CONFIG_HOME=$HOME/.config

export NVM_DIR=$XDG_CONFIG_HOME/.nvm
export NVM_HOME/usr/local/opt/nvm
export ZPLUG_HOME=/usr/local/opt/zplug

export GOPATH=$HOME/.go
export FZFPATH=$HOME/.fzf
export CARGOPATH=$HOME/.cargo

export PATH=$GOPATH/bin:$CARGOPATH/bin:$FZFPATH/bin${PATH:+:${PATH}}
