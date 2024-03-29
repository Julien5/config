# INSTALL TOOLS

## Font

1. Copy the .ttf files from https://github.com/google/fonts/tree/master/ofl/sourcecodepro into ~/.fonts/ (or any sub directory, like ~/.fonts/source-code-pro/) and 
2. run fc-cache -f ~/.fonts.


### Bitmaps Fonts


Available [from here](https://files.ax86.net/terminus-ttf/#fontsizes) and [even better here](https://github.com/Tecate/bitmap-fonts/tree/master):
```
git clone https://github.com/Tecate/bitmap-fonts/
```

Use [this python script](https://ndim.fedorapeople.org/stuff/bitmapfonts2otb/bitmapfonts2otb.py) to convert font to a format supported by gtk (pango). Then:
```
mkdir -p ~/.fonts/bitmaps/; 
for a in $(find . -type f -name "*.bdf"); do 
	b=$(basename $a); 
	c=${b/bdf/otb};  
	python3 ~/Downloads/bitmapfonts2otb.py $a && mv -v *.otb ~/.fonts/bitmaps/$c; 
done
fc-cache -fv ~/.fonts/ 
fc-list | grep julien 
```
Note: i get often a error:
```
fonttosfnt -b -c -g 2 -m 2 -o Neep-Bold.otb ./bitmap/jmk-x11-fonts-3.0/neep-iso8859-1-10x20-bold.bdf
Couldn't select character map: 6.
```
but could not fix it.

fix markdown:
```
(custom-set-faces
 '(markdown-pre-face ((t (:inherit (markdown-code-face font-lock-constant-face) :family "fixed")))))
```


## Python LSP

Install pylsp and customize the code style.
```
# sudo pip3 install python-lsp-server

# cat pycodestyle 
[pycodestyle]
ignore = W,E

# ln -s ~/projects/config/emacs.d/pycodestyle ~/.config/pycodestyle
```
