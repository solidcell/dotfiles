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
  print_message "installing $1" true
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

set_zsh_as_default_shell () {
  print_message 'setting zsh as the default shell' true
  if [ "$SHELL" == "/bin/zsh" ]
  then
    print_message "${GREEN}already set.${RESET}"
  else
    chsh -s /bin/zsh
    print_message "${GREEN}set.${RESET}"
  fi
}

# for when the the program is the focus of the current operation
check_installed () {
  print_message "checking for $1" true
  if ensure_installed $1
  then
    print_message "${GREEN}already installed.${RESET}"
    return 0
  else
    return 1
  fi
}

# for when the the program is required, but should not be mentioned unless necessary
ensure_installed () {
  if command_exists $1
  then
    return 0
  else
    print_message "${RED}$1 is not installed. install $1 and re-run this script.${RESET}"
    return 1
  fi
}

prepare_tmux () {
  CURRENT_PROG=tmux
  echo ''
  print_message 'started' true
  if install_with_brew tmux; then
    link_dotfile tmux.conf
    install_with_brew reattach-to-user-namespace
  fi
  print_message 'finished' true
}

prepare_git () {
  CURRENT_PROG=git
  echo ''
  print_message 'started' true
  if check_installed git; then
    link_dotfile gitconfig
    link_dotfile gitignore_global
  fi
  print_message 'finished' true
}

prepare_ack () {
  CURRENT_PROG=ack
  echo ''
  print_message 'started' true
  if check_installed ack; then
    link_dotfile ackrc
  fi
  print_message 'finished' true
}

prepare_gem () {
  CURRENT_PROG=gem
  echo ''
  print_message 'started' true
  if check_installed gem; then
    link_dotfile gemrc
  fi
  print_message 'finished' true
}

checkout_submodules () {
  CURRENT_PROG=submodules
  echo ''
  print_message 'checking out/updating all submodules' true
  if ensure_installed git; then
    (cd $HOME/dotfiles && git submodule update --init)
    (cd $HOME/dotfiles/vim && git submodule update --init)
  fi
  print_message 'finished' true
}

prepare_vim () {
  CURRENT_PROG=vim
  echo ''
  print_message 'started' true
  if ensure_installed git; then
    if check_installed vim; then
      link_dotfile vimrc
      link_dotfile vim
    fi
  fi
  print_message 'finished' true
}

prepare_zsh () {
  CURRENT_PROG=zsh
  echo ''
  print_message 'started' true
  if ensure_installed git; then
    if check_installed zsh; then
      link_dotfile zshrc
      link_dotfile zsh
      set_zsh_as_default_shell
    fi
  fi
  print_message 'finished' true
}

prepare_node () {
  CURRENT_PROG=node
  echo ''
  print_message 'started' true
  install_with_brew node
  print_message 'finished' true
}

echo '******* Installation started *******'
checkout_submodules
prepare_vim
prepare_zsh
prepare_tmux
prepare_git
prepare_ack
prepare_gem
prepare_node
echo '\n******* Installation complete *******'
