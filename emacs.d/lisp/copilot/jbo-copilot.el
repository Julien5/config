(use-package copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("C-n" . 'copilot-next-completion)
              ("C-p" . 'copilot-previous-completion))

  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(defun print-mode-status (mode)
  "Prints 'enabled' if the given MODE is enabled."
  (interactive "SMode: ")
  (if (symbol-value mode)
      (message "%s is enabled" mode)
    (message "%s is disabled" mode)
	)
  )

(defun jbo/switch-copilot ()
  (interactive)
  (copilot-mode 'toggle)
  (print-mode-status 'copilot-mode)
  )

(defun jbo/copilot-chat ()
  (interactive)
  (copilot-chat-display))

(defun jbo/copilot-explain-symbol-at-line ()
  (interactive)
  (copilot-chat-explain-symbol-at-line))

(defun jbo/copilot-explain ()
  (interactive)
  (copilot-chat-explain))

(defun jbo/copilot-review ()
  (interactive)
  (copilot-chat-review))

(defun jbo/copilot-fix ()
  (interactive)
  (copilot-chat-fix))

(defun jbo/copilot-add ()
  (interactive)
  (copilot-chat-add-current-buffer))

(defun jbo/copilot-del ()
  (interactive)
  (copilot-chat-del-current-buffer))

(defun jbo/copilot-ask ()
  (interactive)
  (copilot-chat-ask-and-insert))

(defun jbo/copilot-optimize ()
  (interactive)
  (copilot-chat-optimize))
