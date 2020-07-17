;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.


(defvar project-root-markers '("README")
  "Files or directories that indicate the root of a project.")

(defun aorst/project-find-root (path)
  "Tail-recursive search in PATH for root markers."
  (setq project-root-markers (list "README"))
  (message "path:%s %s" path project-root-markers)
  (sit-for 0.2)
  (cons 'transient "/home/julien/projects/sandbox/embedded/")
  )


(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (add-to-list 'project-find-functions #'aorst/project-find-root)
  )

(jbo-fix-project-roots)
