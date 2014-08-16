#!/bin/sh

ESC_SEQ='\x1B'
RESET="${ESC_SEQ}[0m"
GREEN="${ESC_SEQ}[0;32m"
YELLOW="${ESC_SEQ}[0;33m"
RED="${ESC_SEQ}[0;31m"

dotfile_exists () {
  echo "[FIXME] linking .$1"
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

link_tmux_dotfile () {
  echo '[tmux] linking .tmux.conf'
  if dotfile_exists tmux.conf
  then
    echo "       ${GREEN}already exists. skipping...${RESET}"
  else
    ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
    echo "       ${GREEN}linked!${RESET}"
  fi
}

link_gitconfig_dotfile () {
  echo '[git] linking .gitconfig'
  if dotfile_exists gitconfig
  then
    echo "       ${GREEN}already exists. skipping...${RESET}"
  else
    ln -s $HOME/dotfiles/gitconfig $HOME/.gitconfig
    echo "       ${GREEN}linked!${RESET}"
  fi
}

install_with_brew () {
  if command_exists $1
  then
    echo "       ${GREEN}already installed. skipping...${RESET}"
    return 0
  else
    if command_exists brew
    then
      brew install $1 && echo "       ${GREEN}installed!${RESET}"
      return $?
    else
      echo "       ${RED}brew is not installed. install brew and re-run this script.${RESET}"
      return 0
    fi
  fi
}

install_reattach_to_user_namespace () {
  echo '[tmux] installing reattach-to-user-namespace (for copy/paste support)'
  install_with_brew reattach-to-user-namespace
}

install_git () {
  echo '[git] checking for git'
  if command_exists git
  then
    echo "      ${GREEN}already installed.${RESET}"
    return 0
  else
    echo "      ${RED}git is not installed. install git and re-run this script.${RESET}"
    return 1
  fi
}

install_tmux () {
  echo '[tmux] installing tmux'
  install_with_brew tmux
  return $?
}

prepare_tmux () {
  echo '\n[tmux] started'
  if install_tmux; then
    link_tmux_dotfile
    install_reattach_to_user_namespace
  fi
  echo '[tmux] finished'
}

prepare_git () {
  echo '\n[git] started'
  if install_git; then
    link_gitconfig_dotfile
  fi
  echo '[git] finished'
}

echo '******* Installation started *******'
prepare_tmux
prepare_git
echo '\n******* Installation complete *******'
