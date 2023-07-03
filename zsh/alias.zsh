if type exa > /dev/null 2>&1; then
  alias l="exa -F"
  alias ls="exa -F"
  alias la="exa -Fa"
  alias ll="exa -bghlHF --sort=type --time-style=long-iso --octal-permissions"
  alias lla="exa -bghlHFa --sort=type --time-style=long-iso --octal-permissions"
else
  alias l="ls -hFG"
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

if type minikube > /dev/null 2>&1; then
  alias kubectl="minikube kubectl --"
fi

if type clip.exe > /dev/null 2>&1; then
  alias pbcopy="clip.exe"
fi

if type powershell.exe > /dev/null 2>&1; then
  alias pbpaste="powershell.exe -command 'Get-Clipboard'"
fi
