;; f5 does jbo/make, and the dispatch is there.
;; (eval-after-load 'sh-script  '(define-key sh-mode-map [f5] 'jbo/execute-buffer))


(defun jbo-make-shell-mode ()
  (message "shell mode")
  (let ((filename (buffer-file-name (window-buffer (minibuffer-selected-window)))))
	(executable-interpret filename)
	)
  )
