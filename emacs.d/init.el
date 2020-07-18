;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq inhibit-startup-screen t)
;; Tell emacs where is your personal elisp lib dir
;;{{{ Set up package and use-package

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/usr/share/emacs25/site-lisp/global")
(load "jbo-package-initialize")
(jbo-package-initialize)

(load "arduino-mode") 
(load "csharp-mode")
(load "qt-pro-mode")

(load "jbo-jump-to-file-at-point")
(load "jbo-search")
(load "jbo-keys")
(load "jbo-utils")

(jbo/fix-python-indentation)

(require 'cc-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))

(require 'qt-pro-mode)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

(require 'expand-region)
(global-set-key (kbd "C-+") 'er/expand-region)

;; replace meta-/ with C-a
(global-set-key (kbd "C-a") 'dabbrev-expand) 

;; prevent custom from messing up my init.el
(setq custom-file (format "~/.emacs.d/%s/custom.el" (getenv "OSTYPE")))
(load (format "~/.emacs.d/%s/colors.el" (getenv "OSTYPE")))

;; hide toolbar
(tool-bar-mode -1)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(put 'scroll-left 'disabled nil)

(setq compilation-scroll-output t)

(setq-default tab-width 4)
;; reload files if changed on disk
(global-auto-revert-mode t)

;; insert matching paren -> ()
(setq skeleton-pair t)
(global-set-key "(" 'skeleton-pair-insert-maybe)
(global-set-key "[" 'skeleton-pair-insert-maybe)
(global-set-key "{" 'skeleton-pair-insert-maybe)

;; (setq tags-file-name nil)
(setq tags-table-list (list (jbo-tags-path)))
(setq large-file-warning-threshold 100000000)

(jbo-fix-project-roots)

;; clang-format
(require 'clang-format)
(setq clang-format-style-option nil)
(if (executable-find "clang-format-9.0")
	(setq clang-format-executable "clang-format-9.0")
  (setq clang-format-executable "clang-format")
  )
(setq compilation-scroll-output 'first-error)

(add-hook 'after-save-hook 'jbo/update-tags-for-file)

(jbo-setup-windows)

(message "hi")
