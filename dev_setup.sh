#!/usr/bin/env bash
#Lai Dev Setup Script
main(){

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
  
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi


defaults write com.apple.finder AppleShowAllFiles YES; # show hidden files
# defaults write com.apple.dock persistent-apps -array; # remove icons in Dock
defaults write com.apple.dock tilesize -int 36; # smaller icon sizes in Dock
defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
defaults write com.apple.dock autohide-delay -float 0; # remove Dock show delay
defaults write com.apple.dock autohide-time-modifier -float 0; # remove Dock show delay
# defaults write com.apple.dock orientation right; # place Dock on the right side of screen
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; # show all file extensions
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES; # Display full path in terminal

killall Dock 2>/dev/null;
killall Finder 2>/dev/null;

cd $HOME || exit
read -p "${BOLD}${YELLOW}INFO: this will remove all your node / nvm / package installation and reinstall for you. \
As well as set up the dev environment and install the dependencies for you. \
Confirm to continue? (y or n)${NORMAL} " -r

if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]
then

echo ""
echo "============================================================================================"
echo ""
printf "${GREEN}${BOLD}Starting Lai dev script to set up dev environment${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Xcode Commandline Tools${NORMAL}\n"
# install Xcode Command Line Tools
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD";
echo ""

printf "${GREEN}INFO: Install Homebrew${NORMAL}\n"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask
brew tap caskroom/versions;
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
printf "${BLUE}SUCCESS: Homebrew setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Zsh and Prezto${NORMAL}\n"
brew install zsh zsh-completions
rm -rf $HOME/.z*
git clone --recursive https://github.com/ZenChat/Lai-Dev-Setup.git "${ZDOTDIR:-$HOME}/.zprezto"
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
done
echo ""

printf "${GREEN}INFO: Re-install Node, npm and NVM${NORMAL}\n"
brew uninstall node &>/dev/null
brew uninstall nvm &>/dev/null
rm -f /usr/local/bin/npm
rm -f /usr/local/lib/dtrace/node.d
rm -rf $HOME/.npm
rm -rf $HOME/.nvm
brew prune

mkdir $HOME/.nvm
brew install nvm
cp $(brew --prefix nvm)/nvm-exec $HOME/.nvm/
export NVM_DIR=$HOME/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm install v0.12.7 # compatible node version for LeanCloud
nvm install node && nvm alias default node
npm install -g npm@2 &>/dev/null
printf "${BLUE}SUCCESS: Re-install Node, npm and NVM complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install PHP${NORMAL}\n"
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/php
brew install php56
printf "${BLUE}SUCCESS: PHP setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Git${NORMAL}\n"
brew install git
printf "${BLUE}SUCCESS: Git setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install ReactNative Client${NORMAL}\n"
npm install -g react-native-cli
printf "${BLUE}SUCCESS: ReactNative Client setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install AVOS Cloud and completion script${NORMAL}\n"
curl -o $HOME/.avoscloud_completion.sh -J -L https://raw.githubusercontent.com/leancloud/avoscloud-code-command/master/avoscloud_completion.sh
chmod a+x .avoscloud_completion.sh
npm install -g avoscloud-code
printf "${BLUE}SUCCESS: AVOS Cloud and completion script${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install ESLint and required plugin${NORMAL}\n"
npm install -g eslint babel-eslint eslint-plugin-react eslint-plugin-import gulp mocha
printf "${BLUE}SUCCESS: ESLint and required plugin setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Watchman & Flow${NORMAL}\n"
brew install watchman flow
printf "${BLUE}SUCCESS: Watchman & Flow setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Starting Atom + Nuclide setup${NORMAL}\n"
rm -rf $HOME/atom.zip
rm -rf $HOME/.atom
rm -rf $HOME/nuclide
rm -rf /usr/local/bin/atom
rm -rf /usr/local/bin/apm
rm -rf /Applications/Atom.app
rm -rf $HOME/Library/Preferences/com.github.atom.plist
rm -rf $HOME/Library/Application\ Support/com.github.atom.ShipIt
rm -rf $HOME/Library/Application\ Support/Atom
rm -rf $HOME/Library/Saved\ Application\ State/com.github.atom.savedState
rm -rf $HOME/Library/Caches/com.github.atom
rm -rf $HOME/Library/Caches/Atom
# curl -o atom.zip -J -L https://atom.io/download/mac
# unzip -q atom.zip -d /Applications/ && rm -rf atom.zip
brew cask install --force atom
git clone https://github.com/facebook/nuclide.git $HOME/nuclide
cd $HOME/nuclide || exit
./scripts/dev/setup
apm install linter-eslint
printf "${BLUE}SUCCESS: Atom + Nuclide setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Starting iTerm2, Quip, Slack, Sketch, Zeplin and SourceTree Setup${NORMAL}\n"
cd /Applications
rm -rf iTerm.app && brew cask install iterm2 --force 
rm -rf Quip.app && brew cask install quip --force   
rm -rf Slack.app && brew cask install slack --force 
rm -rf Sketch.app && brew cask install sketch --force 
rm -rf SourceTree.app && brew cask install sourcetree --force

