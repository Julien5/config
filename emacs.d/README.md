# Notes

## Local Variables

There are file-local and directory-local variables variables. Emacs reloads theses variables with the command `revert-buffer`.

### File Local Variables

There are file-local and directory-local variables variables.
The file-local variables are defined per magic string in the file, either
at the *beginning*:
```
#!/usr/bin/env python3
# -*- var1: "python3 readtracks.py"; -*-
```

or at the *end* of the file:
```
# Local Variables:  
# compile-command: "python3 readtracks.py"
# End:
[EOF]
```
See [here](https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html).

### Directory Local Variables

The directy-local variables are defined per magic string in the file `.dir-locals.el`:
```
$ cat src/.dir-locals.el 
(
 (python-mode . (
				 (vard . "python3 main.py")
				 )
			  )
 )
```

See [here](https://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html).

