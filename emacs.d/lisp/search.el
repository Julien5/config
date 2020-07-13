(defun find-references ()
  (interactive)
  (save-excursion
    (let* ((word (symbol-at-point)))
	  ;;(message "find-references %s" word)
	  (let ((w (format "%s" word)))
		(xref-find-references w)
		)
      )))

;;(switch-to-buffer "foo")
;;(jump-to-file-at-point)
