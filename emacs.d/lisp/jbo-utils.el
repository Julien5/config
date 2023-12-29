(defun sh/current-time-microseconds ()
  "Return the current time formatted to include microseconds."
  (let* ((nowtime (current-time))
         (now-ms (nth 2 nowtime)))
    (concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d]" now-ms))))

(defun jbo-git-root ()
  (locate-dominating-file default-directory ".git")
  )

(defun jbo-lsp-root ()
  (setq jbo--lsp-compile-file (locate-dominating-file default-directory "compile_flags.txt"))
  (if jbo--lsp-compile-file
	  jbo--lsp-compile-file
	(locate-dominating-file default-directory "compile_commands.json"))
  )

(defun jbo-projectiles ()
  (setq jbo--lsp (jbo-lsp-root))
  (if jbo--lsp
	  jbo--lsp
	(jbo-git-root)
	)
  )

(defun jbo/find-file ()
  (interactive)
  (projectile-find-file)
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

(defun jbo-compile-command ()
  (if (and (boundp 'jbo-compilation-command) jbo-compilation-command)
	  jbo-compilation-command
	(if (file-directory-p (expand-file-name (format "%s/make" (getenv "SETUPROOT"))))
		(expand-file-name (format "%s/make/mk -r" (getenv "SETUPROOT")))
	  "make -C /tmp/build_pc"
	  )
	))

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

;; do not switch to a buffer shown on the frame
;; note: switch-to-next-buffer cycle according to the specified window’s history list,
;;       rather than the global buffer list
;;(setq switch-to-prev-buffer-skip 'this)
(setq switch-to-prev-buffer-skip nil)

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
  (message "kill buffer: %s" (buffer-name buf))
  (kill-buffer buf)
  (sit-for 0.1)
  )

(defun jbo-is-temporary-buffer (buf)
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
			  (not (string-equal "*shell*" name))
			  )
		 )
	)
  )

(defun jbo/kill-invisible-buffers ()
  "Kill all buffers not currently shown in a window somewhere."
  (interactive)
  (dolist (buf (buffer-list))
	(setq is-file (buffer-file-name buf))
	(setq visible (get-buffer-window buf 'visible))
	(if (and (not visible) is-file)
		(jbo-kill-buffer-verbose buf)
	  )
	)
  (jbo-update-recentf-list)
  )

(defun jbo/clean-buffers ()
  "Kill all 'internal' buffers, like *ag: blah*."
  (interactive)
  (dolist (buf  (buffer-list))
    (if (jbo-is-temporary-buffer buf)
		(jbo-kill-buffer-verbose buf)
	  (message "keep: %s" (buffer-name buf))
	  )
	)
  (message "ok")
  (jbo-update-recentf-list)
  )

(defun jbo/compile ()
  (interactive)
  (save-selected-window
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
		(setq python-indent-offset 4)
		(setq indent-tabs-mode t)
		))
	))

(defun jbo/fix-python-indentation () 
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
  (add-hook 'project-find-functions 'jbo/project-try)
  )

(defun jbo-clang-format-buffer-p ()
  (require 'clang-format)
  (setq clang-format-style-option nil)
  (setq win-clang-format-executable nil)

  (if (locate-dominating-file buffer-file-name ".svn")
	  (setq win-clang-format-executable "clang-format-4.0")
    (if (locate-dominating-file buffer-file-name ".git")
  		(setq win-clang-format-executable "clang-format-9")
	  ))
  
  (if (eq system-type 'windows-nt)
	  (setq clang-format-executable win-clang-format-executable)
	(setq clang-format-executable "clang-format")
	)
  
  (if (executable-find clang-format-executable)
	  (message "using %s" clang-format-executable)
	(message "could not find %s" clang-format-executable)
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
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

(defun jbo/backward-delete-word (arg)
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
  (jbo/save-window-configuration)
  (magit-status)
  (delete-other-windows)
  )

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
		   "c:/tools/Qt/5.12.10/mingw73_32/bin" ";"
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
  (setenv "TARGET_ARCH" "x86")
  )

(defun jbo-dev-mingw73 ()
  (jbo--mingw73-path-fixup)
  (setenv "PROJECTSDIR" "c:/home/jbourgeois/work/projects")
  (setenv "THIRDPARTYDIR" "c:/home/jbourgeois/work/3rdparty")
  (setenv "TARGET_ARCH" "x86")
  )

(defun xah-filter-list (*predicate *sequence)
  "Return a new list such that *predicate is true on all members of *sequence.
URL `http://ergoemacs.org/emacs/elisp_filter_list.html'
Version 2016-07-18"
  (delete
   "e3824ad41f2ec1ed"
   (mapcar
    (lambda (-x)
      (if (funcall *predicate -x)
          -x
        "e3824ad41f2ec1ed" ))
    *sequence)))

(defun jbo-env-from-dev (dev)
  (setq fmt0 "source ~/setup/profile/profile.sh &> /dev/null; %s &> /dev/null; printenv -0")
  (let ((cmd (format fmt0 dev)))
	(shell-command-to-string cmd)
	)
  )

(defun jbo-read-env (ENV name)
  (let* (
		 (ENVs (split-string ENV "\0" t))
		 (EL (xah-filter-list
			  (lambda (string) (string-prefix-p (format "%s=" name) string))
			  ENVs))
		 (EL2 (split-string (car EL) "=" t))
		 )
	(progn (pop EL2)
		   (string-join EL2 "=")
		   )
	)
  )

(defun jbo-dev-desktop ()
  (let ((ENV (jbo-env-from-dev "dev.desktop")))
	(setenv "PROJECTSDIR" (jbo-read-env ENV "PROJECTSDIR"))
	(setenv "THIRDPARTYDIR" (jbo-read-env ENV "THIRDPARTYDIR"))
	(setenv "PATH" (jbo-read-env ENV "PATH"))
	)
  )

(defun has-lsp ()
  (if (jbo-lsp-root)
	  t
	nil)
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

(defun jbo/split-window-right ()
  (interactive)
  (split-window-right)
  (other-window 1)
  )

(defun jbo/split-window-below ()
  (interactive)
  (split-window-below)
  (other-window 1)
  )

(defun jbo/fix-and-zoom-window ()
  (interactive)
  (jbo/save-window-configuration)
  (delete-other-windows)
  )

(defun jbo/expand-region ()
  (interactive)
  (if (not (region-active-p))
	  (progn
		(setq expand-region-reset-fast-key "<up>")
		(er/expand-region 1))
	)
  )

(defun jbo/kill-this-buffer ()
  (interactive)
  (kill-buffer (current-buffer))
  )

(defun jbo/open-all-recent-files ()
  "Open all recent files."
  (interactive)
  (require 'recentf)
  (recentf-mode 1)
  (setq recentf-max-saved-items 5)
  (setq recentf-menu-open-all-flag t)
  (dolist (file recentf-list) (find-file file)))

(defun jbo-update-recentf-list ()
  "Sync opened files to recent files."
  (interactive)
  (require 'recentf)
  (recentf-mode 1)
  ;; clear the list
  (setq recentf-list '())
  (dolist (buf (buffer-list))
    (if (buffer-file-name buf)
	  (progn
		(message "add: %s" (buffer-file-name buf))
		(add-to-list 'recentf-list (buffer-file-name buf))
		)
	  (message "ignore: %s" (buffer-name buf))
	  )
	)
  (recentf-save-list)
  (dolist (element recentf-list)
	(message "recent:%s" element)
	)
  )

(defun jbo/buffer-menu ()
  (interactive)

  (ibuffer)
  
  (ibuffer-do-sort-by-recency)
  (ibuffer-invert-sorting)

  ;;(ibuffer-do-sort-by-alphabetic)
  ;;(ibuffer-do-sort-by-alphabetic)

  (ibuffer-jump-to-buffer (buffer-name (cadr (buffer-list))))
  )
