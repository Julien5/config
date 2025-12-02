(defun jbo-make-rust-mode ()
  (rust-compile)
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
  )

;;(with-eval-after-load 'eglot
;;  (add-to-list 'eglot-server-programs
;;			   '((rust-mode rust-ts-mode)  .
;;				 ("/opt/rust/analyzer/bin/rust-analyzer" ))
;;			   )
;;  )

;; Workaround for:
;; The version of the proc-macro server (6) in your Rust toolchain is newer
;; than the version supported by your rust-analyzer (5
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
			   '((rust-mode rust-ts-mode)  .
				 ("/opt/rust/rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer" ))
			   )
  )




(add-hook 'rust-mode-hook 'jbo-dev-rust)
;;(add-hook 'rust-mode-hook 'eglot-ensure)
(setq rust-format-on-save t)
