#!/usr/local/bin/zsh
#Lai Dev Fix Atom/Nuclide Script

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

printf "${GREEN}INFO: Removing Atom/Nuclide${NORMAL}\n"
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
echo "==========================================================================="
printf "${BLUE}SUCCESS: Removal complete${NORMAL}\n"
echo ""

printf "${GREEN}INFO: Starting Atom + Nuclide setup${NORMAL}\n"
# curl -o atom.zip -J -L https://atom.io/download/mac
# unzip -q atom.zip -d /Applications && rm -rf atom.zip
brew cask install --force atom 
git clone https://github.com/facebook/nuclide.git
cd $HOME/nuclide || exit
./scripts/dev/setup
printf "${BLUE}SUCCESS: Atom + Nuclide setup complete${NORMAL}\n"
echo ""

cd $HOME || exit

}

main
