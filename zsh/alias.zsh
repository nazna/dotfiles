if type eza > /dev/null 2>&1; then
  alias ls="eza -F"
  alias la="eza -aF"
  alias ll="eza -bghlHF --sort=type --time-style=long-iso --octal-permissions"
  alias lla="eza -abghlHF --sort=type --time-style=long-iso --octal-permissions"
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
  alias gg="git fetch --all --prune; git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -D"
fi

if type clip.exe > /dev/null 2>&1; then
  alias pbcopy="clip.exe"
fi

if type powershell.exe > /dev/null 2>&1; then
  alias pbpaste="powershell.exe -command 'Get-Clipboard'"
fi
