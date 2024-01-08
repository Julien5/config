# INSTALL TOOLS

## Font

1. Copy the .ttf files from https://github.com/google/fonts/tree/master/ofl/sourcecodepro into ~/.fonts/ (or any sub directory, like ~/.fonts/source-code-pro/) and 
2. run fc-cache -f ~/.fonts.

## Python LSP

Install pylsp and customize the code style.
```
# sudo pip3 install python-lsp-server

# cat pycodestyle 
[pycodestyle]
ignore = W,E

# ln -s ~/projects/config/emacs.d/pycodestyle ~/.config/pycodestyle
```
