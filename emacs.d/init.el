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
(add-to-list 'load-path "~/.emacs.d/lisp/keyfreq")
(add-to-list 'load-path "/usr/share/emacs25/site-lisp/global")
(load "arduino-mode") ;; best not to include the ending “.el” or “.elc”
(load "csharp-mode") 
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\(/\\|\\`\\)[Mm]akefile" . makefile-gmake-mode))

(require 'cc-mode)
(define-key c++-mode-map [f5] #'compile)

(add-to-list 'load-path "~/.emacs.d/lisp/keyfreq")
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

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

;; company
(use-package company
  :defer t
  :init
  (setq company-frontends '(company-pseudo-tooltip-frontend
                            company-echo-metadata-frontend))
  (setq company-require-match nil)
  (setq company-tooltip-align-annotations t)
  (setq company-dabbrev-downcase nil)
  (setq company-eclim-auto-save nil)
  :config
  ;; TOPIC: How add company-dabbrev to the Company completion popup?
  ;; URL: https://emacs.stackexchange.com/questions/15246/how-add-company-dabbrev-to-the-company-completion-popup
  (add-to-list 'company-backends 'company-dabbrev-code)
  (add-to-list 'company-backends 'company-gtags)
  (add-to-list 'company-backends 'company-etags)
  (add-to-list 'company-backends 'company-keywords)
 
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.0)
  (setq company-selection-wrap-around 'on)
  (company-tng-configure-default)

  ;; TOPIC: Switching from AC
  ;; URL: https://github.com/company-mode/company-mode/wiki/Switching-from-AC
  (defun jcs-company-ac-setup ()
    "Sets up `company-mode' to behave similarly to `auto-complete-mode'."

    (custom-set-faces
     ;;--------------------------------------------------------------------
     ;; Preview
     '(company-preview
       ((t (:foreground "dark gray" :underline t))))
     '(company-preview-common
       ((t (:inherit company-preview))))
     ;;--------------------------------------------------------------------
     ;; Base Selection
     '(company-tooltip
       ((t (:background "light gray" :foreground "black"))))
     '(company-tooltip-selection
       ((t (:background "steel blue" :foreground "white"))))
     ;;--------------------------------------------------------------------
     ;; Keyword Selection
     '(company-tooltip-common
       ((((type x)) (:inherit company-tooltip :weight bold))
        (t (:background "light gray" :foreground "#C00000"))))
     '(company-tooltip-common-selection
       ((((type x)) (:inherit company-tooltip-selection :weight bold))
        (t (:background "steel blue" :foreground "#C00000"))))
     ;;--------------------------------------------------------------------
     ;; Scroll Bar
     '(company-scrollbar-fg
       ((t (:background "black"))))
     '(company-scrollbar-bg
       ((t (:background "dark gray"))))))

  (jcs-company-ac-setup)

  (defun jcs--company-complete-selection--advice-around (fn)
    "Advice execute around `company-complete-selection' command."
    (let ((company-dabbrev-downcase t))
      (call-interactively fn)))
  (advice-add 'company-complete-selection :around #'jcs--company-complete-selection--advice-around)
  (global-company-mode t))

(global-company-fuzzy-mode 1)


;; (setq tags-file-name nil)
(setq tags-table-list '("~/.op/TAGS"))
(setq large-file-warning-threshold 100000000)

;; projectile
(setq projectile-project-search-path (split-string (shell-command-to-string "cat ~/.op/projectiles")))
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(global-set-key (kbd "M-?") 'projectile-ag) 
(defun my-ag-regexp ()
  "ag-regexp."
  (interactive)
  (let ((current-prefix-arg '(1)))
    (call-interactively 'projectile-ag)))
(global-set-key (kbd "M-#") 'my-ag-regexp) 
(global-set-key (kbd "C-k") 'projectile-find-file-in-known-projects)
(global-set-key (kbd "C-j") 'projectile-find-other-file)

(message "hi")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages (quote (company-fuzzy ag projectile company)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :slant normal :weight normal :height 120 :width normal :antialias true :foundry "outline"))))
 '(company-preview ((t (:foreground "dark gray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-scrollbar-bg ((t (:background "dark gray"))))
 '(company-scrollbar-fg ((t (:background "black"))))
 '(company-tooltip ((t (:background "light gray" :foreground "black"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:background "light gray" :foreground "#C00000"))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:background "steel blue" :foreground "#C00000"))))
 '(company-tooltip-selection ((t (:background "steel blue" :foreground "white")))))
