(defun jbo-lsp-python-init () 
  (with-eval-after-load 'eglot
	(add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp"))))
  (add-hook 'python-mode-hook 'eglot-ensure)
  )

(jbo-lsp-python-init)

