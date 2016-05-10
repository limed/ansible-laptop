DOTFILES := $(shell pwd)

all: bash

bash:
	rsync -a --delete $(DOTFILES)/bash.d/ ${HOME}/.bash.d/
	rsync -a $(DOTFILES)/bashrc ${HOME}/.bashrc
	rsync -a $(DOTFILES)/bash_profile ${HOME}/.bash_profile
