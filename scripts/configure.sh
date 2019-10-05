echo "Configuring..."
defaults write com.apple.screencapture disable-shadow -boolean true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.CrashReporter DialogType -string "none"

echo "Configuring Dock..."
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock tilesize -int 37
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock expose-animation-duration -float 0

echo "Configuring Security and Privacy..."
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

echo "Configuring Energy..."
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

echo "Configuring Keyboard..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "Configuring Trackpad..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Configuring Software update..."

echo "Configuring Date and Clock..."
defaults write com.apple.menuextra.clock DateFormat -string "yyyy/MM/dd EEE HH:mm"
defaults write com.apple.menuextra.clock IsAnalog -bool false

echo "Configuring Finder..."
defaults write com.apple.Finder FXPreferredViewStyle -string "icnv"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://Users/naoya/"

echo "Reflect configuration..."
killall Dock
killall Finder
killall SystemUIServer
killall System\ Preferences

echo
echo "Configuration is done. Please restart system."
echo

