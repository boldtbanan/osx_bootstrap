#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# Grab and run this file via
#
# curl -o- https://raw.githubusercontent.com/boldtbanan/osx_bootstrap/main/osx_bootstrap.sh | bash
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Docker desktop (https://www.docker.com/products/docker-desktop)
# - Macpass (https://macpassapp.org)
# - Postgres.app (http://postgresapp.com/)
# - Princexml
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet. Otherwise, run
#   the following:
#
echo "Installing xcode-stuff"
xcode-select --install
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

if [ -f ~/.ssh/id_rsa ]; then
    echo "Public key already exists"
else
    echo "Generating ssh key..."

    ssh-keygen -t rsa

    echo "Please add this public key to Github \n"
    echo "https://github.com/account/ssh \n"
fi

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# Update homebrew recipes
brew update

echo "Installing packages..."
brew install awscli
brew install dockutil
brew install elixir
brew install git
brew install npm
brew install postgresql
brew install svn
brew install wget

echo "Cleaning up..."
brew cleanup

# echo "Installing cask..."
# brew install homebrew/cask/brew-cask

echo "Installing cask apps..."
brew install firefox
brew install github
brew install google-chrome
brew install google-backup-and-sync
brew install iterm2
brew install microsoft-teams
brew install postman
brew install psequel
brew install slack
brew install spotify
brew install visual-studio-code
brew install vlc
brew install zoom

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-roboto
    font-jetbrains-mono
)
# brew install ${FONTS[@]}
brew install font-roboto
brew install font-jetbrains-mono

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install yarn -g

echo "Installing elixir & phoenix"
# mix local.hex --force
# mix archive.install --force hex phx_new
# mix local.rebar --force

echo "Installing VSCode extensions..."
# To make it easier to automate and configure VS Code, it is possible to list, 
# install, and uninstall extensions from the command line. When identifying an 
# extension, provide the full name of the form publisher.extension, for example 
# donjayamanne.python. (https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line)

# code --list-extensions
# code --install-extension ms-vscode.cpptools
# code --uninstall-extension ms-vscode.csharp
code --install-extension esbenp.prettier-vscode
code --install-extension jakebecker.elixir-ls
code --install-extension CoenraadS.bracket-pair-colorizer
code --install-extension Shan.code-settings-sync
code --install-extension formulahendry.auto-rename-tag
code --install-extension eamodio.gitlens
code --install-extension donjayamanne.githistory
code --install-extension xabikos.JavaScriptSnippets
code --install-extension kamikillerto.vscode-colorize
code --install-extension vscode-icons-team.vscode-icons
 
echo "Configuring OSX..."

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

#Enable dragging from touchpad
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Setting Dock auto-hide and magnification
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock magnification -int 1

#"Enabling Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Configure hot corners
defaults write com.apple.dock wvous-bl-corner -int 12;
defaults write com.apple.dock wvous-bl-modifier -int 0;
defaults write com.apple.dock wvous-br-corner -int 4;
defaults write com.apple.dock wvous-br-modifier -int 0;
defaults write com.apple.dock wvous-tl-corner -int 3;
defaults write com.apple.dock wvous-tl-modifier -int 0;
defaults write com.apple.dock wvous-tr-corner -int 2;
defaults write com.apple.dock wvous-tr-modifier -int 0;

# Construct the dock
dockutil --remove Launchpad
dockutil --remove Safari
dockutil --remove Messages
dockutil --remove Mail
dockutil --remove Maps
dockutil --remove Photos
dockutil --remove FaceTime
dockutil --remove Contacts
dockutil --remove Reminders
dockutil --remove Notes
dockutil --remove Music
dockutil --remove Podcasts
dockutil --remove News
dockutil --remove 'App Store'

dockutil --add '/Applications/Google Chrome.app' --label 'Google Chrome' --replacing 'Google Chrome' --before 'Calendar'
dockutil --add '/Applications/Microsoft Teams.app' --label 'Microsoft Teams' --replacing 'Microsoft Teams' --before 'TV'
dockutil --add '/Applications/Slack.app' --label 'Slack' --replacing 'Slack' --before 'TV'
dockutil --add '/Applications/Spotify.app' --label 'Spotify' --replacing 'Spotify' --after 'TV'
dockutil --add '/Applications/Github Desktop.app' --label 'Github Desktop' --replacing 'Github Desktop' --after 'Spotify'
dockutil --add '/Applications/Visual Studio Code.app' --label 'Visual Studio Code' --replacing 'Visual Studio Code' --after 'Github Desktop'
dockutil --add '/Applications/iTerm.app' --label 'iTerm' --replacing 'iTerm' --after 'Visual Studio Code'
dockutil --add '/System/Applications/Utilities/Activity Monitor.app' --label 'Activity Monitor' --replacing 'Activity Monitor'

killall Finder
killall Dock

echo "Creating folder structure..."
[[ ! -d ~/Projects ]] && mkdir ~/Projects

# Create ssh keys
if [[ ! -f ~/.ssh/id_rsa ]]; then
    ssh-keygen -t rsa

    echo "Please add this public key to Github \n"
    echo "https://github.com/account/ssh \n"
    read -p "Press [Enter] key after this..."
else
    echo "SSH keys already exist"
fi

# Clone this repo locally so you have access to the other resources
[[ ! -d ~/Projects/osx_bootstrap ]] && git clone https://github.com/boldtbanan/osx_bootstrap.git ~/Projects/osx_bootstrap

echo "Bootstrapping complete"


