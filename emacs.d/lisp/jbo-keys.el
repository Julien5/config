(require 'project)
(require 'make-mode)


(global-set-key (kbd "M-g") 'jbo/google-search)
(global-set-key (kbd "M-k") 'dabbrev-expand)

(global-set-key (kbd "<f2>") 'jbo/other-file)
(global-set-key (kbd "<f4>") 'jbo/find-definitions)
(global-set-key (kbd "<f3>") 'jbo/find-references)
(global-set-key (kbd "<f7>") 'jbo/ag-at-point)

(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-k") 'jbo/find-file)
(global-set-key (kbd "C-o") 'ido-find-file)
(global-set-key (kbd "C-w") 'jbo/kill-this-buffer)

(global-set-key (kbd "C-f") 'isearch-forward-symbol-at-point)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)

(global-set-key (kbd "C-e") 'jbo/projectile-ag)

(global-set-key (kbd "C-u") 'jbo/expand-region)

(global-set-key (kbd "C-q") 'jbo/buffer-menu)

(global-set-key (kbd "<f5>") 'jbo/make)
(global-set-key (kbd "<S-f5>") 'jbo/make-shift)
(global-set-key (kbd "<M-f5>") 'jbo/make-meta) ;; alt-F5


(global-set-key (kbd "<f6>") 'next-error)
(global-set-key (kbd "<S-f6>") 'previous-error)

(global-set-key (kbd "<f9>") 'jbo/diff)
(global-set-key (kbd "<f10>") 'jbo/magit-status)
(global-set-key (kbd "M-a") 'jbo/buffer-list)

(global-set-key (kbd "<M-left>") 'backward-word)
(global-set-key (kbd "<M-right>") 'forward-word)

; c-c c-v for copy paste
(cua-mode t)
(setq cua-keep-region-after-copy t)

;; (global-set-key (kbd "<C-backspace>") 'jbo/backward-delete-word)
(global-set-key (kbd "<M-backspace>") 'jbo/backward-delete-word)
(global-set-key (kbd "M-DEL") 'jbo/backward-delete-word)
(global-set-key (kbd "<C-delete>") 'jbo/delete-line)

(defun jbo-c-s-tab ()
  (if (eq system-type 'windows-nt)
	  (kbd "<C-S-tab>")
	(kbd "<C-iso-lefttab>")
	)
  )

(global-set-key (kbd "M-t") 'jbo/next-code-buffer)
(global-set-key (kbd "M-r") 'jbo/prev-code-buffer)
;;(global-set-key (kbd "<C-S-tab>") 'ido-switch-buffer)
(global-set-key  (jbo-c-s-tab) 'ido-switch-buffer)

(global-set-key (kbd "C-S-p") 'jbo/kill-invisible-buffers)
(global-set-key (kbd "C-p") 'jbo/clean-buffers)

(defun jbo-prev-window ()  (interactive)  (other-window -1))
(defun jbo-next-window ()  (interactive)  (other-window +1))
;;default ? (global-set-key (kbd "<C-home>") 'beginning-of-buffer)
(global-set-key (kbd "<C-prior>") 'jbo-prev-window)
(global-set-key (kbd "<C-next>") 'jbo-next-window)

(global-set-key (kbd "C-b") 'jbo/split-window-below)
(global-set-key (kbd "C-t") 'jbo/split-window-right)
(global-set-key (kbd "C-r") 'jbo/fix-and-zoom-window)

(global-set-key (kbd "<S-f12>") 'jbo/save-window-configuration)
(global-set-key (kbd "<f12>") 'jbo/restore-window-configuration)
(global-set-key (kbd "<S-f10>") 'jbo/restore-private-window-configuration)


(global-set-key (kbd "<M-home>") 'smartscan-symbol-go-backward)
(global-set-key (kbd "<M-end>") 'smartscan-symbol-go-forward)
