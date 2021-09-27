#!/usr/bin/env bash

## ----------------------------------------
##  @ref https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh
## ----------------------------------------

General() {
  defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 1
}

ScreenShot() {
  defaults write com.apple.screencapture location -string "$HOME/Downloads"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture name -string "ss"
  defaults write com.apple.screencapture include-date -bool true
  defaults write .GlobalPreferences AppleShowScrollBars -string "Automatic"
  defaults write .GlobalPreferences AppleScrollerPagingBehavior -bool true
}

Finder() {
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder NewWindowTarget -string "${HOME}"
  defaults write com.apple.finder FinderSpawnTab -bool true
  defaults write com.apple.finder ShowRecentTags -bool false
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  defaults write com.apple.finder FXRemoveOldTrashItems -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
  defaults write -g AppleShowAllExtensions -bool true

  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 36" "${HOME}"/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" "${HOME}"/Library/Preferences/com.apple.finder.plist

  defaults write com.apple.finder ShowSidebar -bool true
  defaults write com.apple.finder ShowPreviewPane -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowTabView -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder AppleShowAllFiles true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder DisableAllAnimations -bool true
}

Dock() {
  defaults write com.apple.dock tilesize -int 30
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.dock show-recents -bool false
}

EnergySaver() {
  defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Battery -int 18
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true
}

DateTime() {
  defaults write com.apple.menuextra.clock IsAnalog -bool false
  defaults write com.apple.menuextra.clock ShowSeconds -bool true
  defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
  defaults write com.apple.menuextra.clock Show24Hour -bool true
}

Keyboard() {
  defaults write .GlobalPreferences InitialKeyRepeat -int 15
  defaults write .GlobalPreferences KeyRepeat -int 2
}

ExtraSettings() {
  defaults delete com.apple.dock persistent-apps
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.CrashReporter UseUNC 1
  defaults -currentHost write com.apple.screensaver idleTime -int 0
  sudo nvram SystemAudioVolume=" "
}

## ----------------------------------------
##  Run
## ----------------------------------------
General
ScreenShot
Finder
Keyboard
ExtraSettings

killall Dock
killall Finder
killall SystemUIServer
