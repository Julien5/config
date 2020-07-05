(defun jump-to-file-at-point ()
  (interactive)
  (save-excursion
	(let* ((line (thing-at-point 'line' 'no-properties))
		   (parts (split-string line))
		   (qfilename  (nth 1 parts))
		   (filename (replace-regexp-in-string "[\"<>]" "" qfilename))
		   (basename (file-name-nondirectory filename)))
	  (setq cmd (format "find $(cat ~/.op/projectiles) -type f -name \"%s\"" basename))
	  (require 'subr-x)
	  (find-file (string-trim (shell-command-to-string cmd)))
	  )))

;;(switch-to-buffer "foo")
;;(jump-to-file-at-point)

;;;;;;;;;;;;;;


(defun try-my-dabbrev-substring (old)
  (let ((old-fun (symbol-function 'he-dabbrev-search)))
    (fset 'he-dabbrev-search (symbol-function 'my-dabbrev-substring-search))
    (unwind-protect
        (try-expand-dabbrev old)
      (fset 'he-dabbrev-search old-fun))))


(defun my-dabbrev-substring-search (pattern &optional reverse limit)
  (let ((result ())
	(regpat (cond ((not hippie-expand-dabbrev-as-symbol)
		       (concat (regexp-quote pattern) "\\sw+"))
		      ((eq (char-syntax (aref pattern 0)) ?_)
		       (concat (regexp-quote pattern) "\\(\\sw\\|\\s_\\)+"))
		      (t
		       (concat (regexp-quote pattern)
			       "\\(\\sw\\|\\s_\\)+")))))
    (while (and (not result)
		(if reverse
		     (re-search-backward regpat limit t)
		     (re-search-forward regpat limit t)))
      (setq result (buffer-substring-no-properties (save-excursion
                                                     (goto-char (match-beginning 0))
                                                     (skip-syntax-backward "w_")
                                                     (point))
						   (match-end 0)))
      (if (he-string-member result he-tried-table t)
	  (setq result nil)))     ; ignore if bad prefix or already in table
    result))
