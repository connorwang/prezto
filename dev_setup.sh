#!/bin/zsh
#Lai Dev Setup Script
main(){

export SHELL=/bin/zsh

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

cd "$HOME" || exit

read -p "${BOLD}${YELLOW}INFO: this will remove all your node / nvm / package installation and reinstall for you. \
As well as set up the dev environment and install the dependencies for you. \
Confirm to continue? (y or n)${NORMAL} " -r

if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]
then

echo ""
echo "##############################################################################################"
echo ""
printf "${GREEN}${BOLD}Starting Lai dev script to set up dev environment${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Homebrew${NORMAL}\n"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade
printf "${BLUE}SUCCESS: Homebrew setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Zsh and Prezto${NORMAL}\n"
brew install zsh zsh-completions
rm -rf $HOME/.z*
git clone --recursive https://github.com/ZenChat/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
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
export NVM_DIR="$HOME/.nvm"
cp $(brew --prefix nvm)/nvm-exec $HOME/.nvm/
export NVM_DIR=$HOME/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm install node && nvm alias default node
npm install -g npm@2

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

printf "${GREEN}INFO: Install ESLint and required plugin${NORMAL}\n"
npm install -g eslint babel-eslint eslint-plugin-react eslint-plugin-import gulp mocha
printf "${BLUE}SUCCESS: ESLint and required plugin setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Install Watchman & Flow${NORMAL}\n"
brew install watchman flow
printf "${BLUE}SUCCESS: Watchman & Flow setup complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Starting Atom + Nuclide setup${NORMAL}\n"
git clone https://github.com/facebook/nuclide.git
cd "$HOME/nuclide" || exit
./scripts/dev/setup
printf "${BLUE}SUCCESS: Atom + Nuclide setup complete${NORMAL}\n"
echo ""

cd "$HOME" || exit

printf "${GREEN}INFO: Starting arc setup${NORMAL}\n"
mkdir -p "$HOME/phabricator"
cd "$HOME/phabricator" || exit

rm -rf $HOME/phabricator/arcanist
git clone https://github.com/ZenChat/arcanist.git

rm -rf $HOME/phabricator/libphutil
git clone https://github.com/ZenChat/libphutil.git

printf "${BLUE}SUCCESS: arc setup complete${NORMAL}\n"
echo ""
echo "##############################################################################################"
echo ""

cd "$HOME" || exit
touch $HOME/.bashrc
touch $HOME/.zshrc

SYSPATH='export PATH="/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/phabricator/arcanist/bin/"'
NVMPATH='export NVM_DIR=$HOME/.nvm'
LOADNVM='source $(brew --prefix nvm)/nvm.sh'
NPMCOMPLETION='[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion'
ARCCOMPLETION='source "$HOME/phabricator/arcanist/resources/shell/bash-completion"'
SQUISHALIAS='alias squish="git status && git commit -a --amend -C HEAD"'
ARCUPGRADE='alias arcupgrade="git -C $HOME/phabricator/arcanist pull && git -C $HOME/phabricator/libphutil pull"'

function shellfile_append() {
  for file in $HOME/.bashrc $HOME/.zshrc; do
    grep -q -F "$*" $file || echo "$*" >> $file
  done 
}

shellfile_append $SYSPATH
shellfile_append $NVMPATH
shellfile_append $LOADNVM
shellfile_append $NPMCOMPLETION
shellfile_append $ARCCOMPLETION
shellfile_append $SQUISHALIAS
shellfile_append $ARCUPGRADE
shellfile_append $ZSHPLUGIN
shellfile_append $ZSHTHEME

echo "${BOLD}${GREEN}INFO: Changing default shell to zsh. Please enter your password."
chsh -s $(which zsh)
echo ""

echo ""
printf "${BOLD}${BLUE}SUCCESS: dev environment setup complete!${NORMAL}\n"
echo ""

printf "${BOLD}${GREEN}INFO: NOW RE-OPEN YOUR TERMINAL TO MAKE ALL INSTALLATIONS EFFECTIVE!${NORMAL}\n"

fi
}

main