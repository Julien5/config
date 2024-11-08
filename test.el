#!/usr/bin/emacs -x

(defun loc-throw()
  (message "start worker")
  ;;(user-error "error from worker")
  (message "end worker")
  )

(defun return-on-ok (err)
  (message "err: %s" err)
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
  (condition-case ok
	  (condition-case err
		  (progn
			(loc-throw)
			(signal ' "ok")
			)
		(user-error (return-on-ok err))
		)
	(error (message "ok"))
	)
  (message "continue")
  )

(loc-maind)



