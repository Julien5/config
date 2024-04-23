(defun bootstrap-use-package ()
  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))

  ;; cause warning
  ;; (package-initialize)

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
