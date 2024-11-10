;;; -*- lexical-binding: t -*-

(define-error 'stop-signal "stop" 'stop-continue-signals)
(define-error 'continue-signal "continue" 'stop-continue-signals)

(defun loc-worker-1 (ok)
  (message "worker-start")

  (if (not ok)
	  (signal 'stop-signal "stop-1")
	)
  
  (message "worker-end")
  )

(defun loc-worker-2 ()
  (message "worker-start")
  (signal 'stop-signal "stop-2")
  (message "worker-end")
  )

(defun loc-main ()
  (let ((code "OK"))

	(condition-case _ (progn (loc-worker-1 1)
							 (signal 'continue-signal "ok")
							 )
	  (stop-signal (message "stop found:%s" _))
	  (continue-signal (message "continue found:%s" _))
	  )
	(message "code=%s" code)
	
	)
  )

(loc-main)
