(defun jbo/french-unescape-region (start end)
  "Convert escaped French characters to their proper accented forms.
Converts sequences like 'e to é, `e to è, etc."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      ;; Acute accent (')
      (while (re-search-forward "'\\([eEaAiIoOuUyY]\\)" nil t)
        (replace-match
         (pcase (match-string 1)
           ("e" "é") ("E" "É")
           ("a" "á") ("A" "Á")
           ("i" "í") ("I" "Í")
           ("o" "ó") ("O" "Ó")
           ("u" "ú") ("U" "Ú")
           ("y" "ý") ("Y" "Ý"))
         t t))
      
      (goto-char (point-min))
      ;; Grave accent (`)
      (while (re-search-forward "`\\([eEaAiIoOuU]\\)" nil t)
        (replace-match
         (pcase (match-string 1)
           ("e" "è") ("E" "È")
           ("a" "à") ("A" "À")
           ("i" "ì") ("I" "Ì")
           ("o" "ò") ("O" "Ò")
           ("u" "ù") ("U" "Ù"))
         t t))
      
      (goto-char (point-min))
      ;; Circumflex (^)
      (while (re-search-forward "\\^\\([eEaAiIoOuU]\\)" nil t)
        (replace-match
         (pcase (match-string 1)
           ("e" "ê") ("E" "Ê")
           ("a" "â") ("A" "Â")
           ("i" "î") ("I" "Î")
           ("o" "ô") ("O" "Ô")
           ("u" "û") ("U" "Û"))
         t t))
      
      (goto-char (point-min))
      ;; Dieresis/umlaut (")
      (while (re-search-forward "\"\\([eEaAiIoOuUyY]\\)" nil t)
        (replace-match
         (pcase (match-string 1)
           ("e" "ë") ("E" "Ë")
           ("a" "ä") ("A" "Ä")
           ("i" "ï") ("I" "Ï")
           ("o" "ö") ("O" "Ö")
           ("u" "ü") ("U" "Ü")
           ("y" "ÿ") ("Y" "Ÿ"))
         t t))
      
      (goto-char (point-min))
      ;; Cedilla
      (while (re-search-forward ",\\([cC]\\)" nil t)
        (replace-match
         (pcase (match-string 1)
           ("c" "ç") ("C" "Ç"))
         t t)))))

(defun jbo/french-unescape-buffer ()
  "Convert escaped French characters in the entire buffer."
  (interactive)
  (french-unescape-region (point-min) (point-max)))