rm -rf Zeplin.app
cd $HOME || exit
curl -o $HOME/zeplin.zip -J -L https://zpl.io/download
unzip -q $HOME/zeplin.zip -d /Applications/ && rm -rf $HOME/zeplin.zip
printf "${BLUE}SUCCESS: iTerm2, Quip, Slack, Sketch, Zeplin and SourceTree Setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Starting arc setup${NORMAL}\n"
mkdir -p $HOME/phabricator
cd $HOME/phabricator || exit

rm -rf $HOME/phabricator/arcanist
git clone https://github.com/ZenChat/arcanist.git

rm -rf $HOME/phabricator/libphutil
git clone https://github.com/ZenChat/libphutil.git

printf "${BLUE}SUCCESS: arc setup complete${NORMAL}\n"
echo ""
echo "============================================================================================"
echo ""

cd $HOME || exit
touch $HOME/.bashrc
touch $HOME/.zshrc

SYSPATH='export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/phabricator/arcanist/bin"'
LOADNVM='source $(brew --prefix nvm)/nvm.sh'
NVMPATH='export NVM_DIR=$HOME/.nvm'
ANDROIDPATH='export ANDROID_HOME=/usr/local/opt/android-sdk'
NPMCOMPLETION='[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion'
AVOSCOMPLETION='source $HOME/.avoscloud_completion.sh'
ARCCOMPLETION='source "$HOME/phabricator/arcanist/resources/shell/bash-completion"'
SQUISHALIAS='alias squish="git status && git commit -a --amend -C HEAD"'
ARCUPGRADE='alias arcupgrade="git -C $HOME/phabricator/arcanist pull --rebase && git -C $HOME/phabricator/libphutil pull --rebase"'
REPOUP='alias repoup='\''sh -c "$(curl -fsSL https://raw.githubusercontent.com/ZenChat/Lai-Dev-Setup/master/set_up_repo.sh)"'\'''

function shellfile_append() {
  for file in $HOME/.bashrc $HOME/.zshrc; do
    grep -q -F "$*" $file || echo "$*" >> $file
  done 
}

shellfile_append $SYSPATH
shellfile_append $NPMCOMPLETION
shellfile_append $ARCCOMPLETION
shellfile_append $SQUISHALIAS
shellfile_append $ARCUPGRADE
shellfile_append $ZSHPLUGIN
shellfile_append $ZSHTHEME
shellfile_append $ANDROIDPATH
shellfile_append $AVOSCOMPLETION
shellfile_append $NVMPATH
shellfile_append $LOADNVM

echo "${BOLD}${GREEN}INFO: Changing default shell to zsh. Please enter your password."
grep -q -F "/usr/local/bin/zsh" /etc/shells || echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
echo ""

echo ""
printf "${BOLD}${BLUE}SUCCESS: dev environment setup complete!${NORMAL}\n"
echo ""

printf "${BOLD}${GREEN}INFO: NOW RE-OPEN YOUR TERMINAL TO MAKE ALL INSTALLATIONS EFFECTIVE!${NORMAL}\n"

fi
}

main
