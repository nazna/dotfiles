export LANG="ja_JP.UTF-8"

export LESS="-R"
export EDITOR="vim"
export FCEDIT="vim"

export FISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_OPTS="--height 40% --ansi --cycle --reverse --select-1 --exit-0 --bind=tab:down --bind=btab:up"

export XDG_CONFIG_HOME="$HOME/.config"
export VOLTA_HOME="$HOME/.volta"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

export PATH="$HOME/.cargo/bin:$VOLTA_HOME/bin:$PATH"
