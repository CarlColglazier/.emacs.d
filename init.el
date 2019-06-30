;; Welcome to my Emacs config! A lot of this was added ad-hoc over time
;; or copied from places on the web. Feel free to do likewise.
;;     -- Carl

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

(when *is-a-mac*
  (setq ispell-program-name "/usr/local/bin/aspell"))
(when (not *is-a-mac*)
  (setq ispell-program-name "/usr/bin/aspell"))

(require 'init-themes)
(require 'init-osx)
(require 'init-org)
(require 'init-projectile)
(require 'init-web)

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

(require-package 'exec-path-from-shell)

(when (or (memq window-system '(mac ns x))
          (unless (memq system-type '(ms-dos windows-nt))
            (daemonp)))
  (exec-path-from-shell-initialize))

;; Autoload files.
(global-auto-revert-mode t)

;; Show the column number
(column-number-mode)

(set-face-attribute 'default nil :height 140)

(when (member "DejaVu Sans Mono" (font-family-list))
  (set-default-font "DejaVu Sans Mono"))

(maybe-require-package 'ox-hugo)
(when (maybe-require-package 'magit)
  (global-set-key (kbd "C-c g") 'magit-status))

(setq browse-url-browser-function 'eww-browse-url)

(require-package 'company)
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-tern)

(when (require-package 'go-mode)
  (autoload 'go-mode "go-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

  (defun go-mode-setup ()
    (add-hook 'before-save-hook 'gofmt-before-save)
    (define-key (current-local-map) "\C-c\C-c" 'compile)
    )

  (add-hook 'go-mode-hook 'go-mode-setup)
  )

(maybe-require-package 'elfeed)

(provide 'init)
