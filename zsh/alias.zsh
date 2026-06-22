alias cdw="cd ${HOME}/work"
alias cds="cd ${HOME}/sandbox"
alias reload="exec ${SHELL} -l"

alias ls="eza -F"
alias la="eza -aF"
alias ll="eza -bghlHF --sort=type --time-style=long-iso --octal-permissions"
alias lla="eza -abghlHF --sort=type --time-style=long-iso --octal-permissions"
alias tree="eza --tree"

alias gs="git status --short --branch"
alias gl="git log -n 10 --date=short --pretty=format:'%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s'"
alias gb="git branch"
alias gd="git diff"
alias ga="git add"
alias gcm="git commit --message"
alias gps="git push"
alias gpl="git pull"
alias gg="git fetch --all --prune && git branch -vv | awk '/: gone]/{print \$1}' | grep -v '*' | xargs git branch -D"

alias pic="pi --continue"

alias pbcopy="clip.exe"
alias pbpaste="powershell.exe -command 'Get-Clipboard'"
