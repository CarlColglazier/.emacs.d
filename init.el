;; Welcome to my Emacs config! A lot of this was added ad-hoc over time
;; or copied from places on the web. Feel free to do likewise.
;;     -- Carl


;(server-start) 

;; This contains all the initialization files.
;; Better organized that way.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/")


;; The rest of the file.
(require 'sclang)

(defconst *is-a-mac* (eq system-type 'darwin))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-package)

(require-package 'use-package)

;; Set up use-package
;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;(add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Optional - provides fancier overlays.
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

;; company-lsp integrates company mode completion with lsp-mode.
;; completion-at-point also works out of the box but doesn't support snippets.
(use-package company-lsp
						 :ensure t
						 :commands company-lsp)

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
(provide 'init-flycheck)

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

;; Set up LSP
;(when (require-package 'lsp-mode)
;	(require-package 'lsp-ui)
;	(require-package 'company-lsp)
;	)

(when (maybe-require-package 'company)
;(require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (require-package 'company-tern)
  ;(add-to-list 'company-backends 'company-tern)
  ;(dolist (backend '(company-eclim company-semantic))
  ;  (delq backend company-backends))
  ; TODO: dmininish
  )
 

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

(require-package 'tidal)
(setq tidal-boot-script-path "~/krepovo/tidal/BootTidal.hs")

(setq-default tab-width 2)

(unless (package-installed-p 'inf-ruby)
  (package-install 'inf-ruby))

(require-package 'rust-mode)

(provide 'init)
