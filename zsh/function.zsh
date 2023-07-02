function fzf_history() {
  BUFFER=$(history -n -r 1 | fzf -e +s +m --query="$LBUFFER" --prompt="history > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}

function fzf_ghq() {
  local repository=$(ghq list | fzf +m --query="$LBUFFER" --prompt="ghq > ")
  if [[ -n "$repository" ]]; then
    BUFFER="cd $(ghq root)/${repository}"
    zle accept-line
  fi
  zle reset-prompt
}

function fzf_switch() {
  local branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sed 's/origin\///' | awk '!a[$1]++' | grep -x -v 'HEAD' | grep -x -v $(git symbolic-ref --short HEAD) | fzf +m --query="$LBUFFER" --prompt="switch > ")
  if [[ -n "$branch" ]]; then
    BUFFER="git switch ${branch}"
    zle accept-line
  fi
  zle reset-prompt
}
