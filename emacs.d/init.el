;; Tell emacs where is your personal elisp lib dir

;;{{{ Set up package and use-package

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap 'use-package'
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

;;}}}

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )

(package-initialize)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/usr/share/emacs25/site-lisp/global")
(load "arduino-mode") ;; best not to include the ending “.el” or “.elc”
(load "csharp-mode")
(load "jump-to-file-at-point")
(load "search")
(load "keys")
(load "utils")

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))

(require 'cc-mode)

(add-to-list 'load-path "~/.emacs.d/lisp/expand-region")
(require 'expand-region)
(global-set-key (kbd "C-+") 'er/expand-region)

;; replace meta-/ with C-a
(global-set-key (kbd "C-a") 'dabbrev-expand) 


(setq colors-file (format "~/.emacs.d/%s/colors.el" (getenv "OSTYPE")))
(load colors-file)

;; swith header/cpp
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

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

;; company
(add-hook 'after-init-hook 'global-company-mode)
; No delay in showing suggestions.
(setq company-idle-delay 0)
; Show suggestions after entering one character.
(setq company-minimum-prefix-length 3)
(setq company-selection-wrap-around t)
; Use tab key to cycle through suggestions.
; ('tng' means 'tab and go')
(company-tng-configure-default)
(define-key company-mode-map [remap indent-for-tab-command] 'company-indent-for-tab-command)

;; (setq tags-file-name nil)
(setq tags-table-list '("~/.op/TAGS"))
(setq large-file-warning-threshold 100000000)

;; projectile
(setq projectile-project-search-path (split-string (shell-command-to-string "cat ~/.op/projectiles")))
(projectile-mode +1)
(setq projectile-enable-caching nil)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(global-set-key (kbd "M-?") 'projectile-ag) 
(defun my-ag-regexp ()
  "ag-regexp."
  (interactive)
  (let ((current-prefix-arg '(1)))
    (call-interactively 'projectile-ag)))
(global-set-key (kbd "M-#") 'my-ag-regexp) 
(global-set-key (kbd "C-k") 'projectile-find-file-in-known-projects)

;; clang-format
(require 'clang-format)
(setq clang-format-style-option nil)
(setq clang-format-executable "clang-format")

(setq inhibit-startup-screen t)
(add-hook 'after-save-hook 'update-tags-for-file)
(message "hi")


