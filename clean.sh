#!/usr/bin/env bash
# A script to setup my environment settings.

function remove_backups() {
  printf "Removing backed-up configuration files.\n"
  cd ~
  rm .vimrc_*
  rm .bashrc_*
  rm .bash_profile_*
  rm .gitconfig_*
  rm .inputrc_*
  rm -rf .vim_*
  rm -rf .config/tilix_*
}

# RUN CLEAN
remove_backups

# ensures that vim uses fold markers and is folded by default
# vim:foldmethod=marker:foldlevel=0
