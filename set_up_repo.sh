#!/usr/local/bin/zsh
#Lai Dev Repo-setup Script

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

echo "[user]" >> ./.git/config

read -p "${BOLD}${YELLOW}Enter your full name: ${NORMAL} " -r

echo "\tb"$REPLY >> ./.git/config

read -p "${BOLD}${YELLOW}Enter your lai.io email address: ${NORMAL} " -r

echo "\tb"$REPLY >> ./.git/config

}

main