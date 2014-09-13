dotfiles
=========

This repo contains dot files/folders for commonly used programs. By running `install.sh`, all dot files/folders will be linked to from the home directory and all necessary commands will be run. Re-running it will keep everything up-to-date.

Supported Programs
--------------

* ack
* gem
* git
* tmux
* vim
* zsh

Installation
--------------

##### Install Homebrew

* If you haven't already, install [Homebrew](http://brew.sh).

##### Run the installation script

```sh
cd ~
git clone git@github.com:solidcell/dotfiles.git
sh dotfiles/install.sh
```

To Do
--------------
* add a post-deploy notes section that mentions stuff like vim needing to have the pathogen command run
* see if it's possible to remove the zshrc and vimrc and point directly to the real ones (or leave it?)
