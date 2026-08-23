# shellcheck shell=sh

is_wsl() {
  [ -d /run/WSL ]
}

is_native_linux() {
  [ "$(uname -s)" = "Linux" ] && ! is_wsl
}

is_hyprland() {
  pgrep -x Hyprland > /dev/null
}

is_omarchy() {
  [ "$(. /etc/os-release && echo "${ID:-}")" = "omarchy" ]
}
