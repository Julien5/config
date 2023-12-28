(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff"
	"#eeeeec"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes '(deeper-blue))
 '(menu-bar-mode nil)
 '(package-selected-packages nil)
 '(tool-bar-mode nil))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 98 :width normal)))))


;;(set-frame-font "Source Code Pro 14" nil t)

(setq jbo-font-size 12);
(defun jbo-change-font-size (increment)
  (setq jbo-font-size (+ jbo-font-size increment))
  (setq jbo-font-name (format "Source Code Pro %d" jbo-font-size))
  (set-frame-font jbo-font-name nil t)
  (message "new font: %s" jbo-font-name)
  )

(defun jbo-change-font-size-up ()
  (interactive)
  (jbo-change-font-size 1)
  )

(defun jbo-change-font-size-down ()
  (interactive)
  (jbo-change-font-size -1)
  )
