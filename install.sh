#!/bin/sh

link_tmux_dotfile () {
  if ! [ -e $HOME/.tmux.conf ]
  then
    ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
    echo '       linked'
  else
    echo '       already exists. skipping...'
  fi
}

install_reattach_to_user_namespace () {
  if [ `command -v brew | wc -l` -eq 1 ]
  then
    if [ `brew list | grep 'reattach-to-user-namespace' | wc -l` -eq 0 ]
    then
      brew install reattach-to-user-namespace
      echo '       installed'
    else
      echo '       already installed. skipping...'
    fi
  else
    echo '[tmux] brew is not installed.'
    echo '       install brew and re-run this script.'
  fi
}

prepare_tmux () {
  echo '\n[tmux] started'
  if [ `command -v tmux | wc -l` -eq 1 ]
  then
    echo '[tmux] linking .tmux.conf'
    link_tmux_dotfile
    echo '[tmux] installing reattach-to-user-namespace (for copy/paste support)'
    install_reattach_to_user_namespace
  else
    echo '[tmux] tmux is not installed.'
    echo '       install tmux and re-run this script.'
  fi
  echo '[tmux] finished'
}

echo '******* Installation started *******'
prepare_tmux
echo '\n******* Installation complete *******'
