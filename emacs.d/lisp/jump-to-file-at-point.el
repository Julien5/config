;; Function:
;; call-process-region start end program &optional delete destination display &rest args
(defun execute (exe line filename)
  (setq executable (format "%s/bash/%s" user-emacs-directory exe))
  (setq cmd (format "%s %s %s" executable (shell-quote-argument line) (shell-quote-argument filename)))
  (require 'subr-x)
  (setq result (string-trim (shell-command-to-string cmd)))
  (if (not (equal "" result))
	  (progn (message "found %s" result)
			 (find-file result))
	(message "could not find file for %s" filename)
	)
  )

(defun jump-to-file-at-point ()
  (interactive)
  (save-excursion
	(let ((basename (file-name-nondirectory buffer-file-name))
		  (line (thing-at-point 'line' 'no-properties)))
	  (execute "jump-to-file-at-point.sh" line basename)
	  )))

;;(switch-to-buffer "foo")
;;(jump-to-file-at-point)
;;(switch-to-buffer "jump-to-file-at-point.el")
