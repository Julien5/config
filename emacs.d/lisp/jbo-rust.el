(defun jbo-make-rust-mode ()
  ;; (rust-compile)
  (rust-check)
  )

(defun jbo-dev-rust ()
  (message "%s" "loading rust environment")
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
  (add-to-list 'exec-path "/opt/rust/cargo/bin")
  (define-key rust-mode-map (kbd "<f2>") 'eglot-rename)
  (define-key rust-mode-map (kbd "<f8>") 'eglot-code-actions)

  ;; this is usefull for eglot to find the project root
  ;; in rust
  (message "calling fix project roots")
  (jbo-fix-project-roots)
  (setq rust-format-on-save t)
  )

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
			   '(rust-mode .
				 ("/opt/rust/cargo/bin/rust-analyzer" ))
			   )
  )

(add-hook 'rust-mode-hook 'jbo-dev-rust)
(message "jbo-rust loaded")
