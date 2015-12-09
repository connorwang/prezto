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

cd $HOME || exit

read -p "${BOLD}${YELLOW}INFO: this will remove all your node / nvm / package installation and reinstall for you. \
As well as set up the dev environment and install the dependencies for you. \
Confirm to continue? (y or n)${NORMAL} " -r

if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then

    echo ""
    echo "============================================================================================"
    echo ""
    printf "${GREEN}${BOLD}Starting Lai dev script to set up dev environment${NORMAL}\n"
    echo ""

    printf "${GREEN}INFO: Install Xcode Commandline Tools${NORMAL}\n"
    # install Xcode Command Line Tools
    # https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l |
      grep "\*.*Command Line" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ *//' |
      tr -d '\n')
    softwareupdate -i "$PROD"
    echo ""

    printf "${GREEN}INFO: Install Homebrew${NORMAL}\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
    # brew install caskroom/cask/brew-cask
    brew tap caskroom/versions
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    brew update && brew upgrade --all && brew cleanup && brew cask cleanup
    printf "${BLUE}SUCCESS: Homebrew setup complete${NORMAL}\n"
    echo ""

    printf "${GREEN}INFO: Install Zsh and Prezto${NORMAL}\n"
    brew install zsh zsh-completions
    rm -rf $HOME/.z*
    git clone --recursive https://github.com/ZenChat/Lai-Dev-Setup.git "${ZDOTDIR:-$HOME}/.zprezto"  &>/dev/null
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
    done
    chmod go-w /usr/local/share
    echo ""

    printf "${GREEN}INFO: Re-install rbenv and ruby${NORMAL}\n"
    rvm implode &>/dev/null
    rm -rf $HOME/.rvm
    brew install rbenv ruby-build
    echo ""

    printf "${GREEN}INFO: Re-install Node, npm and NVM${NORMAL}\n"
    brew uninstall node &>/dev/null
    brew uninstall nvm &>/dev/null
    rm -f /usr/local/{bin/npm,lib/dtrace/node.d}
    rm -rf $HOME/.{npm,nvm}
    brew prune
    mkdir $HOME/.nvm
    brew install nvm &>/dev/null
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
    npm install -g eslint babel-eslint eslint-plugin-{react,import} gulp mocha
    printf "${BLUE}SUCCESS: ESLint and required plugin setup complete${NORMAL}\n"
    echo ""

    printf "${GREEN}INFO: Install Watchman & Flow${NORMAL}\n"
    brew install watchman flow
    printf "${BLUE}SUCCESS: Watchman & Flow setup complete${NORMAL}\n"
    echo ""
    
    cd $HOME || exit

    printf "${GREEN}INFO: Starting arc setup${NORMAL}\n"
    mkdir -p $HOME/phabricator
    cd $HOME/phabricator || exit

    rm -rf $HOME/phabricator/arcanist
    git clone https://github.com/ZenChat/arcanist.git

    rm -rf $HOME/phabricator/libphutil
    git clone https://github.com/ZenChat/libphutil.git
    
    export PATH="$HOME/phabricator/arcanist/bin:$PATH"
    arc set-config default https://dev.lai.io
    arc set-config base "git:merge-base(origin/master), arc:prompt"
    arc set-config history.immutable false
    arc set-config arc.land.update.default rebase
    arc set-config arc.land.onto.default master
    arc set-config arc.feature.start.default master

    printf "${BLUE}SUCCESS: arc setup complete${NORMAL}\n"
    echo ""
    echo "============================================================================================"
    echo ""

    cd $HOME || exit

    RBENVINIT='if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi'
    SYSPATH='export PATH="/usr/local/sbin:$(brew --prefix)/bin:/usr/bin:/bin:/usr/x11/bin:/usr/sbin:/sbin"'
    PHABPATH='export PATH="$HOME/phabricator/arcanist/bin:$PATH"'
    RBENVPATH='export PATH="$HOME/.rbenv/bin:$PATH"'
    NVMPATH='export NVM_DIR=$HOME/.nvm'
    LOADNVM='source $(brew --prefix nvm)/nvm.sh'
    ARCCOMPLETION='source "$HOME/phabricator/arcanist/resources/shell/bash-completion"'
    AVOSCOMPLETION='source $HOME/.avoscloud_completion.sh'
    ANDROIDPATH='export ANDROID_HOME=/usr/local/opt/android-sdk'
    FPATH='fpath=(/usr/local/share/zsh-completions $fpath)'
    CASKPATH='export HOMEBREW_CASK_OPTS="--appdir=/Applications"'
    SQUISHALIAS='alias squish="git status && git commit -a --amend -C HEAD"'
    DEVUPDATEALIAS='alias devupdate="git -C $HOME/phabricator/arcanist pull --rebase && git -C $HOME/phabricator/libphutil pull --rebase \
    && git -C $HOME/.zprezto pull --rebase"'
    REPOUPALIAS='alias repoup='\''sh -c "$(curl -fsSL https://raw.githubusercontent.com/ZenChat/Lai-Dev-Setup/master/set_up_repo.sh)"'\'''

    function shellfile_append() {
      for file in .{bash,zsh}rc; do
        grep -Fxq "$*" $file || echo "$*" >> $file
      done 
    }

    for input in "$RBENVINIT" "$SYSPATH" "$PHABPATH" "$NVMPATH" "$LOADNVM" \
    "$ARCCOMPLETION" "$AVOSCOMPLETION" "$ANDROIDPATH" "$FPATH" "$CASKPATH" \
    "$SQUISHALIAS" "$DEVUPDATEALIAS" "$REPOUPALIAS"; do
        shellfile_append $input
    done

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