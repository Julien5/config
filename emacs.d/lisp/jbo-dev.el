;; mostly eglot stuff
(customize-set-variable 'eglot-autoshutdown t)
(customize-set-variable 'eglot-extend-to-xref t)
;; windows emacs shows the function parameter names as inlay
;; this is disturbing.
(setq eglot-ignored-server-capabilities '(:inlayHintProvider))
(load "jbo-c++")
(load "jbo-python")
(load "jbo-shell")
(load "jbo-cmake")

