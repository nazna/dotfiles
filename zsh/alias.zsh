alias cdw="cd ${HOME}/work"
alias cds="cd ${HOME}/sandbox"
alias up='cd ..'
alias reload="exec ${SHELL} -l"

alias ls='eza --classify=auto'
alias la='eza -a --classify=auto'
alias ll='eza -lo --no-user --classify=auto --sort=type --time-style=long-iso'
alias lla='eza -alo --no-user --classify=auto --sort=type --time-style=long-iso'
alias tree='eza --tree'

alias gs='git status --short --branch'
alias gl='git --no-pager log -10 --date=short --pretty=format:"%C(yellow)%h %C(green)%cd %C(blue)%cn %C(reset)%s"'
alias gb='git --no-pager branch --no-column'
alias gd='git diff ":(exclude)package-lock.json"'
alias ga='git add'
alias gcm='git commit --message'
alias gps='git push'
alias gpl='git pull'
alias gg='git fetch --all --prune && git branch -vv | awk "/: gone]/{print \$1}" | xargs git branch -D'

alias pic='pi --continue'

alias pbcopy='clip.exe'
alias pbpaste='powershell.exe -command "Get-Clipboard"'
