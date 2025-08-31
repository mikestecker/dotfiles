#!/usr/bin/env bash
#
# macOS defaults optimized for frontend development
# Based on Robin Wieruch's recommendations and web development best practices

set -e

echo "Setting macOS defaults for frontend development..."

# Screenshots as JPG (smaller size, better for web development)
defaults write com.apple.screencapture type jpg
echo "✓ Screenshots will be saved as JPG"

# Don't open previous previewed files when opening a new one
defaults write com.apple.Preview ApplePersistenceIgnoreState YES
echo "✓ Preview won't reopen previous files"

# Show Library folder (useful for development)
chflags nohidden ~/Library
echo "✓ Library folder is now visible"

# Show hidden files in Finder (important for .env, .gitignore, etc.)
defaults write com.apple.finder AppleShowAllFiles YES
echo "✓ Hidden files are now visible in Finder"

# Show path bar in Finder (helpful for file management)
defaults write com.apple.finder ShowPathbar -bool true
echo "✓ Path bar enabled in Finder"

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
echo "✓ Status bar enabled in Finder"

# Expand save panel by default (faster file saving)
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
echo "✓ Save panels will expand by default"

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
echo "✓ Print panels will expand by default"

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
echo "✓ Documents will save to disk by default (not iCloud)"

# Automatically quit printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
echo "✓ Printer app will quit automatically when finished"

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
echo "✓ Disabled application quarantine warnings"

# Remove duplicates in the "Open With" menu
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
echo "✓ Cleaned up 'Open With' menu"

# Disable automatic termination of inactive apps (useful for development)
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
echo "✓ Disabled automatic termination of inactive apps"

# Set a faster key repeat rate (useful for coding)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo "✓ Set faster key repeat rate"

# Enable full keyboard access for all controls (useful for accessibility testing)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
echo "✓ Enabled full keyboard access"

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
echo "✓ Enabled scroll to zoom with Ctrl key"

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
echo "✓ Zoom follows keyboard focus"

# Disable press-and-hold for keys in favor of key repeat (better for coding)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
echo "✓ Disabled press-and-hold for keys"

# Set language and text formats for development
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false
echo "✓ Set US English locale and measurement units"

# Show remaining battery time; hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"
echo "✓ Battery shows time remaining"

# Trackpad settings for better development experience
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
echo "✓ Enabled tap to click"

# Enable 3-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
echo "✓ Enabled 3-finger drag"

# Hot corners for development workflow
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0
echo "✓ Set up hot corners for development workflow"

# Wipe all (default) app icons from the Dock (for a clean development setup)
defaults write com.apple.dock persistent-apps -array
echo "✓ Cleared default Dock apps"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
echo "✓ Disabled automatic Space rearrangement"

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
echo "✓ Hidden app icons will be translucent in Dock"

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
echo "✓ Disabled recent applications in Dock"

# Privacy: Don't send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
echo "✓ Disabled Safari search suggestions"

# Web development: Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
echo "✓ Enabled Safari developer tools"

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
echo "✓ Enabled Web Inspector context menu"

echo ""
echo "Killing affected applications..."

# Kill affected applications
for app in "Dock" "Finder" "Safari" "SystemUIServer"; do
    killall "${app}" &> /dev/null || true
done

echo ""
echo "✅ macOS defaults for frontend development have been applied!"
echo "Note: Some changes require a logout/restart to take effect."
