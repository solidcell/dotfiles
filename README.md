dotfiles
=========

This repo contains dot files/folders for commonly used programs. By executing `run.sh`, all dot files/folders will be linked to from the home directory and all necessary commands will be run. Re-running it will keep everything up-to-date.

Supported Programs
--------------

* [ack](http://beyondgrep.com/)
* [ag](https://github.com/ggreer/the_silver_searcher)
* [coffee-script](http://coffeescript.org/)
* [ctags](http://ctags.sourceforge.net/)
* [gem](https://rubygems.org/)
* [git](http://git-scm.com/)
* [node](http://nodejs.org/)
* [pianobar](https://github.com/PromyLOPh/pianobar/)
* [rbenv](https://github.com/sstephenson/rbenv)
* [ruby](https://www.ruby-lang.org/)
* [tmux](http://tmux.sourceforge.net/)
* [tmuxinator](https://github.com/tmuxinator/tmuxinator)
* [vim](http://www.vim.org/)
* [zsh](http://www.zsh.org/)

Usage
--------------

##### Clone the repo

```sh
git -C ~ clone git@github.com:solidcell/dotfiles.git
```

##### Remove (OR BACKUP) any existing dotfiles you currently have

```sh
rm -fr ~/.ackrc ~/.agignore ~/.config/pianobar/config ~/.ctags ~/.gemrc \
       ~/.gitconfig ~/.gitignore_global ~/.tmux.conf ~/.vim/ \
       ~/.vimrc ~/.zsh/ ~/.zshenv ~/.zshrv
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

Notes
--------------

##### Local Tags

For existing git repos, re-init to get hooks which update tags:
```sh
git init
```
New repos will automatically get these hooks by default.

##### Gem Tags

For existing gems, run this once to get tags for all gems:
```sh
gem gem-ctags
```
Future gem installs will, however, automatically generate tags.
