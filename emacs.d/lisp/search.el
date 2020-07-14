(defun find-references ()
  (interactive)
  (save-excursion
    (let* ((word (symbol-at-point)))
	  (message "find-references %s" word)
	  (if word
		  (let ((w (format "%s" word)))
			(xref-find-references w)
			)
		(message "no symbol at cursor")
		))))

(defun refactor-references ()
  (interactive)
  (save-excursion
	(message "test")
	(if (not (equal (buffer-name) "*xref*"))
		(find-references)
	  nil)
	(message "current buffer %s" (current-buffer))
	(let* ((fromsymbol (symbol-at-point)))
	  (message "refactor-references %s" fromsymbol)
	  (let* ((from (format "%s" fromsymbol)))
		(setq to (read-string "new name:" from))
		(message "from %s to %s" from to)
		(switch-to-buffer "*xref*")
		(xref-query-replace-in-results ".*" to)
		)
	  )))

;;(switch-to-buffer "main_devhost.cpp")
;;(refactor-references)
;;(switch-to-buffer "search.el")
