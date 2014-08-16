#!/bin/sh

ESC_SEQ='\x1B'
RESET="${ESC_SEQ}[0m"
GREEN="${ESC_SEQ}[0;32m"
YELLOW="${ESC_SEQ}[0;33m"
RED="${ESC_SEQ}[0;31m"

tmux_dotfile_exists () {
  test -e $HOME/.tmux.conf
}

command_exists () {
  if [ `command -v $1 | wc -l` -eq 1 ]
  then
    return 0
  else
    return 1
  fi
}

brew_command_exists () {
  command_exists brew
}

reattach_to_user_namespace_command_exists () {
  command_exists reattach-to-user-namespace
}

link_tmux_dotfile () {
  echo '[tmux] linking .tmux.conf'
  if ! tmux_dotfile_exists
  then
    ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
    echo "       ${GREEN}linked!${RESET}"
  else
    echo "       ${YELLOW}already exists. skipping...${RESET}"
  fi
}

install_reattach_to_user_namespace () {
  echo '[tmux] installing reattach-to-user-namespace (for copy/paste support)'
  if brew_command_exists
  then
    if reattach_to_user_namespace_command_exists
    then
      echo "       ${YELLOW}already installed. skipping...${RESET}"
    else
      brew install reattach-to-user-namespace
      echo "       ${GREEN}installed!${RESET}"
    fi
  else
    echo "       ${RED}brew is not installed. install brew and re-run this script.${RESET}"
  fi
}

prepare_tmux () {
  echo '\n[tmux] started'
  if [ `command -v tmux | wc -l` -eq 1 ]
  then
    link_tmux_dotfile
    install_reattach_to_user_namespace
  else
    echo "       ${RED}tmux is not installed. install tmux and re-run this script.${RESET}"
  fi
  echo '[tmux] finished'
}

echo '******* Installation started *******'
prepare_tmux
echo '\n******* Installation complete *******'
