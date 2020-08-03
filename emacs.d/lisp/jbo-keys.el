(require 'project)
(global-set-key (kbd "<f8>") 'modal-mode)

(global-set-key (kbd "M-g") 'jbo/google-search)
(global-set-key (kbd "M-s") 'jbo/so-search)
(global-set-key (kbd "<f4>") 'jbo/find-definitions)
(global-set-key (kbd "<f3>") 'jbo/find-references)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-k") 'jbo/find-file)

(define-key c++-mode-map [f5] 'jbo/compile)
(define-key qt-pro-mode-map [f5] 'jbo/compile)
(define-key c++-mode-map [S-f5] 'jbo/set-compile)
(define-key c++-mode-map [f2] 'jbo/jump-to-file-at-point)
(define-key c++-mode-map [tab] 'jbo/clang-format-buffer)

(global-set-key (kbd "<f6>") 'next-error)
(global-set-key (kbd "<C-f6>") 'first-error)
(global-set-key (kbd "<S-f6>") 'previous-error)

(global-set-key (kbd "<f9>") 'jbo/diff)
(global-set-key (kbd "<f10>") 'jbo/magit-status)
(global-set-key (kbd "M-a") 'jbo/buffer-list)

(global-set-key (kbd "<M-left>") 'xref-pop-marker-stack)
;;(global-set-key (kbd "<M-right>") 'forward-word)

;; c-c c-v for copy paste
(cua-mode t)
(global-set-key (kbd "<C-backspace>") 'jbo/backward-delete-word)
(global-set-key (kbd "<C-delete>") 'jbo/delete-line)


(defun jbo-c-s-tab ()
  (if (eq system-type 'windows-nt)
	  (kbd "<C-S-tab>")
	(kbd "<C-iso-lefttab>")
	)
  )

(global-set-key (kbd "<C-tab>") 'jbo/next-code-buffer)
(global-set-key  (jbo-c-s-tab) 'jbo/prev-code-buffer)
(global-set-key (kbd "C-S-p") 'jbo/kill-invisible-buffers)
(global-set-key (kbd "C-p") 'jbo/kill-internal-buffers)

(global-set-key (kbd "<C-next>") 'other-window)
(defun prev-window ()  (interactive)  (other-window -1))
(global-set-key (kbd "<C-prior>") 'prev-window)

(global-set-key (kbd "<C-f12>") 'jbo/save-window-configuration)
(global-set-key (kbd "<f12>") 'jbo/restore-window-configuration)
(global-set-key (kbd "<S-f10>") 'jbo/restore-private-window-configuration)

(global-set-key (kbd "<M-home>") 'smartscan-symbol-go-backward)
(global-set-key (kbd "<M-end>") 'smartscan-symbol-go-forward)


