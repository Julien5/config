(global-set-key (kbd "<f8>") 'modal-mode)

(global-set-key (kbd "<f2>") 'xref-find-definitions)
(global-set-key (kbd "<f3>") 'find-references)

(global-set-key (kbd "<left>") 'backward-word)
(global-set-key (kbd "<right>") 'forward-word)

(global-set-key (kbd "<up>") 'backward-paragraph)
(global-set-key (kbd "<down>") 'forward-paragraph)

(global-set-key (kbd "<C-left>") 'backward-char)
(global-set-key (kbd "<C-right>") 'forward-char)
(global-set-key (kbd "<C-up>") 'previous-line)
(global-set-key (kbd "<C-down>") 'next-line)

;; c-c c-v for copy paste
(cua-mode t)

(global-set-key (kbd "<M-prior>") 'previous-buffer)
(global-set-key (kbd "<M-next>") 'next-buffer)

(global-set-key (kbd "<C-next>") 'other-window)
(defun prev-window ()  (interactive)  (other-window -1))
(global-set-key (kbd "<C-prior>") 'prev-window)

(global-set-key (kbd "<M-home>") 'smartscan-symbol-go-backward)
(global-set-key (kbd "<M-end>") 'smartscan-symbol-go-forward)
