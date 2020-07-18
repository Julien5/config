(defun jump-to-file-at-point-execute (line filename)
  (let* ((executable (format "%s/bash/%s"
			     user-emacs-directory
			     "jump-to-file-at-point.sh"))
	 (cmd (format "%s %s %s" executable
		      (shell-quote-argument line)
		      (shell-quote-argument filename))))
    (require 'subr-x)
    (message "searching other file")
    (setq result (string-trim (shell-command-to-string cmd)))
    (if (not (equal "" result))
	(progn (message "found %s" result)
	       (find-file result))
      (message "could not find file for %s" filename)
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
