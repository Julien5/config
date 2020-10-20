(defun jump-to-file-at-point-execute (line filename)
  ;; todo: cache results.  
  (let* ((executable (format "%s/bash/%s"
							 user-emacs-directory
							 "jump-to-file-at-point.sh"))
		 (qD (mapcar 'shell-quote-argument (jbo-projectiles)))
		 (qqD (mapconcat 'identity (jbo-projectiles) " "))
		 (fmt (car (mapcar (lambda (arg) "%s") qD)))
		 (cmd (format "%s %s %s %s"
					  executable
					  (shell-quote-argument (string-trim line))
					  (shell-quote-argument filename) ;; (format "%s%s" default-directory filename)
					  (format fmt qqD)
					  )))
	(require 'subr-x)
	;;(message "executing:%s" cmd)
	(message "searching other file in %s" (jbo-projectiles))
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
