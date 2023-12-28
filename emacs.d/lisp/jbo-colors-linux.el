(setq jbo-font-size 12);
(defun jbo-change-font-size (increment)
  (setq jbo-font-size (+ jbo-font-size increment))
  (setq jbo-font-name (format "Source Code Pro %d" jbo-font-size))
  (set-frame-font jbo-font-name nil t)
  (message "new font: %s" jbo-font-name)
  )

(defun jbo/change-font-size-up ()
  (interactive)
  (jbo-change-font-size 1)
  )

(defun jbo/change-font-size-down ()
  (interactive)
  (jbo-change-font-size -1)
  )

(jbo-change-font-size 0)
