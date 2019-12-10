#!/usr/bin/env bash
# A script to setup my environment settings.

function remove_backups() {
  printf "Removing backed-up configuration files."
  cd ~
  rm .vimrc_old_*
  rm .bashrc_old_*
  rm .bash_profile_old_*
  rm .gitconfig_old_*
  rm .inputrc_old_*
  rm .vim_old_*
  rm -rf ~/.config/tilix_old_*
}

# RUN CLEAN
remove_backups

# ensures that vim uses fold markers and is folded by default
# vim:foldmethod=marker:foldlevel=0
