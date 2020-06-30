#!/usr/bin/env bash
# A script to setup my environment settings.

# FUNCTION - DETERMINE OPERATING SYSTEM {{{
function determine_os() {
  # SHOW AVAILBLE OSES
  printf "Available Operating Systems:\n"
  printf "(1) Ubuntu 16.04\n"
  printf "(2) Ubuntu 18.04\n"
  printf "(3) MacOS (requires Homebrew)\n"
  printf "\n"
  read -p 'Please choose an operating system: ' -n1 answer
  printf "\n"

  # VALIDATE RESPONSE
  if [[ $answer = '1' ]]; then
    PLATFORM='Ubuntu 16.04'
  elif [[ $answer = '2' ]]; then
    PLATFORM='Ubuntu 18.04'
  elif [[ $answer = '3' ]]; then
    PLATFORM='MacOS'
  else
    printf "That is not an option. Try again.\n"
    exit 0
  fi
  printf "\n"

  # CONTINUE
  printf "Setup proceeding for $PLATFORM.\n\n"
}
# }}}
# FUNCTION - CLEAR PREVIOUS SETTINGS {{{
function clear_settings() {
  printf "Clearing previous settings...\n\n"
  datetime=`date +"%Y-%m-%d_%T"`
  cd ~

  # vimrc
  if [ -f ".vimrc" ]; then
    mv .vimrc .vimrc_$datetime
  fi

  # vim
  if [ -d ".vim" ]; then
    mv .vim .vim_$datetime
  fi

  # bashrc
  if [ -f ".bashrc" ]; then
    mv .bashrc .bashrc_$datetime
  fi

  # bash_profile
  if [ -f ".bash_profile" ]; then
    mv .bash_profile .bash_profile_$datetime
  fi
  
  # gitconfig
  if [ -f ".gitconfig" ]; then
    mv .gitconfig .gitconfig_$datetime
  fi

  # inputrc
  if [ -f ".inputrc" ]; then
    mv .inputrc .inputrc_$datetime
  fi

  # Tilix is only usable on Ubuntu
  if [[ $PLATFORM = 'Ubuntu 16.04' ]] || [[ $PLATFORM = 'Ubuntu 18.04' ]]; then
    if [ -d "~/.config/tilix" ]; then
      mv ~/.config/tilix ~/.config/tilix_$datetime
    fi
  fi
}
# }}}
# FUNCTION - CREATE NEW SETTINGS {{{
function create_settings() {
  read -p 'Would you like to install ERDC settings? (y/n) ' -n1 answer
  printf "\n\n"
  if [[ $answer = [yY] ]]; then
    printf "Adding ERDC settings to bashrc..."
    printf "\n\n"
    echo "" >> ~/.env/dotfiles/bashrc
    echo "# ERDC Settings" >> ~/.env/dotfiles/bashrc
    echo "source ~/.env/dotfiles/bashrc_erdc" >> ~/.env/dotfiles/bashrc
  fi
  printf "Symlinking new settings...\n\n"
  ln -s ~/.env/dotfiles/vimrc ~/.vimrc
  ln -s ~/.env/dotfiles/bashrc ~/.bashrc
  ln -s ~/.env/dotfiles/bash_profile ~/.bash_profile
  ln -s ~/.env/dotfiles/gitconfig ~/.gitconfig
  ln -s ~/.env/dotfiles/inputrc ~/.inputrc
  ln -s ~/.env/dotfiles/vim ~/.vim

  # Tilix is only usable on Ubuntu
  if [[ $PLATFORM = 'Ubuntu 16.04' ]] || [[ $PLATFORM = 'Ubuntu 18.04' ]]; then
    mkdir -p ~/.config/tilix
    ln -s ~/.env/themes/tilix_themes ~/.config/tilix/schemes
  fi
}
# }}}
# FUNCTION - INITIALIZE SUBMODULES {{{
function init_submodules() {
  printf "Initializing submodules...\n"
  cd ~/.env
  git submodule init
  git submodule update
  printf "\n"
}
# }}}
# FUNCTION - INSTALL VIM {{{
function install_vim() {
  read -p 'Would you like to install Vim? (y/n) ' -n1 answer
  printf "\n\n"
  if [[ $answer = [yY] ]]; then
    if [[ $PLATFORM = 'MacOS' ]]; then
      printf "Installing Vim..."
      printf "\n"
      brew install vim
      printf "\n"
    else
      printf "Installing Vim..."
      printf "\n"
      sudo apt-get install -y vim
      printf "\n"
    fi
    printf "Initializing vim plugins..."
    printf "\n\n"
    vim +PlugUpgrade +PlugUpdate +qall
    install_ag
  fi
}
# }}}
# FUNCTION - INSTALL AG {{{
function install_ag() {
  # INSTALL AG THE SILVER SEACHER
  printf "Ag the Silver Searcher is required for Vim CTRL-P Plugin.\n"
  read -p 'Would you like to install ag? (y/n) ' -n1 answer
  printf "\n\n"
  if [[ $answer = [yY] ]]; then
    if [[ $PLATFORM = 'MacOS' ]]; then
      printf "Installing ag..."
      printf "\n"
      brew install the_silver_searcher
      printf "\n"
    else
      printf "Installing ag..."
      printf "\n"
      sudo apt-get install -y silversearcher-ag
      printf "\n"
    fi
  fi
}
# }}}
# FUNCTION - INSTALL TILIX {{{
function install_tilix() {
  if [[ $PLATFORM = 'Ubuntu 16.04' ]] || [[ $PLATFORM = 'Ubuntu 18.04' ]]; then
    read -p 'Would you like to install Tilix? (y/n) ' -n1 answer
    printf "\n\n"
    if [[ $answer = [yY] ]]; then
      if [[ $PLATFORM = 'Ubuntu 16.04' ]]; then
        sudo add-apt-repository -y ppa:webupd8team/terminix
        sudo apt-get update
        sudo apt-get install -y tilix
        printf "\n"
      elif [[ $PLATFORM = 'Ubuntu 18.04' ]]; then
        printf "Installing Tilix..."
        printf "\n"
        sudo apt-get install -y tilix
        printf "\n"
      fi
      printf "###################################################################"
      printf "\n"
      printf "Enable preferred color scheme under Preferences -> Default -> Color"
      printf "\n"
      printf "###################################################################"
      printf "\n\n"
    fi
  fi
}
# }}}
# FUNCTION - RUN {{{
function run() {
  # RUN ALL FUNCTIONS
  printf "\n"
  printf "==================================================================="
  printf "\n\n"
  printf "Beginning environment setup."
  printf "\n\n"
  determine_os
  clear_settings
  create_settings
  init_submodules
  install_vim
  install_tilix
  printf "Environment setup complete."
  printf "\n\n"
  printf "==================================================================="
  printf "\n\n"
}
# }}}

# RUN SETUP
run

# ensures that vim uses fold markers and is folded by default
# vim:foldmethod=marker:foldlevel=0
