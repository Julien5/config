;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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

(setq colors-file (format "~/.emacs.d/%s/colors.el" (getenv "OSTYPE")))
(load colors-file)

;; hide toolbar
(tool-bar-mode -1)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
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
(setq tags-table-list '("~/.op/TAGS"))
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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
	(smartscan magit expand-region company-fuzzy ag projectile company)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier" :slant normal :weight normal :height 120 :width normal :antialias true)))))
