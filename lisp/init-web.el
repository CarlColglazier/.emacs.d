(require-package 'web-mode)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

;(add-hook 'web-mode-hook
;          (lambda ()
            ;; short circuit js mode and just do everything in jsx-mode
;            (if (equal web-mode-content-type "javascript")
;                (web-mode-set-content-type "jsx")
;              (message "now set to: %s" web-mode-content-type))))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
	(setq web-mode-block-padding 0)
	(setq web-mode-code-indent-offset 2)
	(setq web-mode-script-padding 0)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(when (maybe-require-package 'tide)
  (add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "js" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
;(flycheck-add-mode 'javascript-eslint 'web-mode)
;(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append))
)

(provide 'init-web)
