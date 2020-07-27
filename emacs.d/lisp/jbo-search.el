(defun jbo/find-references ()
  (interactive)
  (delete-other-windows)
  (save-excursion
    (let* ((word (symbol-at-point))
		   (jbo-dir (file-name-directory (car (jbo-projectiles)))))
	  (message "find-references %s in %s" word jbo-dir)
	  (if word
		  (let ((w (format "%s" word)))
			;; (xref-find-references w)
			(require 'ag)
			(ag/search w jbo-dir :file-regex ".cpp$")
			)
		(message "no symbol at cursor")
		)
	  ))
 )


(defun jbo/find-definitions ()
  (interactive)
  (delete-other-windows)
  (save-excursion
	(message "find-definitions...")
	;;(window-state-put jbo/xref-state jbo/bottom-window)
	(let* ((word (symbol-at-point)))
	  (message "find-definitions for %s" word)
	  (if word
		  (let ((w (format "%s" word)))
			(xref-find-definitions w)
			)
		(message "no symbol at cursor")
		))))


(defun jbo/refactor-references ()
  (interactive)
  (save-excursion
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

