#!/usr/bin/emacs -x

(defun loc-throw()
  (message "start worker")
  ;;(user-error "error from worker")
  (message "end worker")
  )

(defun return-on-ok (err)
  (let ((errstring (format "%s" err)))
	(message "err: %s" errstring)
	(if (string= errstring "(error ok)")
		(progn
		  (message "return")
		  (error "return")
		  )
	  )
	)
  )

(defun loc-maind ()
  (message "main")
  (condition-case err
	  (progn
		(loc-throw)
		(error "ok")
		)
	(error (return-on-ok err))
	)
  (message "continue")
  )

(loc-maind)



