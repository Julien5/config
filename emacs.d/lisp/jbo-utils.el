(defun jbo-projectiles ()
  (setq cmd (format "cat %s" (shell-quote-argument (expand-file-name "~/.op/projectiles"))))
  (setq R (split-string (shell-command-to-string cmd)))
  (setq D (list))
  (dolist (r R)
	(setq D (cons (file-name-as-directory r) D))
	)
  D
  )

(defun jbo/find-file ()
  (interactive)
  (project-find-file)
  )

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
  (setq jbo/main-window (get-buffer-window))
  (delete-other-windows)
  (setq jbo/current-buffer (current-buffer))
  (if (get-buffer "*compilation*")
	  (progn (message "killing compilation")
			 ;;(kill-compilation)
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
	(setq jbo/right-window (get-buffer-window))
	)
  )

;;(jbo-setup-windows)

(defun jbo/next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (switch-to-prev-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (switch-to-prev-buffer)))
  )

(defun jbo/compile ()
  (interactive)
  (save-selected-window
	(window-state-put jbo/compilation-state jbo/bottom-window)
	(compile compile-command)
	))

(defun jbo/clear-window (w)
  (if (not (or (equal w jbo/main-window)
			   (equal w jbo/bottom-window)
			   (equal w jbo/right-window)))
	  (progn (select-window w)
			 (delete-window))
	)
  )

(defun jbo/take-buffer ()
  (interactive)
  (let* ((f (buffer-file-name))
		 (w (get-buffer-window)))
	(if f
		(progn (select-window jbo/main-window)
			   (find-file f)
			   ))
	(jbo/clear-window w))
  )


;; https://emacs.stackexchange.com/questions/32140/python-mode-indentation
(defun how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.                    
   Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if        
  ;; neither, we use the current indent-tabs-mode                               
  (let ((space-count (how-many-region (point-min) (point-max) "^  "))
        (tab-count (how-many-region (point-min) (point-max) "^\t")))
    (if (> space-count tab-count)
		(progn
		  (message "indent with spaces")
		  (setq indent-tabs-mode nil)
		  )
	  (progn
		(message "indent with tabs")
		(setq tab-width 4)
		(setq indent-tabs-mode t)
		))
	))

(defun jbo/fix-python-indentation() 
  (setq python-mode-hook nil)
  (add-hook 'python-mode-hook
			(lambda ()
			  (setq indent-tabs-mode nil)
			  (infer-indentation-style)))
  )

(defun jbo/project-try (dir)
  (message "directory:%s" dir)
  (cons 'jbo dir)
  )

(cl-defmethod project-roots ((project (head jbo)))
  ;;(setq R (list "a/" "b/"))
  (setq R (jbo-projectiles))
  (setq D (cdr project))
  (setq R (append R (list D)))
  (delete-dups R)
  )

(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (add-hook 'project-find-functions 'jbo/project-try)
  )

;;(jbo-fix-project-roots)