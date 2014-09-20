dotfiles
=========

This repo contains dot files/folders for commonly used programs. By executing `run.sh`, all dot files/folders will be linked to from the home directory and all necessary commands will be run. Re-running it will keep everything up-to-date.

Supported Programs
--------------

* ack
* coffee
* ctags
* gem
* git
* node
* tmux
* vim
* zsh

Usage
--------------

##### Clone the repo

```sh
git -C ~ clone git@github.com:solidcell/dotfiles.git
```

##### Execute the script

```sh
sh ~/dotfiles/run.sh
```
You will be alerted to anything you may have to install manually, such as `git` and `brew`.

##### Re-execute the script

To keep up-to-date, re-execute the script:
```sh
git -C ~/dotfiles pull
sh ~/dotfiles/run.sh
```

To Do
--------------
* add a post-deploy notes section that mentions stuff like vim needing to have the pathogen command run
