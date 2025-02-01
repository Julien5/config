(with-eval-after-load 'eglot
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
  ;; CARGO_HOME="/opt/rust/cargo"
  (setenv "CARGO_HOME" "/opt/rust/cargo")
  ;; RUSTUP_HOME="/opt/rust/rustup"
  (setenv "RUSTUP_HOME" "/opt/rust/rustup")
  ;; PATH="/opt/rust/cargo/bin:/home/julien/projects/config/scripts:/usr/local/bin:/usr/bin"
  (setenv "PATH"
		  (concat
		   "/opt/rust/cargo/bin" ":"
		   "/home/julien/projects/config/scripts" ":"
		   "/usr/local/bin" ":"
		   "/usr/bin"
		   ))
  )

(jbo-dev-rust)
