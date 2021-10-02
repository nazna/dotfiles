#!/usr/bin/env bash

## ----------------------------------------
##  @ref https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh
## ----------------------------------------

function dock() {
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
}

function screenshot() {
  defaults write com.apple.screencapture location -string "$HOME/Downloads"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture name -string "ss"
  defaults write com.apple.screencapture include-date -bool true
}

function extra_settings() {
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.CrashReporter UseUNC 1
  sudo nvram SystemAudioVolume=" "
}

function finder() {
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowPreviewPane -bool true
  defaults write com.apple.finder ShowSidebar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowTabView -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
  defaults write com.apple.finder DisableAllAnimations -bool true
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 36" "$HOME/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" "$HOME/Library/Preferences/com.apple.finder.plist"
}

dock
screenshot
extra_settings
finder

killall Dock
killall Finder
killall SystemUIServer
