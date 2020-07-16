(global-set-key (kbd "<f8>") 'modal-mode)

(global-set-key (kbd "<f4>") 'jbo/find-definitions)
(global-set-key (kbd "<f3>") 'jbo/find-references)
(global-set-key (kbd "<S-f3>") 'jbo/refactor-references)
(global-set-key (kbd "C-l") 'goto-line)

(define-key c++-mode-map [f5] #'jbo/compile)
(define-key c++-mode-map [f2] #'jump-to-file-at-point)
(define-key c++-mode-map [tab] 'clang-format-buffer)

(define-key c++-mode-map [f6] 'next-error)
(define-key c++-mode-map [C-f6] 'first-error)
(define-key c++-mode-map [S-f6] 'previous-error)

(global-set-key (kbd "<f9>") 'jbo/take-buffer)

(global-set-key (kbd "<C-left>") 'backward-word)
(global-set-key (kbd "<C-right>") 'forward-word)

(global-set-key (kbd "<C-up>") 'backward-paragraph)
(global-set-key (kbd "<C-down>") 'forward-paragraph)

;; c-c c-v for copy paste
(cua-mode t)

(global-set-key (kbd "<C-tab>") 'jbo/prev-code-buffer)
(global-set-key (kbd "<S-C-iso-lefttab>") 'jbo/next-code-buffer)

(global-set-key (kbd "<C-next>") 'other-window)
(defun prev-window ()  (interactive)  (other-window -1))
(global-set-key (kbd "<C-prior>") 'prev-window)

(global-set-key (kbd "<M-home>") 'smartscan-symbol-go-backward)
(global-set-key (kbd "<M-end>") 'smartscan-symbol-go-forward)


