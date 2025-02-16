(with-eval-after-load 'eglot
  (jbo-dev-rust)
  (add-to-list 'eglot-server-programs
			   '((rust-mode rust-ts-mode)  .
				 ("/opt/rust/analyzer/bin/rust-analyzer" ))
			   )
  )

(add-hook 'rust-ts-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)

(defun jbo-make-rust-mode ()
  (message "TODO")
  )

(defun jbo-dev-rust ()
  ;; TODO: run dev.rust script and fetch the variables
  (setenv "CARGO_HOME" "/opt/rust/cargo")
  (setenv "RUSTUP_HOME" "/opt/rust/rustup")
  (setenv "CARGO_TARGET_DIR" (concat (getenv "HOME") "/delme/rust-targets"))
  (setenv "PATH"
		  (concat
		   "/opt/rust/cargo/bin" ":"
		   "/home/julien/projects/config/scripts" ":"
		   "/usr/local/bin" ":"
		   "/usr/bin"
		   ))
  )
