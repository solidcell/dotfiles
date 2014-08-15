echo '******* Installation started *******'

##### Install tmux ######
echo '\n[tmux] started'
echo '[tmux] linking .tmux.conf'
if ! [ -e $HOME/.tmux.conf ]
  then
    ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
    echo '       linked'
  else
    echo '       already exists. skipping...'
fi
echo '[tmux] installing reattach-to-user-namespace (for copy/paste support)'
  if [ `brew list | grep 'reattach-to-user-namespace' | wc -l` -eq 0 ]
  then
    brew install reattach-to-user-namespace
    echo '       installed'
  else
    echo '       already installed. skipping...'
fi
echo '[tmux] finished'

echo '\n******* Installation complete *******'
