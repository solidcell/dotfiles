#!/bin/sh

ESC_SEQ='\x1B'
RESET="${ESC_SEQ}[0m"
GREEN="${ESC_SEQ}[0;32m"
YELLOW="${ESC_SEQ}[0;33m"
RED="${ESC_SEQ}[0;31m"
BLUE="${ESC_SEQ}[0;34m"

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
    print_message "${GREEN}already linked. skipping...${RESET}"
  else
    ln -s $HOME/dotfiles/$1 $HOME/.$1
    print_message "${GREEN}linked!${RESET}"
  fi
}

install_with_brew () {
  print_message "installing $1" true
  if brew list | grep -E "\<$1\>([^-]|$)" > /dev/null
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

install_with_npm () {
  print_message "installing $1" true
  if npm --global list | grep -E "\<$1\>([^-]|$)" > /dev/null
  then
    print_message "${GREEN}already installed. skipping...${RESET}"
    return 0
  else
    if command_exists npm
    then
      npm install -g $1 && print_message "${GREEN}installed!${RESET}"
      return $?
    else
      print_message "${RED}npm is not installed. install npm and re-run this script.${RESET}"
      return 0
    fi
  fi
}

install_with_gem () {
  print_message "installing $1" true
  if gem list | grep -E "\<$1\>([^-]|$)" > /dev/null
  then
    print_message "${GREEN}already installed. skipping...${RESET}"
    return 0
  else
    if command_exists gem
    then
      if [ -z "$2" ]; then command="$1"; else command="$2"; fi
      gem install $command && print_message "${GREEN}installed!${RESET}"
      return $?
    else
      print_message "${RED}gem is not installed. install gem and re-run this script.${RESET}"
      return 0
    fi
  fi
}

set_zsh_as_default_shell () {
  print_message 'setting zsh as the default shell' true
  if [ "$SHELL" == "/bin/zsh" ]
  then
    print_message "${GREEN}already set. skipping...${RESET}"
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
    print_message "${GREEN}ok${RESET}"
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

prepare_tmuxinator () {
  CURRENT_PROG=tmuxinator
  echo ''
  print_message 'started' true
  if install_with_gem tmuxinator; then
    link_dotfile tmuxinator
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
      link_dotfile zshenv
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

install_ruby () {
  print_message "installing ruby $1" true
  if [ `rbenv versions | grep $1 | wc -l` -eq 1 ]; then
    print_message "${GREEN}already installed. skipping...${RESET}"
  else
    rbenv install --skip-existing $1
  fi
}

prepare_ruby () {
  CURRENT_PROG=ruby
  echo ''
  print_message 'started' true
  install_ruby $(cat $HOME/dotfiles/rbenv/version)
  link_dotfile rbenv/version
  print_message 'finished' true
}

prepare_coffeescript () {
  CURRENT_PROG=coffee-script
  echo ''
  print_message 'started' true
  install_with_npm coffee-script
  print_message 'finished' true
}

prepare_ctags () {
  CURRENT_PROG=ctags
  echo ''
  print_message 'started' true
  install_with_brew ctags
  link_dotfile ctags
  print_message 'finished' true
}

create_pianobar_fifo () {
  print_message "creating pianobar FIFO" true
  if [ ! -e $HOME/.config/pianobar/ctl ]; then
    mkfifo $HOME/.config/pianobar/ctl > /dev/null && print_message "${GREEN}created!${RESET}"
  else
    print_message "${GREEN}already created. skipping...${RESET}"
  fi
}

prepare_pianobar () {
  CURRENT_PROG=pianobar
  echo ''
  print_message 'started' true
  install_with_brew pianobar
  mkdir -p $HOME/.config/pianobar
  link_dotfile config/pianobar/config
  link_dotfile config/pianobar/event_command.rb
  link_dotfile config/pianobar/echo-current-song.sh
  save_pandora_password
  create_pianobar_fifo
  print_message 'finished' true
}

prepare_rbenv () {
  CURRENT_PROG=rbenv
  echo ''
  print_message 'started' true
  install_with_brew rbenv
  install_with_brew ruby-build
  install_with_brew rbenv-default-gems
  link_dotfile rbenv/default-gems
  install_with_brew rbenv-gem-rehash
  print_message 'finished' true
}

prepare_the_silver_searcher () {
  CURRENT_PROG=ag
  echo ''
  print_message 'started' true
  install_with_brew the_silver_searcher
  link_dotfile agignore
  print_message 'finished' true
}

prepare_gpg () {
  CURRENT_PROG=gpg
  echo ''
  print_message 'started' true
  install_with_brew gnupg
  generate_gpg_key
  print_message 'finished' true
}

generate_gpg_key () {
  print_message "generating GPG key" true
  if [ ! -f ~/.gnupg/pubring.gpg ]; then
    gpg --batch --gen-key $HOME/dotfiles/gpg-key-script && print_message "${GREEN}generated!${RESET}"
  else
    print_message "${GREEN}already generated. skipping...${RESET}"
  fi
}

save_pandora_password () {
  print_message "encrypting Pandora.com password" true
  if [ ! -f $HOME/.config/pianobar/password.gpg ]; then
    echo 'Pandora.com password:'
    read -s pandora_password
    echo $pandora_password | gpg --output $HOME/.config/pianobar/password.gpg --encrypt --recipient solidcell@gmail.com
    print_message "${GREEN}encrypted!${RESET}"
  else
    print_message "${GREEN}already encrypted. skipping...${RESET}"
  fi
}

post_run_messages () {
  CURRENT_PROG=
  echo ''
  print_message "- ${GREEN}open up a new terminal to be sure to have any changes${RESET}"
  print_message "- ${GREEN}in vim, run this once: ${BLUE}:call pathogen#helptags()${RESET}"
}

echo '******* Installation started *******'
checkout_submodules
prepare_rbenv
prepare_ruby
prepare_gem
prepare_vim
prepare_ctags
prepare_zsh
prepare_tmux
prepare_tmuxinator
prepare_git
prepare_ack
prepare_node
prepare_coffeescript
prepare_gpg
prepare_pianobar
prepare_the_silver_searcher
post_run_messages
echo '\n******* Installation complete *******'
