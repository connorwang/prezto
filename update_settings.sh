#!/usr/bin/env zsh
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


printf "${BOLD}${GREEN}INFO: Updating settings!${NORMAL}\n"
    rm -rf $HOME/.z*
    git clone --recursive https://github.com/ZenChat/Lai-Dev-Setup.git "${ZDOTDIR:-$HOME}/.zprezto"
    
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
    	ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
    done

    chmod go-w /usr/local/share
    echo ""

    arc set-config default https://dev.lai.io
    arc set-config base "git:merge-base(origin/master), arc:prompt"
    arc set-config history.immutable false
    arc set-config arc.land.update.default rebase
    arc set-config arc.land.onto.default master
    arc set-config arc.feature.start.default master
printf "${BOLD}${GREEN}INFO: NOW RE-OPEN YOUR TERMINAL TO MAKE ALL INSTALLATIONS EFFECTIVE!${NORMAL}\n"

}

main
