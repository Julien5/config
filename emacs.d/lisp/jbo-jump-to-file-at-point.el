(defun jump-to-file-at-point-execute (line filename)
  ;; todo: cache results.  
  (let* ((executable (format "%s/bash/%s"
							 user-emacs-directory
							 "jump-to-file-at-point.sh"))
		 (cmd (format "%s %s %s %s" executable (emacs-pid)
					  (shell-quote-argument (string-trim line))
					  (shell-quote-argument filename))))
    (require 'subr-x)
	(message "executing:%s %s %s %s"
			 executable
			 (emacs-pid)
			 (shell-quote-argument "line")
			 (shell-quote-argument filename))
	(setq result (string-trim (shell-command-to-string cmd)))
    (if (not (equal "" result))
		(progn (message "found %s" result)
			   (find-file result))
      (message "could not find other file")
      )
    )
  )

(defun jbo/jump-to-file-at-point ()
  (interactive)
  (save-excursion
    (let ((basename (file-name-nondirectory buffer-file-name))
		  (line (thing-at-point 'line' 'no-properties)))
      (jump-to-file-at-point-execute line basename)
      )))

;;(switch-to-buffer "debug.cpp")
;;(jump-to-file-at-point)
;;(switch-to-buffer "jump-to-file-at-point.el")
