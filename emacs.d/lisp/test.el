;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.


(defvar project-root-markers '("README")
  "Files or directories that indicate the root of a project.")

(defun aorst/project-find-root (path)
  "Tail-recursive search in PATH for root markers."
  (setq project-root-markers (list "README"))
  (message "path:%s %s" path project-root-markers)
  (sit-for 0.2)
  (let* ((this-dir (file-name-as-directory (file-truename path)))
		 (parent-dir (expand-file-name (concat this-dir "../")))
		 (system-root-dir (expand-file-name "/")))
	(message "this-dir:%s" this-dir)
	(sit-for 0.2)
	(cond
	 ((aorst/project-root-p this-dir) (cons 'transient this-dir))
	 ((equal system-root-dir this-dir) nil)
	 (t (aorst/project-find-root parent-dir))
	 )
	)
  )

(defun aorst/project-root-p (path)
  "Check if current PATH has any of project root markers."
  (let ((results (mapcar (lambda (marker)
						   (file-exists-p (concat path marker)))
						 project-root-markers)))
	(message "results:%s" results)
	(eval `(or ,@ results))
	)
  )

(defun jbo-fix-project-roots ()
  (setq project-find-functions nil)
  (add-to-list 'project-find-functions #'aorst/project-find-root)
  )

(jbo-fix-project-roots)
