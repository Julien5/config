;; -*- lexical-binding: t -*-

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
		  (ag/search w jbo-dir :file-regex ".cpp$|.c$|.h$|.sh$|.py$|.pro$|.el|Jenkinsfile$|[^.]*$")
		  )
	  (message "no symbol at cursor")
	  )
	)
  )

(defun jbo--find-definition-at-point ()
  (let* ((word (symbol-at-point)))
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
  (if (bound-and-true-p eglot--managed-mode)
	  (progn
		(message "running xref-find-references with eglot")
		(xref-find-references nil)
		)
	(progn
	  (message "running ag-at-point (no eglot)")
	  (jbo/ag-at-point)
	  )
	)
  )

(defun jbo/find-definitions ()
  (interactive)
  (if (bound-and-true-p eglot--managed-mode)
	  (progn
		(message "running xref-find-definition with eglot")
		(xref-find-definitions nil)
		)
	(jbo--find-definition-at-point))
  )

(defun jbo/projectile-ag ()
  (interactive)
  (setq jboword (read-string "ag: " (get-identifier-to-search)))
  (projectile-ag jboword)
  )
  ;;(switch-to-buffer "main_devhost.cpp")
  ;;(refactor-references)
  ;;(switch-to-buffer "search.el")


(defun file-affinity (f1 f2)
  (defun common (A B)
	(let ((a (car A))
		  (b (car B))
		  )
	  (if (and (string= a b) (and a b))
		  (+ (common (cdr A) (cdr B)) 1)
		0
		)
	  )
	)
  
  (let ((L1 (split-string (file-name-directory f1) "/"))
		(L2 (split-string (file-name-directory f2) "/"))
		)
	(let ((ret (common L1 L2)))
	  (message "f1=%s f2=%s distance=%d" f1 f2 ret)
	  ret
	  ))
  )

(eval-when-compile
  (require 'cl-lib))

(defun jbo/other-file ()
  (interactive)
  (setq f (file-relative-name buffer-file-name (projectile-project-root)))
  (setq L (projectile-get-other-files f))
  (unless L (error "No other file found for %s" f))
  (setq Q nil)
  (dolist (o L)
	(let ((d (file-affinity f o)))
	  (if (not Q)
		  (setq Q (list (cons o d)))
		(setq Q (append (list (cons o d)) Q))
		)
	  )
	)
  (sort Q (lambda (od1 od2) (> (cdr od1) (cdr od2))))
  (setq rel (car (car Q)))
  (setq abs (concat (projectile-project-root) rel))
  (message "list=%s winner=%s" L abs)
  (find-file abs)
  )


(message "loaded jbo-search")
