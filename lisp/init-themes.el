;(require-package 'gruvbox-theme)
;(setq-default custom-enabled-themes '(gruvbox))
;(load-theme 'gruvbox t)

;; theme
(use-package almost-mono-themes
  :ensure t
  :config
  ;; (load-theme 'almost-mono-black t)
  ;; (load-theme 'almost-mono-gray t)
  ;; (load-theme 'almost-mono-cream t)
  (load-theme 'almost-mono-white t))


;;----------------------------------------------------------------------------
;; Suppress GUI features
;;----------------------------------------------------------------------------
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)

;;----------------------------------------------------------------------------
;; Window size and features
;;----------------------------------------------------------------------------
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
(set-scroll-bar-mode nil))

(provide 'init-themes)
