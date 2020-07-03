;; Tell emacs where is your personal elisp lib dir

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages (quote (ag projectile company)))
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

;; company
(add-hook 'after-init-hook 'global-company-mode)
; No delay in showing suggestions.
(setq company-idle-delay 0)
; Show suggestions after entering one character.
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
; Use tab key to cycle through suggestions.
; ('tng' means 'tab and go')
(company-tng-configure-default)
(define-key company-mode-map [remap indent-for-tab-command] 'company-indent-for-tab-command)

;; (setq tags-file-name nil)
(setq tags-table-list '("~/.op/TAGS"))


;; projectile
(setq projectile-project-search-path (split-string (shell-command-to-string "cat ~/.op/projectiles")))
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (setq projectile-project-search-path '("~/work/projects/embedded/feedbacksensor/" "~/svn/trunk/TS_main/mdal"))
;; (setq projectile-known-projects-file (split-string (shell-command-to-string "cat ~/.op/projectiles")))

;; tags
(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "ctags -f TAGS -e -R %s" (directory-file-name dir-name)))
  )
 
;; (shell-command (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))

(message "hi")
(setq my-foo (shell-command-to-string "/bin/echo hello hi"))
(setq my-foos (split-string (shell-command-to-string "cat ~/.op/projectiles")))
;;(setq my-foos (split-string "a b"))
;; (setq my-foos '("a" "b"))
(message "%s" my-foos)


