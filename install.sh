#!/bin/sh

ESC_SEQ='\x1B'
RESET="${ESC_SEQ}[0m"
GREEN="${ESC_SEQ}[0;32m"
YELLOW="${ESC_SEQ}[0;33m"
RED="${ESC_SEQ}[0;31m"

print_message () {
  tag="[${CURRENT_PROG}]"
  let length=${#tag}+1
  if [ "$2" != "" ]
  then
    echo "${tag} ${1}"
  else
    ch=' '
    printf '%*s' "$length" | tr ' ' "$ch"
    echo $1
  fi
}

dotfile_exists () {
  test -e $HOME/.$1
}

command_exists () {
  if [ `command -v $1 | wc -l` -eq 1 ]
  then
    return 0
  else
    return 1
  fi
}

link_dotfile () {
  print_message "linking .$1" true
  if dotfile_exists $1
  then
    print_message "${GREEN}already exists. skipping...${RESET}"
  else
    ln -s $HOME/dotfiles/$1 $HOME/.$1
    print_message "${GREEN}linked!${RESET}"
  fi
}

install_with_brew () {
  if command_exists $1
  then
    print_message "${GREEN}already installed. skipping...${RESET}"
    return 0
  else
    if command_exists brew
    then
      brew install $1 && print_message "${GREEN}installed!${RESET}"
      return $?
    else
      print_message "${RED}brew is not installed. install brew and re-run this script.${RESET}"
      return 0
    fi
  fi
}

install_reattach_to_user_namespace () {
  print_message 'installing reattach-to-user-namespace (for copy/paste support)' true
  install_with_brew reattach-to-user-namespace
}

install_git () {
  print_message 'checking for git' true
  if command_exists git
  then
    print_message "${GREEN}already installed.${RESET}"
    return 0
  else
    print_message "${RED}git is not installed. install git and re-run this script.${RESET}"
    return 1
  fi
}

install_tmux () {
  print_message 'installing tmux' true
  install_with_brew tmux
  return $?
}

prepare_tmux () {
  CURRENT_PROG=tmux
  echo ''
  print_message 'started' true
  if install_tmux; then
    link_dotfile tmux.conf
    install_reattach_to_user_namespace
  fi
  print_message 'finished' true
}

prepare_git () {
  CURRENT_PROG=git
  echo ''
  print_message 'started' true
  if install_git; then
    link_dotfile gitconfig
  fi
  print_message 'finished' true
}

echo '******* Installation started *******'
prepare_tmux
prepare_git
echo '\n******* Installation complete *******'
