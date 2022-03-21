(defun sh/current-time-microseconds ()
  "Return the current time formatted to include microseconds."
  (let* ((nowtime (current-time))
         (now-ms (nth 2 nowtime)))
    (concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d]" now-ms))))

(defun jump-to-file-at-point-execute (line filename)
  (let* ((executable (format "%s/bash/%s"
							 user-emacs-directory
							 "jump-to-file-at-point.sh"))
		 (cmd (format "%s %s %s"
					  executable
					  (shell-quote-argument (string-trim line))
					  (shell-quote-argument filename)
					  )))
	(require 'subr-x)
	(message "executing:%s" cmd)
	(message "searching other file for %s in %s" filename (jbo-projectiles))
	(setq result (string-trim (shell-command-to-string cmd)))
	(if (not (equal "" result))
		(progn (message "found %s" result)
			   (find-file result))
	  (message "could not find other file")
	  )
	)
  )

(defun un-nil-string  (s)
  (if (equal s nil)
	  ""
	s)
  )

(defun jbo/jump-to-file-at-point ()
  (interactive)
  (save-excursion
    (let ((line (thing-at-point 'line' 'no-properties)))
	  (jump-to-file-at-point-execute (un-nil-string line) buffer-file-name)
	  )))

;;(switch-to-buffer "debug.cpp")
;;(jump-to-file-at-point)
;;(switch-to-buffer "jump-to-file-at-point.el")
