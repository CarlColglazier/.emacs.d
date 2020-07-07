(maybe-require-package 'olivetti)

(require 'ob-async)

(when (require-package 'org-ref)
	(setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib"))
	;; see org-ref for use of these variables
	(setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org"
				org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
				org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs/")
	;(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
	(require 'org-ref)
;	(require 'org-ref-ox-hugo)
	)

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(add-to-list 'org-latex-classes
             '("chicago"
               "\\documentclass{turabian-researchpaper}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
						 '("acm"
							 "\\documentclass{acmart}")
						 )
(add-to-list 'org-latex-classes
						 '("tufte-handout"
							 "\\documentclass{tufte-handout}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(define-minor-mode prose-mode
  "Set up a buffer for prose editing.
This enables or modifies a number of settings so that the
experience of editing prose is a little more like that of a
typical word processor."
  nil " Prose" nil
  (if prose-mode
      (progn
        (when (fboundp 'olivetti-mode)
          (olivetti-mode 1))
        (setq truncate-lines nil)
        (setq word-wrap t)
        (setq cursor-type 'bar)
        (when (eq major-mode 'org)
          (kill-local-variable 'buffer-face-mode-face))
        (buffer-face-mode 1)
        ;;(delete-selection-mode 1)
        (setq-local blink-cursor-interval 0.6)
        (setq-local show-trailing-whitespace nil)
        (setq-local line-spacing 0.2)
        (setq-local electric-pair-mode nil)
        (ignore-errors (flyspell-mode 1))
        (visual-line-mode 1))
    (kill-local-variable 'truncate-lines)
    (kill-local-variable 'word-wrap)
    (kill-local-variable 'cursor-type)
    (kill-local-variable 'blink-cursor-interval)
    (kill-local-variable 'show-trailing-whitespace)
    (kill-local-variable 'line-spacing)
    (kill-local-variable 'electric-pair-mode)
    (buffer-face-mode -1)
    ;; (delete-selection-mode -1)
    (flyspell-mode -1)
    (visual-line-mode -1)
    (when (fboundp 'olivetti-mode)
      (olivetti-mode 0))))

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
	 (shell . t)
   (ipython . t)
 ))

;; https://emacs.stackexchange.com/questions/53383/python-shell-warning-about-readline-and-completion
(setq python-shell-completion-native-enable nil)

(setq org-export-allow-bind-keywords t)

(provide 'init-org)
