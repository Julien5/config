(defun bootstrap-use-package ()
  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))

  ;; cause warning
  (package-initialize)

  ;; Bootstrap `use-package'
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  (eval-when-compile
    (require 'use-package))
  )

(defun jbo-setup-package-0 ()
  (bootstrap-use-package)
  )

;; DELME
(defun load-chatgpt ()
  (if (file-exists-p "~/.ssh/github-work/openai.el")
      (progn
		(load "~/.ssh/github-work/openai.el")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/chatgpt-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/openai-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/emacs-request-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/tblui.el-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/tablist-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/magit-popup-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/lv")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/ht.el-master")
		(add-to-list 'load-path "~/.emacs.d/lisp/chatgpt/spinner.el-master")
		(require 'chatgpt)
		(load "openai-chat")
		(load "chatgpt")
		)
    )
  )

(defun load-copilot ()
  ;; copilot is not available on elpa => install manually
  ;; see https://github.com/copilot-emacs/copilot.el
  (package-install 'f) 
  (package-install 'editorconfig)
  (add-to-list 'load-path "~/.emacs.d/lisp/copilot/copilot.el-main")
  (require 'copilot)
  (add-hook 'prog-mode-hook 'copilot-mode)
  ;; https://code.visualstudio.com/docs/languages/identifiers#_known-language-identifiers
  (add-to-list 'copilot-major-mode-alist '("cpp" . "cpp"))
  (add-to-list 'copilot-major-mode-alist '("python" . "python"))
  (add-to-list 'copilot-major-mode-alist '("shellscript" . "shellscript"))
  ;; (no lisp language support in copilot?)

  ;; https://github.com/chep/copilot-chat.el
  (package-install 'copilot-chat)
  (require 'copilot-chat)
  (setq copilot-chat-frontend 'markdown)
  )

(defun jbo-package-initialize ()
  (setq elpa-dirname (expand-file-name "~/.emacs.d/elpa/"))
  (jbo-setup-package-0);
  
  ;; Added by Package.el.  This must come before configurations of
  ;; installed packages.  Don't delete this line.  If you don't want it,
  ;; just comment it out by adding a semicolon to the start of the line.
  ;; You may delete these explanatory comments.

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

  (if (not (file-directory-p elpa-dirname))
      (progn (package-refresh-contents)))
  (package-install 'expand-region)
  (package-install 'magit)
  (package-install 'smartscan)
  (package-install 'ag)
  (package-install 'flycheck)
  (package-install 'company)
  (package-install 'use-package)
  (package-install 'projectile)
  (package-install 'markdown-mode)
  (package-install 'cmake-mode)
  (package-install 'xclip)
  (package-install 'popup-switcher)
  )

(jbo-package-initialize)
(load-chatgpt)
(load-copilot)
