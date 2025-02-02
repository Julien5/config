;; (defun jbo/project-try (dir)
;;   (cons 'jbo dir)
;;   )

;; ;; (head jbo) :  https://www.gnu.org/software/emacs/manual/html_node/elisp/Generic-Functions.html
;; (cl-defmethod project-root ((project (head jbo)))
;;   "Return root directory of current PROJECT."
;;   (message "project-root:  %s" project)
;;   ;; returns the cdr from (cons 'jbo dir)
;;   ;; => dir.
;;   (cdr project)
;;   )

;; (cl-defmethod project-external-roots ((project (head jbo)))
;;   ;; jbo-projectiles + current dir
;;   (message "project-external-roots: %s" project)
;;   (setq P (list (project-root project)))
;;   (setq R (jbo-projectiles))
;;   (set-difference R P :test #'equal)
;;   )

(defcustom project-root-markers
  '("Cargo.toml" "compile_commands.json" "compile_flags.txt"
    "project.clj" ".git" "deps.edn" "shadow-cljs.edn")
  "Files or directories that indicate the root of a project."
  :type '(repeat string)
  :group 'project)


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

;; must be called in init.el
;; why? i dont remember
(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (add-to-list 'project-find-functions #'project-find-root)
  (message "[project] %s" project-find-functions)
  )

;;(jbo-fix-project-roots)
