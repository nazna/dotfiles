#
# zplug
#

source $HOME/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug "modules/prompt", from:prezto

zplug "k4rthik/git-cal", as:command, frozen:1
zplug "mollifier/cd-gitroot"

zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "b4b4r07/zsh-gomi", on:"junegunn/fzf-bin"

zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "b4b4r07/emoji-cli", on:"stedolan/jq"

if ! zplug check; then
  zplug install
fi

zplug load

#
# prezto
#

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#
# anyenv
#

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"


#
# Z Shell
#

# 補完設定
autoload -U compinit; compinit

# 色設定
autoload -U colors; colors

# Emacs キーバインド
bindkey -e

# ビープ音を鳴らさない
setopt no_beep

# 実行可能なコマンドでなければ対象にcdする
setopt auto_cd
# cd先のディレクトリをスタックにpush
setopt auto_pushd
# TAB連打で補完を順に表示
setopt auto_menu
# 補完を詰めて表示
setopt list_packed
# 補完候補にファイルの種類も表示
setopt list_types
# pushdしたときスタックの重複を回避する
setopt pushd_ignore_dups

# コマンドの入力ミスを修正
setopt correct
# =以降も補完する
setopt magic_equal_subst
# エイリアス展開でも補完する
setopt complete_aliases
# 拡張globを有効化
setopt extended_glob
# globで大文字小文字を区別しない
unsetopt caseglob
# glob展開を一部抑制する
setopt nonomatch


# 履歴に時刻も記録する
setopt extended_history
# 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_dups
# スペースで始まるコマンドを履歴に追加しない
setopt hist_ignore_space
# 重複した履歴は追加しない
setopt hist_ignore_all_dups
# 余分な空白を除去して履歴に追加
setopt hist_reduce_blanks

# 履歴の保存ファイル
HISTFILE=$HOME/.zhistory
# メモリに保存する履歴の件数
HISTSIZE=1000
# 保存する履歴の件数
SAVESIZE=10000

# 改行のない出力をプロンプトで上書きしない
unsetopt promptcr


#
# gibo
#

_gibo() {
    local_repo=${GIBO_BOILERPLATES:-"$HOME/.gitignore-boilerplates"}
    if [ -e "$local_repo" ]; then
        compadd -M 'm:{[:lower:]}={[:upper:]}' $( find "$local_repo" -name "*.gitignore" -exec basename \{\} .gitignore \; )
    fi
}
compdef _gibo gibo


#
# Alias
#

# ls
case "${OSTYPE}" in
darwin*)
  alias ls="ls -GF"
  ;;
linux*)
  alias ls="ls -F --color=auto"
  ;;
esac

alias la="ls -A"
alias ll="ls -l"
alias lr="ls -R"
alias lal="ls -Al"

# rm
alias rm="rm -i"
alias rd="rm -rf"

# word
alias diff="diff -u"
alias grep="grep --color"
alias jwc="wc -m"

# vim, neovim
alias vi="nvim"
alias vim="nvim"

# git
alias g="git"
alias gs="git status ."
alias gl="git log --oneline --graph --no-merges -7 --pretty=format:'%C(yellow)%h%Creset %C(Blue)%<(8)%ar%Creset %s'"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gd="git diff"
alias gpl="git pull --rebase"
alias gld="git branch -d $(git branch --merged | grep -v master | grep -v '*')"

# copy, paste
alias pbc=pbcopy
alias pbcopy='xclip -selection clipboard -in'
alias pbp=pbpaste
alias pbpaste='xclip -selection clipboard -out'

# youtube-dl
alias mp3="youtube-dl -x --audio-format mp3 -o ~/Music/%(title)s.%(ext)s"
alias mp4="youtube-dl --format 'best[ext=mp4]' -o ~/Videos/%(title)s.%(ext)s"
alias mp42mp3="(){ ffmpeg -i $1 -ab 256k $2 }"
alias flv2mp4="(){ ffmpeg -i $1 -strict -experimental $2 }"
