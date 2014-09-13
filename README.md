dotfiles
=========

This repo contains dot files/folders for commonly used programs. By executing `run.sh`, all dot files/folders will be linked to from the home directory and all necessary commands will be run. Re-running it will keep everything up-to-date.

Supported Programs
--------------

* ack
* gem
* git
* tmux
* vim
* zsh

Usage
--------------

##### Install Homebrew

* If you haven't already, install [Homebrew](http://brew.sh).

##### Clone the repo

```sh
git clone git@github.com:solidcell/dotfiles.git ~/dotfiles
```

##### Execute the script

```sh
sh ~/dotfiles/run.sh
```

##### Re-execute the script

To keep up-to-date, re-execute the script:
```sh
sh ~/dotfiles/run.sh
```

To Do
--------------
* add a post-deploy notes section that mentions stuff like vim needing to have the pathogen command run
* see if it's possible to remove the zshrc and vimrc and point directly to the real ones (or leave it?)
