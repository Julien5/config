;;; -*- lexical-binding: t -*-

(define-error 'stop-signal "stop" 'stop-continue-signals)
(define-error 'continue-signal "continue" 'stop-continue-signals)

(defun loc-worker-1 (ok)
  (message "worker-start")

  (if (not ok)
	  (signal 'continue-signal "loc-1")
	)
  
  (message "worker-end")
  )

(defun loc-worker-2 ()
  (message "worker-start")
  (signal 'continue-signal "loc-2")
  (message "worker-end")
  )

(defun loc-main ()
  (condition-case _ (progn (loc-worker-1 1)
						   (signal 'stop-signal "stop")
						   )
	(stop-signal (message "stop found:%s" _)(error "done"))
	(continue-signal (message "continue found:%s" _))
	)
  (message "continuing loc-main")
  )

(loc-main)
