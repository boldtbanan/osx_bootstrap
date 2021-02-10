#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Postgres.app (http://postgresapp.com/)
# - Docker desktop (https://www.docker.com/products/docker-desktop)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet. Otherwise, run
#   the following:
#
# echo "Installing xcode-stuff"
# xcode-select --install
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# Update homebrew recipes
brew update

PACKAGES=(
    git
    npm
    postgresql
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew install caskroom/cask/brew-cask

CASKS=(
    firefox
    github
    google-chrome
    google-drive
    iterm2
    microsoft-teams
    psequel
    slack
    visual-studio-code
    vlc
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-roboto
    font-jetbrains-mono
)
brew cask install ${FONTS[@]}

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install yarn -g

echo "Installing VSCode extensions..."
# To make it easier to automate and configure VS Code, it is possible to list, 
# install, and uninstall extensions from the command line. When identifying an 
# extension, provide the full name of the form publisher.extension, for example 
# donjayamanne.python. (https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line)

# code --list-extensions
# code --install-extension ms-vscode.cpptools
# code --uninstall-extension ms-vscode.csharp
VSCODE_EXTENSIONS=(
    esbenp.prettier-vscode
    jakebecker.elixir-ls
    CoenraadS.bracket-pair-colorizer
    Shan.code-settings-sync
    formulahendry.auto-rename-tag
    eamodio.gitlens
    donjayamanne.githistory
    xabikos.JavaScriptSnippets
    kamikillerto.vscode-colorize
    vscode-icons-team.vscode-icons
)

echo "Configuring OSX..."

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Creating folder structure..."
[[ ! -d Projects ]] && mkdir Projects



echo "Bootstrapping complete"
