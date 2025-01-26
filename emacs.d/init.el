(setq inhibit-startup-screen t)
(switch-to-buffer "*Messages*")

;; menubar/toolbar blocks F12 in xubuntu-emacs
(menu-bar-mode -1)
;;(tool-bar-mode -1)
(setq visible-bell t)
(setq ring-bell-function 'ignore)
;; ask before quitting
(setq confirm-kill-emacs 'yes-or-no-p)
;; stop creating backup files and autosave.
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

(require 'treesit)
(treesit-available-p)  ;; t
(setq treesit-extra-load-path '("/usr/local/lib"))

;; remove warning "package cl is deprecated"
(setq byte-compile-warnings '(cl-functions))

(add-to-list 'load-path "~/.emacs.d/lisp/")
(load "jbo-package-initialize")

(load "arduino-mode") 
(load "csharp-mode")
(load "qt-pro-mode")

(load "jbo-search")
(load "jbo-utils")
(load "jbo-dev")
(load "jbo-colors-linux")
(load "jbo-keys")

(jbo/fix-python-indentation)

(require 'cc-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))

(global-company-mode)

(require 'qt-pro-mode)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

(require 'expand-region)
(jbo-fix-expand-region-for-line)

(add-hook 'kill-emacs-hook 'jbo-update-recentf-list)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(put 'scroll-left 'disabled nil)

;; follow the output
(setq compilation-scroll-output t)
;; stops at the first error or warning
;;(setq compilation-scroll-output 'first-error)

(setq-default tab-width 4)
;; reload files if changed on disk
(global-auto-revert-mode t)

(setq large-file-warning-threshold 100000000)

(jbo-fix-project-roots)
;; projectile-globally-ignored-directories (append '("*__pycache__/")
;; projectile-globally-ignored-directories)

;; (add-hook 'after-save-hook 'jbo/update-tags-for-file)
(add-hook 'before-save-hook 'jbo/clang-format-buffer)
(fido-mode 't)
(fido-vertical-mode)
(xclip-mode 't)
(projectile-mode t)
(jbo/open-all-recent-files)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(toggle-frame-maximized)
(server-start)
(message "ready")
