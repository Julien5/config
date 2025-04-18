(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
			   '((c-mode c++-mode)
                 . ("clangd"
                    "-j=2"
                    "--log=error"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--pch-storage=disk"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"
					"--compile-commands-dir=/tmp/builds/build"
					)))
  )
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'before-save-hook 'jbo/clang-format-buffer)

;; example to overwrite the logic:
;; (setq jbo-compilation-command "make")
(defun jbo-make-command ()
  (if (and (boundp 'jbo-compilation-command) jbo-compilation-command)
	  jbo-compilation-command
	;; if SETUPROOT/make exists, run SETUPROOT/make/mk -r (good for job)
	;; otherwise run make -C /tmp/build_pc (good for compteur cmake project)
	(if (file-directory-p (expand-file-name (format "%s/make" (getenv "SETUPROOT"))))
		(expand-file-name (format "%s/make/mk -r" (getenv "SETUPROOT")))
	  "make -C /tmp/build_pc"
	  )
	))

(defun jbo-make-c++-mode ()
  (let ((make-command (jbo-make-command)))
	(message "make-command:%s" make-command)
	(compile make-command)
	)
  )
