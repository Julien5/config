(defun jbo-lsp-c++-init () 
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
				 '((c-mode c++-mode)
                   . ("clangd"
                      "-j=2"
                      "--log=error"
                      "--background-index"
                      "--clang-tidy"
                      "--cross-file-rename"
                      "--completion-style=detailed"
                      "--pch-storage=memory"
                      "--header-insertion=never"
                      "--header-insertion-decorators=0")))
	(add-hook 'c-mode-hook 'eglot-ensure)
	(add-hook 'c++-mode-hook 'eglot-ensure)
	)
  )

(jbo-lsp-c++-init)
