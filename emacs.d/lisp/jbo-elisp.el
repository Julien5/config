(defun jbo-run-elisp ()
  (message "evaluating %s" (buffer-file-name (current-buffer)))
  (eval-buffer (current-buffer))
  )

