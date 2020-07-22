;; Welcome to my Emacs config! A lot of this was added ad-hoc over time
;; or copied from places on the web. Feel free to do likewise.
;;		 -- Carl

;(server-start)

;; This contains all the initialization files.
;; Better organized that way.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/")

;; The rest of the file.
;;(require 'sclang)

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

(when (>= emacs-major-version 26)
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
		(setq company-minimum-prefix-length 2))

	;; company-lsp integrates company mode completion with lsp-mode.
	;; completion-at-point also works out of the box but doesn't support snippets.
	(use-package company-lsp
						 :ensure t
						 :commands company-lsp)
	)

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

(setq backup-directory-alist
			`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
			`((".*" ,temporary-file-directory t)))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
	(load custom-file))

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

(when (maybe-require-package 'company)
	(add-hook 'after-init-hook 'global-company-mode)
	(require-package 'company-tern))
 

(when (require-package 'go-mode)
	(autoload 'go-mode "go-mode" nil t)
	(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

	(defun go-mode-setup ()
		(add-hook 'before-save-hook 'gofmt-before-save)
		(define-key (current-local-map) "\C-c\C-c" 'compile)
		)

	(add-hook 'go-mode-hook 'go-mode-setup)
	)

(require-package 'tidal)
(setq tidal-boot-script-path "~/krepovo/tidal/BootTidal.hs")

(setq org-src-preserve-indentation t)

;; tabs
;; https://dougie.io/emacs/indentation/
; START TABS CONFIG
;; Create a variable for our preferred tab width
(setq custom-tab-width 2)

;; Two callable functions for enabling/disabling tabs in Emacs
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs ()
	(local-set-key (kbd "TAB") 'tab-to-tab-stop)
	(setq indent-tabs-mode t)
	(setq tab-width custom-tab-width))

;; Hooks to Enable Tabs
(add-hook 'prog-mode-hook 'enable-tabs)
;; Hooks to Disable Tabs
(add-hook 'lisp-mode-hook 'disable-tabs)
(add-hook 'emacs-lisp-mode-hook 'disable-tabs)

(add-hook 'python-mode-hook
					(lambda ()
						(setq indent-tabs-mode t)
						(setq python-indent 2)
						(setq python-tab-width 4))
						(tabify (point-min) (point-max)))

;; Language-Specific Tweaks
(setq-default python-indent-offset custom-tab-width) ;; Python
(setq-default js-indent-level custom-tab-width)			 ;; Javascript

;; Making electric-indent behave sanely
(setq-default electric-indent-inhibit t)

;; Make the backspace properly erase the tab instead of
;; removing 1 space at a time.
(setq backward-delete-char-untabify-method 'hungry)

;; (OPTIONAL) Shift width for evil-mode users
;; For the vim-like motions of ">>" and "<<".
;(setq-default evil-shift-width custom-tab-width)

;; WARNING: This will change your life
;; (OPTIONAL) Visualize tabs as a pipe character - "|"
;; This will also show trailing characters as they are useful to spot.
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
	'((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
(global-whitespace-mode) ; Enable whitespace mode everywhere
; END TABS CONFIG

;; weird menu bar bug on KDE
; https://www.birkelbach.eu/post/dealing-with-empty-menus-in-gnu-emacs/
(menu-bar-mode -1)
(menu-bar-mode 1)

(provide 'init)
