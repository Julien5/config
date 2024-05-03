;; f5 does jbo/make, and the dispatch is there.
;; (eval-after-load 'sh-script  '(define-key sh-mode-map [f5] 'jbo/execute-buffer))


(defun jbo-make-python-mode ()
  (let ((filename (buffer-file-name (current-buffer))))
	(message "interpret:%s" filename)
	(executable-interpret filename)
	)
  )

;; https://emacs.stackexchange.com/questions/32140/python-mode-indentation
(defun jbo-how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.                    
   Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun jbo-infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if        
  ;; neither, we use the current indent-tabs-mode                               
  (let ((space-count (jbo-how-many-region (point-min) (point-max) "^  "))
        (tab-count (jbo-how-many-region (point-min) (point-max) "^\t")))
    (if (> space-count tab-count)
               (progn
                 (message "indent with spaces")
                 (setq indent-tabs-mode nil)
                 )
         (progn
               (message "indent with tabs")
               (setq tab-width 4)
               (setq python-indent-offset 4)
               (setq indent-tabs-mode t)
               ))
       ))

(defun jbo/fix-python-indentation () 
  (add-hook 'python-mode-hook
                       (lambda ()
                         (setq indent-tabs-mode nil)
                         (jbo-infer-indentation-style)))
  )




