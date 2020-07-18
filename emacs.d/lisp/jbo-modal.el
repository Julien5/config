(defgroup modal nil
  "Introduce native modal editing of your own design"
  :group  'editing
  :tag    "Modal"
  :prefix "jbo-modal")

(defvar jbo-modal-mode-map (make-sparse-keymap)
  "This is Jbo-Modal mode map, used to translate your keys.")

(define-key jbo-modal-mode-map (kbd "u") 'backward-word)
(define-key jbo-modal-mode-map (kbd "o") 'forward-word)

(define-key jbo-modal-mode-map (kbd "j") 'previous-line)
(define-key jbo-modal-mode-map (kbd "l") 'forward-line)

(define-key jbo-modal-mode-map (kbd "<SPC>") 'jbo-modal-mode)

(define-key jbo-modal-mode-map (kbd "<home>") 'smartscan-symbol-go-backward)
(define-key jbo-modal-mode-map (kbd "<end>") 'smartscan-symbol-go-forward)

;;(defun jbo-modal-mode ()
;;  (interactive)
;;  (use-local-map jbo-modal-mode-map))

(define-minor-mode jbo-modal-mode
  "Toggle the `jbo-modal-mode' minor mode."
  nil "(M)" jbo-modal-mode-map
  )

  

(provide 'jbo-modal)

;;; jbo-modal.el ends here
