(defgroup modal nil
  "Introduce native modal editing of your own design"
  :group  'editing
  :tag    "Modal"
  :prefix "modal"
  :link   '(url-link :tag "GitHub" "https://github.com/mrkkrp/modal"))

(defvar modal-mode-map (make-sparse-keymap)
  "This is Modal mode map, used to translate your keys.")

(define-key modal-mode-map (kbd "u") 'forward-word)

(define-minor-mode modal-mode
  "Toggle the `modal-mode' minor mode."
  nil "↑" modal-mode-map
  (setq-local cursor-type
              (if modal-mode
                  modal-cursor-type
                (default-value 'cursor-type))))

(defun modal--maybe-activate ()
  "Activate `modal-mode' if current buffer is not minibuffer or blacklisted.

This is used by `modal-global-mode'."
  (unless (or (minibufferp)
              (member major-mode modal-excluded-modes))
    (modal-mode 1)))

;;;###autoload
(define-globalized-minor-mode modal-global-mode
  modal-mode
  modal--maybe-activate)

(defun modal--input-function-advice (fnc key)
  "Call FNC with KEY as argument only when `modal-mode' is disabled.

Otherwise use `list'."
  (funcall (if modal-mode #'list fnc) key))

(advice-add 'quail-input-method :around #'modal--input-function-advice)

(provide 'modal)

;;; modal.el ends here
