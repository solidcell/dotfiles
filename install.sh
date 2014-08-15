echo '******* Installation started *******'

##### Install tmux ######
echo '[tmux] linking .tmux.conf'
if ! [ -e $HOME/.tmux.conf ]; then
  ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
fi
echo '[tmux] installing reattach-to-user-namespace (for copy/paste support)'
if [ `brew list | grep 'reattach-to-user-namespace' | wc -l` -eq 0 ]; then
  brew install reattach-to-user-namespace
fi

echo '******* Installation complete *******'
