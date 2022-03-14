(defun remember-old-name (w)
  (setq jbo-oldname (format "%s" w))
  (setq jbo-newname nil)
  jbo-oldname
  )

(defun get-identifier-to-search ()
  (setq jbo--region nil)
  (if (use-region-p)
	  (setq jbo--region (buffer-substring-no-properties (region-beginning) (region-end)))
	)
  (setq jbo--atpoint (format "%s" (symbol-at-point)))
  (if (use-region-p)
	  jbo--region
	jbo--atpoint)
  )  

(defun ag-at-point ()
  (let* ((word (get-identifier-to-search))
		 (jbo-dir (file-name-directory (car (jbo-projectiles)))))
	(message "find-references %s in %s" word jbo-dir)
	(remember-old-name word)
	(if word
		(let ((w jbo-oldname))
		  ;; (xref-find-references w)
		  (require 'ag)
		  ;; note: use .agignore to ignore files.
		  ;; setup: ~/work/projects/.gitignore ~/.agignore
		  (ag/search w jbo-dir :file-regex ".cpp$|.c$|.h$|.sh$|.py$|.pro$|.el$")
		  )
	  (message "no symbol at cursor")
	  )
	)
  )

(defun find-definition-at-point ()
  (let* ((word (symbol-at-point)))
	(remember-old-name word)
	(message "find-definitions for %s" word)
	(if word
		(let ((w (format "%s" word)))
		  (xref-find-definitions w)
		  )
	  (message "no symbol at cursor")
	  ))
  )

(defun jbo/find-references ()
  (interactive)
  (ag-at-point)
  )

(defun jbo/find-definitions ()
  (interactive)
  (if (bound-and-true-p lsp-mode)
	  (progn
		(message "running lsp-find-definition")
		(lsp-find-definition)
		)
	(find-definition-at-point))
  )

;; does not work with lsp :-(
(defun jbo/refactor-references--disabled ()
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

(defun jbo/find-references-xref()
  (interactive)
  (remember-old-name (xref--read-identifier "identifier:"))
  (message "looking for %s" jbo-oldname)
  ;;(call-interactively 'xref-find-references)
  (xref-find-references jbo-oldname)
  )

(defun jbo/replace-in-line ()
  (interactive)
  ;;(next-error)
  (if (not jbo-newname)
	  (setq jbo-newname (read-string "new name:" jbo-oldname))
	)
  (message "[%s] -> [%s]" jbo-oldname jbo-newname)
  (query-replace jbo-oldname jbo-newname nil (line-beginning-position) (line-end-position) nil nil)
  )


;;(switch-to-buffer "main_devhost.cpp")
;;(refactor-references)
;;(switch-to-buffer "search.el")
