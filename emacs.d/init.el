;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq inhibit-startup-screen t)
;; menubar/toolbar blocks F12 in xubuntu-emacs

(menu-bar-mode -1)
(tool-bar-mode -1)
;; ask before quitting
(setq confirm-kill-emacs 'yes-or-no-p)
;; stop creating backup files and autosave.
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
;; remove warning "package cl is deprecated"
(setq byte-compile-warnings '(cl-functions))

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
(load "jbo-lsp")
(load "jbo-colors-linux")

(jbo/fix-python-indentation)

(require 'cc-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))

(global-company-mode)

(setq exec-path (append exec-path '("c:/tools/llvm/llvm-10/bin/")))

(require 'qt-pro-mode)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

(require 'expand-region)
(jbo-fix-expand-region-for-line)

;; prevent custom from messing up my init.el
(setq custom-file-dirname "linux-gnu")
(if (eq system-type 'windows-nt)
	(setq custom-file-dirname "msys")
  )
(setq custom-file (format "~/.emacs.d/%s/custom.el" custom-file-dirname))
(load custom-file)

(set-face-attribute 'region nil :background "yellow")
(set-face-attribute 'region nil :foreground "black")
;; https://stackoverflow.com/questions/23142699/in-gnu-emacs-how-to-set-background-color-by-mode
;;(add-hook 'post-command-hook 'jbo-set-background-for-mode)
;;(add-hook 'change-major-mode-hook 'jbo-set-background-for-mode)
;;(add-hook 'window-configuration-change-hook 'jbo-set-background-for-mode)

(add-hook 'kill-emacs-hook 'jbo-update-recentf-list)

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

(setq large-file-warning-threshold 100000000)

(jbo-fix-project-roots)

(setq compilation-scroll-output 'first-error)

;; projectile-globally-ignored-directories (append '("*__pycache__/")
;; projectile-globally-ignored-directories)

;; (add-hook 'after-save-hook 'jbo/update-tags-for-file)
(add-hook 'before-save-hook 'jbo/clang-format-buffer)
(fido-mode nil)
(ido-mode 't)
(projectile-mode t)
(server-start)
(open-all-recent-files)
(message "ready")
(put 'downcase-region 'disabled nil)
