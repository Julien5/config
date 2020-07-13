(defun find-references ()
  (interactive)
  (save-excursion
    (let* ((word (thing-at-point 'word' 'no-properties)))
      (message "find-references %s" word)
      (setq result (xref-find-references word))
      (message "%s" result)
      )))

;;(switch-to-buffer "foo")
;;(jump-to-file-at-point)
