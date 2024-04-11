;; prevent custom from messing up my init.el
(setq custom-file-dirname "linux-gnu")
(if (eq system-type 'windows-nt)
	(setq custom-file-dirname "msys")
  )
(setq custom-file (format "~/.emacs.d/%s/custom.el" custom-file-dirname))
(load custom-file)


(setq jbo-font-size 12);
(defun jbo-change-font-size (increment)
  (setq jbo-font-size (+ jbo-font-size increment))
  ;;(setq jbo-font-name (format "Source Code Pro %d" jbo-font-size))
  (setq jbo-font-name (format "TamzenForPowerline %d" jbo-font-size))
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
(set-face-attribute 'region nil :background "yellow")
(set-face-attribute 'region nil :foreground "black")
