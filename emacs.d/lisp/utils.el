(defun update-tags-for-file-execute (filename)
  (setq executable (format "%s/bash/%s" user-emacs-directory "update-tags.sh"))
  (setq cmd (format "%s %s" executable
					(shell-quote-argument filename)))
  (require 'subr-x)
  (message "updating tags for file %s" filename)
  (sit-for 0.15)
  (setq error (string-trim (shell-command-to-string cmd)))
  (if (equal "" error)
	  (progn (visit-tags-table (expand-file-name "~/.op/TAGS"))
			 (message "updated %s" filename))
	(message "error %s" error)
	)
  (when (get-buffer "TAGS")
	(kill-buffer (get-buffer "TAGS")))
  ) 

(defun update-tags-for-file ()
  (let* ((file (buffer-file-name (current-buffer))))
	(update-tags-for-file-execute file)
	)
  )
;; (update-tags-for-file)

(defun my-compilation-hook ()
  "Make sure that the compile window is splitting vertically."
  (progn
    (if (not (get-buffer-window "*compilation*"))
        (progn
          (split-window-vertically)))))

(add-hook 'compilation-mode-hook 'my-compilation-hook)

(defun jbo-setup-windows ()
  (delete-other-windows)

  (if (get-buffer "*compilation*")
	  (kill-buffer "*compilation*")
	(message "no")
	)


  (setq compilation-mode-hook nil)
  (add-hook 'compilation-mode-hook 'my-compilation-hook)
  (compile "echo")
  (message "ok")
  (other-window 1)
  (shrink-window-if-larger-than-buffer)
  (other-window 1)
  (save-selected-window
	(let ((w (split-window-right 100)))
	  (select-window w))
	(switch-to-buffer "*other*")
	)
  )

(jbo-setup-windows)
