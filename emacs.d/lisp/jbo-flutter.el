(load "flutter/dart-mode")

(defun jbo-dev-flutter ()
  (message "%s" "loading flutter environment")
  ;; TODO: run dev.rust script and fetch the variables
  (setenv "PATH"
		  (concat
		   "/opt/flutter/flutter/bin" ":"
		   "/home/julien/projects/config/scripts" ":"
		   "/usr/local/bin" ":"
		   "/usr/bin"
		   ))
  (add-to-list 'exec-path "/opt/flutter/flutter/bin")
  ;;(add-to-list 'eglot-server-programs '(dart-mode . ("dart" "language-server")))
  )

(defun jbo-make-flutter-mode ()
  (compile "dart run")
  )

(add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))
(add-hook 'dart-mode-hook (jbo-dev-flutter))
