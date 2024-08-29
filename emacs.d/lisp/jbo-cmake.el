(defun jbo--fix-cmake-indentation-worker ()
  (setq indent-tabs-mode nil)
  (setq cmake-tab-width 4)
  )

(defun jbo--cmake-setup () 
  (add-hook 'cmake-mode-hook
                        (lambda () (jbo--fix-cmake-indentation-worker)))
  )

(jbo--cmake-setup)
