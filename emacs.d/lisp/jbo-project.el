(defcustom project-root-markers
  '("Cargo.toml" "compile_commands.json" "compile_flags.txt" ".git")
  "Files or directories that indicate the root of a project."
  :type '(repeat string)
  :group 'project
  )

(defun project-root-p (path)
  "Check if the current PATH has any of the project root markers."
  (catch 'found
    (dolist (marker project-root-markers)
      (when (file-exists-p (concat path marker))
		(message "[jbo-project] found: %s" (concat path marker))
        (throw 'found marker)
		)))
  (message "[jbo-project] did not find anything for: %s" path)
  )

(defun project-find-root (path)
  "Search up the PATH for `project-root-markers'."
  (when-let ((root (locate-dominating-file path #'project-root-p)))
    (cons 'transient (expand-file-name root))))

;; used by eglot to find rust project root directory with Cargo.toml
(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (add-to-list 'project-find-functions #'project-find-root)
  (message "[project] %s" project-find-functions)
  )


