export FZF_DEFAULT_OPTS="--height 40% --ansi --cycle --reverse --select-1 --exit-0 --bind=tab:down --bind=btab:up"

function fzf_history() {
  BUFFER=$(history -n -r 1 | fzf -e +s +m --query="$LBUFFER" --prompt="history > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf_history
bindkey '^r' fzf_history

function fzf_ghq() {
  local repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="ghq > ")
  if [[ -n "$repository" ]]; then
    BUFFER="cd $(ghq root)/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_ghq
bindkey '^g' fzf_ghq

function fzf_switch() {
  local branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sed 's/origin\///' | awk '!a[$1]++' | grep -x -v 'HEAD' | grep -x -v $(git symbolic-ref --short HEAD) | fzf +m --query="$LBUFFER" --prompt="switch > ")
  if [[ -n "$branch" ]]; then
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_switch
bindkey '^b' fzf_switch
