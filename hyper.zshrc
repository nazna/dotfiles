precmd() {
   printf "\e]0;%s\a" "$PWD"
}

preexec() {
   printf "\e]0;%s\a" "${1%% *} | $cwd"
}

