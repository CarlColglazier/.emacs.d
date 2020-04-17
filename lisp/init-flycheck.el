;;; init-flycheck.el --- Flycheck configuration.
;;; Commentary:
;;; Code:

(when (require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
  (when (maybe-require-package 'flycheck-color-mode-line)
    (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)))

(when (maybe-require-package 'flycheck)
  (require-package 'flycheck-package)
  (after-load 'flycheck
    (after-load 'elisp-mode
      (flycheck-package-setup))))


(provide 'init-flycheck)
