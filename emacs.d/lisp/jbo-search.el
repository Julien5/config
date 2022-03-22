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
  (if (use-region-p)
	  jbo--region
	(format "%s" (symbol-at-point)))
  )  

(defun jbo/ag-at-point ()
  (interactive)
  (let* ((word (get-identifier-to-search))
		 (jbo-dir (file-name-directory (jbo-projectiles))))
	(message "find-references %s in %s" word jbo-dir)
	(if word
		(let ((w word))
		  (require 'ag)
		  (ag/search w jbo-dir :file-regex ".cpp$|.c$|.h$|.sh$|.py$|.pro$|.el|Jenkinsfile$")
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
  (if (bound-and-true-p lsp-mode)
	  (progn
		(lsp-find-references)
		)
	(jbo/ag-at-point))
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


;;(switch-to-buffer "main_devhost.cpp")
;;(refactor-references)
;;(switch-to-buffer "search.el")
