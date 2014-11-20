#!/bin/zsh

if [ -z `ps aux | grep 'pianobar$'` ]; then
  echo ''
else
  cat ~/.config/pianobar/current-song.txt
fi
