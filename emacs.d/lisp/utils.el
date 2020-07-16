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
  (let* ((file (buffer-file-name (current-buffer)))
		 (extension (file-name-extension file)))
	(if (or (equal extension "c") (equal extension "cpp") (equal extension "h"))
		(update-tags-for-file-execute file)
	  )
	)
  )
;; (update-tags-for-file)

(defun jbo/create-proper-compilation-window ()
  "Setup the *compilation* window with custom settings."
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")

          ;; Reduce window height
          (shrink-window (- h compilation-window-height))

          ;; Prevent other buffers from displaying inside
          (set-window-dedicated-p w +1) 
		  )))))


(defun jbo-setup-windows ()
  (setq jbo/main-window (get-buffer-window "*compilation*"))
  (delete-other-windows)
  (setq jbo/current-buffer (current-buffer))
  (if (get-buffer "*compilation*")
	  (progn (message "killing compilation")
			 (kill-compilation)
			 (kill-buffer "*compilation*")
			 (message "killed compilation")
			 )
	(message "no")
	)
  
  (setq compilation-window-height 15);
  (setq compilation-mode-hook nil)
  (add-hook 'compilation-mode-hook 'jbo/create-proper-compilation-window)
  (compile "echo")
  (setq compile-command "$SETUPROOT/make/mk")
  (message "ok")
  (save-selected-window
	(setq jbo/bottom-window (get-buffer-window "*compilation*"))
	(select-window jbo/bottom-window)
	(set-window-dedicated-p jbo/bottom-window +1)
	(setq jbo/compilation-state (window-state-get jbo/bottom-window))
	(switch-to-buffer "*xref*")
	(set-window-buffer jbo/bottom-window "*xref*")
	(setq jbo/xref-state (window-state-get jbo/bottom-window))
	)
  (select-window (get-buffer-window jbo/current-buffer))
  (save-selected-window
  	(let ((w (split-window-right 100)))
	  (select-window w))
	(switch-to-buffer "*other*")
	)
  )

;;(jbo-setup-windows)

(defun jbo/next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (next-buffer)))
  )

(defun jbo/compile ()
  (interactive)
  (save-selected-window
	(window-state-put jbo/compilation-state jbo/bottom-window)
	(compile compile-command)
	))
