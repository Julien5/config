;;; -*- lexical-binding: t -*-

(define-error 'stop-signal "stop" 'stop-continue-signals)
(define-error 'continue-signal "continue" 'stop-continue-signals)

(defun loc-worker-1 (ok)
  (message "worker-start-1")
  (if (not ok)
	  (signal 'continue-signal "loc-1")
	)
  (message "worker-end-1")
  )

(defun loc-worker-2 (ok)
  (message "worker-start-2")
  (if (not ok)
	  (signal 'continue-signal "loc-2")
	)
  (message "worker-end-2")
  )

(defun loc-worker-3 (ok)
  (message "worker-start-3")
  (if (not ok)
	  (throw 'failed "loc-3")
	)
  (message "worker-end-3")
  )

(defun loc-worker-4 (ok)
  (message "worker-start-4")
  (if (not ok)
	  (user-error "loc-4")
	)
  (message "worker-end-4")
  )

(defun loc-main ()
  (condition-case _ (progn (loc-worker-1 'nil)
						   (signal 'stop-signal "stop")
						   )
	(stop-signal (message "stop found:%s" _)(error "done"))
	(continue-signal (message "continue found:%s" _))
	)
  (message "continuing loc-main")

  (condition-case _ (progn (loc-worker-2 'nil)
						   (signal 'stop-signal "stop")
						   )
	(stop-signal (message "stop found:%s" _)(error "done"))
	(continue-signal (message "continue found:%s" _))
	)

  (catch 'failed
	(loc-worker-3 nil)
	(error "done"))

  (condition-case _ (progn
					  (loc-worker-4 'nil)
					  (signal 'stop-signal "stop")
					  )
	(stop-signal (message "stop found:%s" _)(error "done"))
	(user-error (message "continue found:%s" _))
	)

  (error "failed")
  
  )

(loc-main)
