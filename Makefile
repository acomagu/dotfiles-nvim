XDG_CONFIG_HOME ?= $(HOME)/.config

.PHONY: install
install:
	mkdir -p $(XDG_CONFIG_HOME)/nvim
	ln -s $(CURDIR)/init.vim $(XDG_CONFIG_HOME)/nvim/init.vim
	ln -s $(CURDIR)/colors $(XDG_CONFIG_HOME)/nvim/colors
