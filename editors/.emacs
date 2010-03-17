;; Emacs Load Path
(progn (cd "~/emacs") (normal-top-level-add-subdirs-to-load-path))

;; This option is for macs to have the meta key from command
(setq mac-option-modifier 'meta)
(setq mac-command-notifier 'hyper)

;; MAC FONTS
(set-default-font "-*-monaco-medium-r-*-*-11-*-*-*-*-*-*-*")
;(set-default-font "-*-atari-medium-r-*-*-8-*-*-*-*-*-*-*")

;; Emacs Path
(setenv "PATH" (concat (getenv "PATH") ":" "/usr/local/mysql/bin" ":" "/opt/local/bin"))
(setq exec-path (append exec-path '("/opt/local/bin")))

;; Visible Bell
(setq visible-bell 1)

;; Parenthesis Matching
(show-paren-mode 1)

;; Programming in C
;;(setq c-set-style 'stroustrup)
(setq c-set-style 'gnu)

;; NEW
(global-font-lock-mode t)
(windmove-default-keybindings)
(setq use-file-dialog nil)
;(fset 'yes-or-no-p 'y-or-no-p)
(setq transient-mark-mode t)
(setq line-number-mode t)
(setq column-number-mode t)

;; Remove GUI stuff
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

;;
;; GIT
;;
(require 'git)

;;
;; YASNIPPET
;;
(require 'yasnippet-bundle)


;;
;; Color Theme plugin
;;
(require 'color-theme)
(color-theme-initialize)
(color-theme-taming-mr-arneson)

;;
;; Scala
;;
(require 'scala-mode-auto)

; Scala Mode hooks
(defun me-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook 'me-turn-off-indent-tabs-mode)


;;
;; File Types for different modes
;;
;(add-to-list 'auto-mode-alist '(""\\.scala\\'" . scala-mode))

;;
;; TRAMP Plugin
;;
(require 'tramp)
(setq tramp-default-method "ssh")

;;
;; Backups
;;
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/emacs/saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

;(setq make-backup-files nil) ; Get Rid of Backups

;;
; Force backups, added hook for before save
;;
(setq version-control t ;; Use version numbers for backups
      kept-new-versions 16 ;; Number of newest versions to keep
      kept-old-versions 2 ;; Number of oldest versions to keep
      delete-old-versions t ;; Ask to delete excess backup versions?
      backup-by-copying-when-linked t) ;; Copy linked files, don't rename.
(defun force-backup-of-buffer ()
  (let ((buffer-backed-up nil))
    (backup-buffer)))
(add-hook 'before-save-hook  'force-backup-of-buffer)

;;
; Tramp like backups left on remote server, no good, let's clean those up
;;
(add-to-list 'backup-directory-alist
	     (cons "." "~/emacs/saves/"))
(setq tramp-backup-directory-alist backup-directory-alist)

;;
; Delete Backups older than a week
;;
;; (message "Deleting old backup files...")
;; (let ((week (* 60 60 24 7))
;;       (current (float-time (current-time))))
;;   (dolist (file (directory-files temporary-file-directory t))
;;     (when (and (backup-file-name-p file)
;;                (> (- current (float-time (fifth (file-attributes file))))
;;                   week))
;;       (message file)
;;       (delete-file file))))