(defun jbo-projectiles ()
  (setq R (cdr command-line-args))
  (setq D (list))
  (dolist (r R)
	(setq dirname (file-name-as-directory r))
	(if (file-directory-p dirname)
		(setq D (cons dirname D))
	  (message "skip %s: not a directory" dirname))
	)
  (if (not D) ;; no dir, then used the default
	  (setq D (list default-directory)))
  (delete-dups D)
  )

(defun jbo-tags-path ()
  (expand-file-name (format "~/.op/%s/TAGS" (emacs-pid)))
  )

(defun jbo/reload-tags ()
  (interactive)
  (visit-tags-table (jbo-tags-path))
  )

(defun jbo/find-file ()
  (interactive)
  (project-or-external-find-file)
  )

(defun jbo-update-tags-for-file-execute (filename)
  (setq executable (format "%s/bash/%s" user-emacs-directory "update-tags.sh"))
  (setq cmd (format "%s %s %s" executable (emacs-pid) (shell-quote-argument filename)))
  (require 'subr-x)
  (message "updating tags for file %s" filename)
  (setq error (string-trim (shell-command-to-string cmd)))
  (if (equal "" error)
	  (progn (jbo/reload-tags) ;; necessary ? (the tags filename has not changed)
			 (message "updated %s" filename))
	(message "error %s" error)
	)
  (when (get-buffer "TAGS")
	(kill-buffer (get-buffer "TAGS")))
  )


(defun jbo/update-tags-for-file ()
  (let* ((file (buffer-file-name (current-buffer)))
		 (extension (file-name-extension file)))
	(if (or (equal extension "c") (equal extension "cpp") (equal extension "h"))
		(jbo-update-tags-for-file-execute file)
	  )
	)
  )

(defun jbo/diff ()
  (interactive)
  (setq jbo-diff "git-or-svn-unfixed")
  (if (locate-dominating-file buffer-file-name ".git")
	  (setq jbo-diff "git difftool")
	(if (locate-dominating-file buffer-file-name ".svn")
		(setq jbo-diff "psvn diff")))
  (let* ((file (expand-file-name (buffer-file-name (current-buffer)))))
	(if (file-exists-p file)
		(progn (setq cmd (format "%s %s" jbo-diff file))
			   (message "exe:%s" cmd)
			   (shell-command-to-string cmd))
	  (message "file not found:%s" file))
	))

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


(defun jbo-compile-command ()
  (if (and (boundp 'jbo-compilation-command) jbo-compilation-command)
	  jbo-compilation-command
	(if (file-directory-p (expand-file-name (format "%s/make" (getenv "SETUPROOT"))))
		(expand-file-name (format "%s/make/mk -r" (getenv "SETUPROOT")))
	  "make"
	  )
	))

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
  (setq compile-command (jbo-compile-command))
  (message "compile-command:%s" compile-command)
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
  (message "next-code-buffer")
  (let (( bread-crumb (buffer-name) ))
    (switch-to-next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (switch-to-next-buffer)))
  )

(defun jbo/prev-code-buffer ()
  (interactive)
  (message "prev-code-buffer")
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
	(delete-other-windows)
	(setq orig-dd nil)
	(if (boundp 'jbo-compilation-directory)
		(progn (setq orig-dd default-directory)
			   (cd jbo-compilation-directory))
	  )
	(setq compile-command (jbo-compile-command))
	(message "compile-command:%s" compile-command)
	(compile compile-command)
	(if orig-dd (cd orig-dd))
	))

(defun jbo/set-compile ()
  (interactive)
  (setq jbo-compilation-directory default-directory)
  (jbo/compile)
  )

(defun jbo-clear-window (w)
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
	(jbo-clear-window w))
  )

(defun jbo/reload-init ()
  (load-file (expand-file-name "~/.emacs.d/init.el"))
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


(defun jbo/mark-line ()
  "mark one line"
  (message "hi for line")
  (let ((inhibit-field-text-motion t))
    (end-of-line)
    (push-mark nil t t)
    (beginning-of-line))
  )
 
(defun jbo-fix-expand-region-for-line-p ()
  (make-variable-buffer-local 'er/try-expand-list)
  (setq er/try-expand-list (append er/try-expand-list '(jbo/mark-line)))
  )

(defun jbo-fix-expand-region-for-line ()
  (add-hook 'prog-mode-hook 'jbo-fix-expand-region-for-line-p)
  (add-hook 'text-mode-hook 'jbo-fix-expand-region-for-line-p)
  (add-hook 'special-mode-hook 'jbo-fix-expand-region-for-line-p)
  )


(defun jbo/project-try (dir)
  (cons 'jbo dir)
  )

(cl-defmethod project-root ((project (head jbo)))
  (cdr project)
  )

(cl-defmethod project-external-roots ((project (head jbo)))
  ;; jbo-projectiles + current dir
  (setq P (list (project-root project)))
  (setq R (jbo-projectiles))
  (set-difference R P :test #'equal)
  )

(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (setq dirname (expand-file-name (format "~/.op/%s/" (emacs-pid))))
  (if (not (file-directory-p dirname))
	  (setq dirname (expand-file-name "~/.op/")))
  (setq project-list-file (expand-file-name (format "%s/projects-delme" dirname)))
  (add-hook 'project-find-functions 'jbo/project-try)
  )

(defun jbo-set-white-background ()
  (set-background-color "gray"))

(defun jbo-set-blue-background ()
  (set-background-color "dark blue"))

(defun jbo-set-dark-background ()
  (set-background-color "#242424"))

(defun jbo-set-background-for-mode ()
  (message "mm:%s" major-mode)
  (let ((mm (format "%s" major-mode)))
	(cond
	 ((string-prefix-p "ebrowse" mm) (jbo-set-white-background))
	 (t (jbo-set-dark-background))
	 )))



(defun jbo/clang-format-buffer ()
  (interactive)
  (require 'clang-format)
  (setq clang-format-style-option nil)
  (setq jbo-clang-format-executable nil)
  (if (locate-dominating-file buffer-file-name ".git")
	  (setq jbo-clang-format-executable "clang-format-9.0")
	(if (locate-dominating-file buffer-file-name ".svn")
		(setq jbo-clang-format-executable "clang-format-4.0")
	  ))
  (setq clang-format-executable "clang-format")
  (if (executable-find jbo-clang-format-executable)
	  (setq clang-format-executable jbo-clang-format-executable)
	(message "could not find %s" jbo-clang-format-executable)
	)
  (message "formatting with %s" clang-format-executable)
  (clang-format-buffer))


(defun jbo/delete-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(defun jbo/delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

(defun jbo/backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (jbo/delete-word (- arg)))

(defun jbo/buffer-list ()
  (interactive)
  ;; (read-buffer "> ")
  (let ((completion-regexp-list '("\\`[^*]"
                                  "\\`\\([^T]\\|T\\($\\|[^A]\\|A\\($\\|[^G]\\|G\\($\\|[^S]\\|S.\\)\\)\\)\\).*")))
	(call-interactively 'switch-to-buffer)
  ))

(defun jbo/magit-status ()
  (interactive)
  (magit-status)
  (delete-other-windows)
  )
