(defun jbo-lsp-compile-file ()
  (setq jbo--lsp-compile-file (locate-dominating-file default-directory "compile_flags.txt"))
  (if (not jbo--lsp-compile-file)
	  (setq jbo--lsp-compile-file (locate-dominating-file default-directory "compile_commands.json"))
	)
  jbo--lsp-compile-file
  )

(defun jbo-projectiles-p ()
  (setq D (list))
  (if (jbo-lsp-compile-file)
	  (setq D (cons (jbo-lsp-compile-file) D))
	)
  (if (not D) ;; no dir, then use the default
	  (setq D (list (read-directory-name "dir:")))
	)
  (delete-dups D)
  )

(defun jbo-projectiles ()
  (if (not (boundp 'jbo-projectiles-cache))
	  (setq jbo-projectiles-cache nil)
	)
  (if (not jbo-projectiles-cache)
	  (setq jbo-projectiles-cache (jbo-projectiles-p))
	)
  jbo-projectiles-cache
   )

(defun jbo-tags-path ()
  (expand-file-name (format "~/.op/TAGS"))
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
  (setq cmd (format "%s %s" executable (shell-quote-argument filename)))
  (require 'subr-x)
  (message "exe %s" cmd)
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
		(progn (setq cmd (format "%s %s &" jbo-diff file))
			   (message "exe:%s" cmd)
			   (call-process-shell-command cmd nil 0)
			   )
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

(defun jbo/restore-window-configuration ()
  (interactive)
  (jump-to-register 'w)
  (message "windows restored")
  )

(defun jbo/save-window-configuration ()
  (interactive)
  (window-configuration-to-register 'w)
  (message "windows saved")
  )

(defun jbo/save-private-window-configuration ()
  (window-configuration-to-register 'p)
  (message "saved")
  )

(defun jbo/restore-private-window-configuration ()
  (interactive)
  (jump-to-register 'p)
  (message "restored")
  )

;; do not switch to a buffer shown on the frame
;; note: switch-to-next-buffer cycle according to the specified window’s history list,
;;       rather than the global buffer list
(setq switch-to-prev-buffer-skip 'this)

(defun jbo/next-code-buffer ()
  (interactive)
  (message "next-code-buffer")
  (let (( bread-crumb (buffer-name) ))
	(switch-to-next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
	  (switch-to-next-buffer)
	  ))
  )

(defun jbo/prev-code-buffer ()
  (interactive)
  (message "prev-code-buffer")
  (let ((bread-crumb (buffer-name)))
	(switch-to-prev-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
	  (switch-to-prev-buffer)
	  ))
  )

(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (buffer-local-value 'mode-name
					  (if buffer-or-name
						  (get-buffer buffer-or-name)
						(current-buffer)))
  )

(defun jbo-kill-buffer-verbose (buf)
  (message "killing buffer %s" (buffer-name buf))
  (kill-buffer buf)
  (sit-for 0.1)
  )

(defun jbo-is-internal-buffer (buf)
  (let ((name (buffer-name buf))
		(mode (buffer-mode buf)))
	;;(message "name: '%s'" name)
	;; (message "name: %s" mode)
	;;(message "not message ? %s" (not (string-equal "*Messages*" name)))
	;;(message "not clangd  ? %s" (not (string-prefix-p "*clangd" name)))
	;;(message "not lsp     ? %s" (not (string-prefix-p "*lsp" name)))
	;;(message "is  match S ? %s" (string-prefix-p " " name))
	;;(message "is  match * ? %s" (string-prefix-p "*" name))
	;;(message "is  Magit   ? %s" (string-prefix-p "Magit" mode))
	(and (or (string-prefix-p "*" name)
			 (string-prefix-p "Magit" mode))
		 (and (not (string-prefix-p " " name)) ;; are not shown in list anyway
			  (not (string-prefix-p "*lsp" name))
			  (not (string-prefix-p "*clangd" name))
			  (not (string-equal "*Messages*" name))
			  )
		 )
	)
  )

(defun jbo/kill-internal-buffers ()
  "Kill all buffers not currently shown in a window somewhere."
  (interactive)
  (dolist (buf  (buffer-list))
    (if (jbo-is-internal-buffer buf)
		(jbo-kill-buffer-verbose buf)
	  (message "pass %s" (buffer-name buf))
	  )
	)
  (message "ok")
  )

(defun jbo/kill-invisible-buffers ()
  "Kill all buffers not currently shown in a window somewhere."
  (interactive)
  (dolist (buf  (buffer-list))
    (unless (get-buffer-window buf 'visible)
	  (jbo-kill-buffer-verbose buf)
	  )
	)
  (message "ok")
  )

(defun jbo/compile ()
  (interactive)
  (save-selected-window
	;;(delete-other-windows)
	(jbo/save-private-window-configuration)
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

;; must be called in init.el
(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  ;;(setq dirname (expand-file-name "~/.op/"))
  ;;(setq project-list-file (expand-file-name (format "%s/projects-delme" dirname)))
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

(defun jbo-clang-format-buffer-p ()
  (require 'clang-format)
  (setq clang-format-style-option nil)
  (setq jbo-clang-format-executable nil)


  (if (locate-dominating-file buffer-file-name ".svn")
	  (setq jbo-clang-format-executable "clang-format-4.0")
    (if (locate-dominating-file buffer-file-name ".git")
  		(setq jbo-clang-format-executable "clang-format-9")
	  ))
  
  (setq clang-format-executable "clang-format")
  (if (executable-find jbo-clang-format-executable)
	  (setq clang-format-executable jbo-clang-format-executable)
	(setq clang-format-executable "clang-format-10")
	)
  (message "formatting with %s" clang-format-executable)  
  (clang-format-buffer)
  (message "formatted with %s" clang-format-executable)
  )

(defun jbo/clang-format-buffer ()
  (interactive)
  (setq extension (file-name-extension buffer-file-name))
  (if (or (equal extension "c") (equal extension "cpp") (equal extension "h"))
	  (jbo-clang-format-buffer-p)
	(message "(no need to clang-format:%s)" buffer-file-name)
	)
  )

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
  (jbo/save-private-window-configuration)
  (magit-status)
  (delete-other-windows)
  )

(defun jbo/so-search ()
  (interactive)
  (jbo/save-private-window-configuration)
  (delete-other-windows)
  ;;(setq sx-tab-default-order "Most Voted")
  (setq sx-tab-default-order "Score")
  (setq jboword nil)
  (if (use-region-p)
      (setq jboword (buffer-substring (region-beginning) (region-end))))
  (setq jboword (read-string "so: " jboword))
  (sx-search "stackoverflow" jboword))

;;; The custom search URLs
(defvar *internet-search-urls*
  (quote ("http://www.google.com/search?ie=utf-8&oe=utf-8&btnI=1&q=%s"
		  "http://en.wikipedia.org/wiki/Special:Search?search=")))

;;; Search a query on the Internet using the selected URL.
(defun jbo/google-search (arg)
  "Searches the internet using the ARGth custom URL for the marked text.
If a region is not selected, prompts for the string to search on.
The prefix number ARG indicates the Search URL to use. By default the search URL at position 1 will be used."
  (interactive "p")

  ;; Some sanity check.
  (if (> arg (length *internet-search-urls*))
	  (error "There is no search URL defined at position %s" arg))

  (setq jboword nil)
  (if (use-region-p)
      (setq jboword (buffer-substring (region-beginning) (region-end))))
  (setq jboword (read-string "gg: " jboword))
  ;; Now get the Base URL to use for the search
  (setq baseurl (nth (1- arg) *internet-search-urls*))
  
  ;; Add the query parameter
  (let ((url
		 (if (string-match "%s" baseurl)
			 ;; If the base URL has a %s embedded, then replace it
			 (replace-match jboword t t baseurl)
		   ;; Else just append the query string at end of the URL
		   (concat baseurl jboword))))
	
	(message "Searching for %s at %s" jboword url)
	;; Now browse the URL
	(browse-url url)))


(defun jbo--mingw49-path-fixup ()
  (setenv "PATH"
		  (concat
		   "c:/tools/old/Qt5.6.3/5.6.3/mingw49_32/bin" ";"
		   "c:/tools/old/Qt5.6.3/Tools/mingw492_32/bin" ";"
		   "c:/home/jbourgeois/setup/make/win32" ";"
		   (getenv "PATH")
		   )
		  )
  )

(defun jbo--mingw73-path-fixup ()
  (setenv "PATH"
		  (concat
		   "c:/tools/Qt/5.12.4/mingw73_32/bin" ";"
		   "c:/tools/Qt/Tools/mingw730_32/bin" ";"
		   "c:/home/jbourgeois/setup/make/win32" ";"
		   (getenv "PATH")
		   )
		  )
  )

(defun jbo-dev-mingw49 ()
  (jbo--mingw49-path-fixup)
  (setenv "PROJECTSDIR" "c:/home/jbourgeois/work/projects")
  (setenv "THIRDPARTYDIR" "c:/home/jbourgeois/work/3rdparty")
  )

(defun jbo-dev-mingw73 ()
  (jbo--mingw73-path-fixup)
  (setenv "PROJECTSDIR" "c:/home/jbourgeois/work/projects")
  (setenv "THIRDPARTYDIR" "c:/home/jbourgeois/work/3rdparty")
  )

(defun has-lsp ()
  (if (jbo-lsp-compile-file)
	  t
	nil)
  )

(defun jbo-lsp-deferred ()
  (if (string-equal major-mode "c++-mode")
	  (if (has-lsp)
		  (lsp-deferred)
		(message "no compile_flags.txt"))
	(message "no lsp for mode %s" major-mode))
  )

(defun jbo/expand ()
  (interactive)
  (if (and (string-equal major-mode "c++-mode")
		   (has-lsp))
	  (call-interactively 'company-capf)
	(call-interactively 'dabbrev-expand)
	)
  )


(defun jbo/revert-all-buffers ()
  "Refresh all open buffers from their respective files."
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (let ((filename (buffer-file-name buffer)))
        ;; Revert only buffers containing files, which are not modified;
        ;; do not try to revert non-file buffers like *Messages*.
        (when filename
          (if (file-exists-p filename)
              ;; If the file exists, revert the buffer.
              (with-demoted-errors "Error: %S"
                (with-current-buffer buffer
                  (revert-buffer :ignore-auto :noconfirm)))
            ;; If the file doesn't exist, kill the buffer.
            (let (kill-buffer-query-functions) ; No query done when killing buffer
              (kill-buffer buffer)
              (message "Killed non-existing file buffer: %s" buffer))))
        (setq buffer (pop list)))))
  (message "Finished reverting non-file buffers."))
