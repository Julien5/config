# INSTALL TOOLS

## Font

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
but could *not* fix it.

fix markdown:
```
(custom-set-faces
 '(markdown-pre-face ((t (:inherit (markdown-code-face font-lock-constant-face) :family "fixed")))))
```

At the moment, Tamzen (and other bitmap fonts i think) look nicer in the terminal than in the GTK emacs frontend. I start the terminal with `--maximize`, but sometimes emacs is not maximized.

Note:
VMWare has a keyboard lag problem. Fixes:
```
You could try Virtual Machine Settings > Processors > Virtualization engine > Virtualize  IOMMU.
It resolved my keyboard lag issue.
https://communities.vmware.com/t5/VMware-Workstation-Pro/VMware-Workstation-17-Pro-Linux-VMs-keyboard-lag/td-p/2965064
```
and
```
Hi thread,
I submitted a ticket to VMWare and they finally came up with a solution today, which seems to be working perfectly on my machine:
Add these to your .vmx:
keyboard.allowBothIRQs = "FALSE"
keyboard.vusb.enable = "TRUE"
And restart the VM. This works for me with VMware 17.5.0 and Kali rolling (KDE, Wayland).
https://communities.vmware.com/t5/VMware-Workstation-Pro/Noticeable-typing-lag-in-Linux-VM-terminals-since-v16-2-upgrade/td-p/2872427/page/6
```
It mitigates the problem.

### Source Code Pro 

1. Copy the .ttf files from https://github.com/google/fonts/tree/master/ofl/sourcecodepro into ~/.fonts/ (or any sub directory, like ~/.fonts/source-code-pro/) and 
2. run fc-cache -f ~/.fonts.

## Running in xfce4-terminal

`start-emacs.sh` contains:
```
xfce4-terminal --maximize --hide-menubar --hide-scrollbar --title=emacs -e "emacs -nw"
```
The `F10` shortcut collides with my key bindings. 
Solution: Edit > Preferences > Advanced > Disable menu shortkey (F10 by default)
**Note**: 
Version 0.9.2 should have better menu. I have version 0.8.9.1.

```
(gtk_accel_path "<Actions>/terminal-window/toggle-menubar" "<Alt>0")
```

## Python LSP

Install:
pylsp, pycodestyle, pyflakes and customize the code style.
```
# sudo pip3 install python-lsp-server

# cat pycodestyle 
[pycodestyle]
ignore = W,E

# ln -s ~/projects/config/emacs.d/pycodestyle ~/.config/pycodestyle
```
