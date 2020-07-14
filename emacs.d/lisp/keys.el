(global-set-key (kbd "<f8>") 'modal-mode)

(global-set-key (kbd "<f4>") 'xref-find-definitions)
(global-set-key (kbd "<f3>") 'find-references)
(global-set-key (kbd "C-l") 'goto-line)

(define-key c++-mode-map [f5] #'compile)
(define-key c++-mode-map [f2] #'jump-to-file-at-point)

(global-set-key (kbd "<C-left>") 'backward-word)
(global-set-key (kbd "<C-right>") 'forward-word)

(global-set-key (kbd "<C-up>") 'backward-paragraph)
(global-set-key (kbd "<C-down>") 'forward-paragraph)

;; c-c c-v for copy paste
(cua-mode t)

(global-set-key (kbd "<M-prior>") 'previous-buffer)
(global-set-key (kbd "<M-next>") 'next-buffer)

(global-set-key (kbd "<C-next>") 'other-window)
(defun prev-window ()  (interactive)  (other-window -1))
(global-set-key (kbd "<C-prior>") 'prev-window)

(global-set-key (kbd "<M-home>") 'smartscan-symbol-go-backward)
(global-set-key (kbd "<M-end>") 'smartscan-symbol-go-forward)
