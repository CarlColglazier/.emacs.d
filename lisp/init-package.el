(require 'package)

;;; Install into separate package dirs for each Emacs version, to prevent bytecode incompatibility
(let ((versioned-package-dir
       (expand-file-name (format "elpa-%s.%s" emacs-major-version emacs-minor-version)
                         user-emacs-directory)))
  (setq package-user-dir versioned-package-dir))


;;; Standard package repositories

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Official MELPA Mirror, in case necessary.
  ;;(add-to-list 'package-archives (cons "melpa-mirror" (concat proto "://www.mirrorservice.org/sites/melpa.org/packages/")) t)
  (if (< emacs-major-version 24)
      ;; For important compatibility libraries like cl-lib
      (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))
    (unless no-ssl
      ;; Force SSL for GNU ELPA
      (setcdr (assoc "gnu" package-archives) "https://elpa.gnu.org/packages/"))))

;;; On-demand installation of packages

(require 'cl-lib)

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (or (package-installed-p package min-version)
      (let* ((known (cdr (assoc package package-archive-contents)))
             (versions (mapcar #'package-desc-version known)))
        (if (cl-find-if (lambda (v) (version-list-<= min-version v)) versions)
            (package-install package)
          (if no-refresh
              (error "No version of %s >= %S is available" package min-version)
            (package-refresh-contents)
            (require-package package min-version t))))))

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
In the event of failure, return nil and print a warning message.
Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to
locate PACKAGE."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (message "Couldn't install optional package `%s': %S" package err)
     nil)))


;;; Fire up package.el

(setq package-enable-at-startup nil)
(package-initialize)


;; package.el updates the saved version of package-selected-packages correctly only
;; after custom-file has been loaded, which is a bug. We work around this by adding
;; the required packages to package-selected-packages after startup is complete.

(defvar carl/required-packages nil)

(defun carl/note-selected-package (oldfun package &rest args)
  "If OLDFUN reports PACKAGE was successfully installed, note it in `carl/required-packages'."
  (let ((available (apply oldfun package args)))
    (prog1 available
      (when (and available (boundp 'package-selected-packages))
        (add-to-list 'carl/required-packages package)))))

(advice-add 'require-package :around 'carl/note-selected-package)

(when (fboundp 'package--save-selected-packages)
  (require-package 'seq)
  (add-hook 'after-init-hook
            (lambda () (package--save-selected-packages
                   (seq-uniq (append carl/required-packages package-selected-packages))))))

(when (maybe-require-package 'fullframe)
  (fullframe list-packages quit-window))

(provide 'init-package)
