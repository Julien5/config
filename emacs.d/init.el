;; Tell emacs where is your personal elisp lib dir

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 120 :width normal :antialias true)))))

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

;; 
(setq compilation-scroll-output t)

(setq-default tab-width 4)
;; reload files if changed on disk
(global-auto-revert-mode t)


(message "hi")

