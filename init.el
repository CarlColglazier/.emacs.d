;; Welcome to my Emacs config! A lot of this was added ad-hoc over time
;; or copied from places on the web. Feel free to do likewise.
;;     -- Carl Colglazier

;; This contains all the initialization files.
;; Better organized that way.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *is-a-mac* (eq system-type 'darwin))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-package)

(if (fboundp 'with-eval-after-load)
    (defalias 'after-load 'with-eval-after-load)
  (defmacro after-load (feature &rest body)
    "After FEATURE is loaded, evaluate BODY."
    (declare (indent defun))
    `(eval-after-load ,feature
'(progn ,@body))))

(setq ispell-program-name "/usr/local/bin/aspell")

(require 'init-themes)
(require 'init-osx)
(require 'init-org)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark)) ;; assuming you are using a dark theme
(setq ns-use-proxy-icon nil)
(setq frame-title-format nil)

(setq backup-directory-alist
`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
`((".*" ,temporary-file-directory t)))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
(load custom-file))

(provide 'init)
