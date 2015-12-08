#!/usr/bin/env bash
#Lai OSX UI Hack Script

prod_hack(){

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

	show_allfile(){ 
		read -r -p "${BOLD}${GREEN}Show hidden files in Finder? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then
			defaults write com.apple.finder AppleShowAllFiles YES
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.finder AppleShowAllFiles
		fi
	}

	remove_icons(){
		read -r -p "${BOLD}${GREEN}Remove default icons in dock? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then
			defaults write com.apple.dock persistent-apps -array
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock persistent-apps
		fi
	}

	resize_icons(){
		read -r -p "${BOLD}${GREEN}Enable smaller dock icons? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then
			defaults write com.apple.dock tilesize -int 36
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock tilesize
		fi
	}

	autohide_dock(){
		read -r -p "${BOLD}${GREEN}Enable dock auto-hide? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then
			defaults write com.apple.dock autohide -bool true
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock autohide
		fi
	}

	remove_dock_delay(){
		read -r -p "${BOLD}${GREEN}Remove dock auto-hide delay? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write com.apple.dock autohide-delay -float 0
			defaults write com.apple.dock autohide-time-modifier -float 0
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock autohide-delay
			defaults delete com.apple.dock autohide-time-modifier
		fi
	}

	show_file_extension(){
		read -r -p "${BOLD}${GREEN}Show all file extension ? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write NSGlobalDomain AppleShowAllExtensions -bool true
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete NSGlobalDomain AppleShowAllExtensions
		fi
	}

	display_full_path(){
		read -r -p "${BOLD}${GREEN}Display full file path in the title ? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.finder _FXShowPosixPathInTitle
		fi
	}

	remove_missioncontrol_delay(){
		read -r -p "${BOLD}${GREEN}Remove Mission Control animation delay? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write com.apple.dock expose-animation-duration -float 0
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock expose-animation-duration
		fi
	}

	dock_location(){
		read -r -p "${BOLD}${GREEN}Where would you like to place your doc? (1 = left, 2 = right, 3 = bottom)${NORMAL} " reply
		if [[ $reply =~ ^([left]|[right]|[bottom]|[1]|[2]|[3])$ ]]; then
			case $reply in
				1|left)
					defaults write com.apple.dock orientation left
					;;
				2|right)
					defaults write com.apple.dock orientation right
					;;
				3|bottom)
					defaults write com.apple.dock orientation bottom
					;;
			esac
		fi
	}

	disable_open_close_windows_animation(){
		read -r -p "${BOLD}${GREEN}Disable open and close window animation? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -boolean false
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled
		fi
	}

	scale_effect(){
		read -r -p "${BOLD}${GREEN}Use scale effect instead of genie effect while minimizing windows? (y or n)${NORMAL} "
		if [[ $REPLY =~ ^(Y|y|yes|Yes)$ ]]; then	
			defaults write com.apple.dock mineffect -string "scale"
		elif [[ $REPLY =~ ^(N|n|no|NO)$ ]]; then
			defaults delete com.apple.dock mineffect
		fi
	}
	
	dock_location
	show_allfile
	remove_icons
	resize_icons
	autohide_dock
	remove_dock_delay
	show_file_extension
	display_full_path
	remove_missioncontrol_delay
	disable_open_close_windows_animation
	scale_effect

	killall Dock 2>/dev/null;
	killall Finder 2>/dev/null;
}

prod_hack
