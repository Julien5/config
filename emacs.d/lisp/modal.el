(defgroup modal nil
  "Introduce native modal editing of your own design"
  :group  'editing
  :tag    "Modal"
  :prefix "modal")

(defvar modal-mode-map (make-sparse-keymap)
  "This is Modal mode map, used to translate your keys.")

(define-key modal-mode-map (kbd "u") 'backward-word)
(define-key modal-mode-map (kbd "o") 'forward-word)

(define-key modal-mode-map (kbd "j") 'previous-line)
(define-key modal-mode-map (kbd "l") 'forward-line)

(define-key modal-mode-map (kbd "<SPC>") 'modal-mode)

(define-key modal-mode-map (kbd "<home>") 'smartscan-symbol-go-backward)
(define-key modal-mode-map (kbd "<end>") 'smartscan-symbol-go-forward)

;;(defun modal-mode ()
;;  (interactive)
;;  (use-local-map modal-mode-map))

(define-minor-mode modal-mode
  "Toggle the `modal-mode' minor mode."
  nil "(M)" modal-mode-map
  )

  

(provide 'modal)

;;; modal.el ends here
