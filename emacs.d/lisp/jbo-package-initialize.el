(defun jbo-setup-package-0 ()
  (require 'package)
  (setq package-archives nil)
  ;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  ;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (setq package-archives '(("GNU ELPA" . "https://elpa.gnu.org/packages/")

						   ;;("MELPA Stable" . "https://stable.melpa.org/packages/")
						   ("MELPA" . "https://melpa.org/packages/"))
		package-archive-priorities '(;;("MELPA Stable" . 10)
									 ("MELPA" . 5)
									 ("GNU ELPA" . 0)))
  (package-initialize t)
  ;; Bootstrap 'use-package'
  (eval-after-load 'gnutls '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
  (require 'use-package)
  (require 'bind-key)
  (setq use-package-always-ensure t)
  )

(defun jbo-package-initialize ()
  (setq elpa-dirname (expand-file-name "~/.emacs.d/elpa/"))
  (jbo-setup-package-0);
 
  (package-initialize t)
  (unless package--initialized (package-initialize t))
 
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
  
  (require 'package)
  (if (not (file-directory-p elpa-dirname))
      (progn (package-refresh-contents)))
  (package-install 'expand-region)
  (package-install 'magit)
  (package-install 'smartscan)
  (package-install 'ag)
  (package-install 'flycheck)
  (package-install 'company)
  (package-install 'lsp-mode)
  (package-install 'use-package)
  )

(jbo-package-initialize)
