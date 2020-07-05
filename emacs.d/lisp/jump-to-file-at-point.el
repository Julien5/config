;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(setq buffer (current-buffer))
(switch-to-buffer "foo")
(setq line (thing-at-point 'line' 'no-properties))
(setq parts (split-string line))
(setq qfilename  (nth 1 parts))
(setq filename (replace-regexp-in-string "[\"<>]" "" qfilename))
(setq basename (file-name-nondirectory filename))
(message "filename:%s" basename)
(sit-for 0.2)
(switch-to-buffer buffer)
(setq L (projectile-all-project-files))
(setq value "0")
(setq stop nil)
(while L
  (setq candidate (car L))
  (if (string-match-p (regexp-quote basename) candidate)
	  (progn
		(message "%s matching:%s" basename candidate)
		(setq L nil)
		)
	(message "not matching:%s" candidate))
  (setq L (cdr L))
  (sit-for 0.1)
value)


;;(find-file (projectile-completing-read "Find file in projects: " (projectile-all-project-files)))))
