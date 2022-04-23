(maybe-require-package 'olivetti)

(when (>= emacs-major-version 26)
  (when (require-package 'ob-async)
    (require 'ob-async)))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Dropbox/notes"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(use-package ox-latex
  :config
(add-to-list 'org-latex-classes
  '("chicago"
    "\\documentclass{turabian-researchpaper}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
  '("memoir"
    "\\documentclass{memoir}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(add-to-list 'org-latex-classes
   '("acm"
   "\\documentclass[authorversion=true, nonacm=true, authordraft=false, screen]{acmart}
   [NO-DEFAULT-PACKAGES]
   [EXTRA]"
   ("\\section{%s}" . "\\section*{%s}")
   ("\\subsection{%s}" . "\\subsection*{%s}")
   ("\\paragraph{%s}" . "\\paragraph*{%s}")
   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
   )
)

(add-to-list 'org-latex-classes
             '("tufte-handout"
               "\\documentclass{tufte-handout}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))
)
;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   ;(jupyter . t)
 ))

;; https://emacs.stackexchange.com/questions/53383/python-shell-warning-about-readline-and-completion
;(setq python-shell-completion-native-enable nil)
;(setq org-export-allow-bind-keywords t)

(provide 'init-org)
