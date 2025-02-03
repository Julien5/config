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
(load "jbo-elisp")
(load "jbo-rust")


(custom-set-faces '(ediff-current-diff-A ((t (:foreground "White" :background "Blue")))))
(custom-set-faces '(ediff-current-diff-B ((t (:foreground "White" :background "Blue")))))
(custom-set-faces '(ediff-odd-diff-A ((t (:foreground "White" :background "Darkslategray")))))
(custom-set-faces '(ediff-odd-diff-B ((t (:foreground "White" :background "Darkslategray")))))
(custom-set-faces '(ediff-even-diff-A ((t (:foreground "White" :background "Darkslategray")))))
(custom-set-faces '(ediff-even-diff-B ((t (:foreground "White" :background "Darkslategray")))))
(custom-set-faces '(ediff-fine-diff-A ((t (:foreground "White" :background "Dimgray")))))
(custom-set-faces '(ediff-fine-diff-B ((t (:foreground "White" :background "Dimgray")))))


