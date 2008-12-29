
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.32")
 )
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;(require 'ecb)
;; ============= ECB variables ================================
;;(setq ecb-auto-activate t)
;;(setq ecb-source-path (quote (("/work/aris/views/" "Views") ("/work/aris/km/" "KM"))))
;;(setq ecb-tip-of-the-day nil)

;; =========== Alterantes for M-x =============================
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; =========== Remove Toolbars/scrollbars =====================
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; ========= Uniquify buffer names by reversing paths =========
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)

;; ======== Move temp files out of working directories ========
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
 (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; ================== Set up php-mode =======================
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.install\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.profile\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.test\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.theme\\'" . php-mode))
(defun my-php-mode-hook ()
  (setq tab-width 2)
  (setq-default indent-tabs-mode nil)
  (setq c-basic-offset tab-width)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  )
(add-hook 'php-mode-hook 'my-php-mode-hook)


;; ================== Set a color scheme ====================
(require 'color-theme)
(color-theme-charcoal-black)

;; ================== Customize cc mode =====================
(require 'cc-mode)

;; Delete all whitespace around cursor
(c-toggle-hungry-state 1)

;; Change c-style offsets for indentation

;; Set tab width
(defun my-c-mode-common-hook ()
  (setq tab-width 4)
  (setq c-basic-offset tab-width)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  ;;(c-set-offset 'substatement-open 0)
  ;;(c-set-offset 'case-label '+)
  ;;(c-set-offset 'arglist-cont-nonempty '+)
  ;;(c-set-offset 'topmost-intro-cont '+)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;; =================== Interactive Mode =====================
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
