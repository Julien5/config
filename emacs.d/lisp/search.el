(defun jbo-call-find-references (w)
  (setq executable (format "%s/bash/%s" user-emacs-directory "find-references.sh"))
  (message "finding references for %s" w)
  (require 'ag)
  (ag-mode)
  (compilation-start (format "%s %s" executable (shell-quote-argument w))
					 'ag-mode
					 nil
					 nil)
  )

(defun jbo/find-references ()
  (interactive)
  (save-excursion
    (let* ((word (symbol-at-point)))
	  (message "find-references %s" word)
	  (select-window jbo/bottom-window)
	  (window-state-put jbo/refs-state jbo/bottom-window)
	  (read-only-mode 0)
	  ;;(erase-buffer)
	  (if word
		  (let ((w (format "%s" word)))
			(jbo-call-find-references w)
			(next-error-follow-minor-mode)
			)
		(message "no symbol at cursor"))
	  ))
  )

(defun jbo/find-definitions ()
  (interactive)
  (save-selected-window
	(save-excursion
	  (message "find-definitions...")
	  (window-state-put jbo/xref-state jbo/bottom-window)
	  (let* ((word (symbol-at-point)))
		(message "find-definitions for %s" word)
		(if word
			(let ((w (format "%s" word)))
			  (xref-find-definitions w)
			  )
		  (message "no symbol at cursor")
		  )))))

(defun jbo/refactor-references ()
  (interactive)
  (save-excursion
	(let* ((fromsymbol (symbol-at-point)))
	  (message "refactor-references %s" fromsymbol)
	  (let* ((from (format "%s" fromsymbol)))
		(setq to (read-string "new name:" from))
		(message "from %s to %s" from to)
		(tags-query-replace from to)
		)
	  )))

;;(switch-to-buffer "main_devhost.cpp")
;;(refactor-references)
;;(switch-to-buffer "search.el")

