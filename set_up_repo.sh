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

read -p "${GREEN}Enter your ${BOLD}${RED}first & last name${NORMAL}: " -r FIRSTNAME LASTNAME
read -p "${GREEN}Enter your ${BOLD}${RED}lai.io email address${NORMAL}: " -r EMAIL
git config user.name "$FIRSTNAME $LASTNAME"
git config user.email "$EMAIL"

git config branch.*branch-name*.rebase true # Force existing branches to use rebase.
git config branch.autosetuprebase always # Force all new branches to automatically use rebase
git config branch.master.rebase true

echo ""
printf "${BOLD}${BLUE}SUCCESS: repo setup complete!${NORMAL}\n"
echo ""

}

main