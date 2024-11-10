
(defun loc-worker ()
  (message "worker-start")
  (error "bang")
  (message "worker-end")
  )


(defun loc-main ()
  (condition-case _
	  (loc-worker)
	(error (message "error found:%s" _))
	)
  )


(loc-main)
