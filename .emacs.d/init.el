
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

;; =============== Load Path ==================================
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/")
	   (default-directory my-lisp-dir))
      (setq load-path (cons my-lisp-dir load-path))
      (normal-top-level-add-subdirs-to-load-path)))

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
 (concat "~/.emacs_autosaves/" (user-login-name) "/"))

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
(add-to-list 'auto-mode-alist '("\\.lib\\'" . php-mode))
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


;; =================== Find and Grep ========================
(autoload 'igrep "igrep"
  "*Run `grep` PROGRAM to match REGEX in FILES..." t)
(autoload 'igrep-find "igrep"
  "*Run `grep` via `find`..." t)
(autoload 'igrep-visited-files "igrep"
  "*Run `grep` ... on all visited files." t)
(autoload 'dired-do-igrep "igrep"
  "*Run `grep` on the marked (or next prefix ARG) files." t)
(autoload 'dired-do-igrep-find "igrep"
  "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
(autoload 'Buffer-menu-igrep "igrep"
  "*Run `grep` on the files visited in buffers marked with '>'." t)
(autoload 'igrep-insinuate "igrep"
  "Define `grep' aliases for the corresponding `igrep' commands." t)

;; make searches case insensitive by default
(setq igrep-options "-i")
(setq igrep-case-fold-search t)

;; Search in subdirectories
(setq igrep-find t)

;; Ignore svn dirs
(setq igrep-find-prune-clause 
      (format "-type d %s -name RCS -o -name CVS -o -name SCCS -o -name .svn %s "
	      (shell-quote-argument "(")
	      (shell-quote-argument ")")))
(setq igrep-find-file-clause
      (format "-type f %s -name %s %s -name %s %s -name %s %s -name %s %s -name %s " ; -type l
              (shell-quote-argument "!")
              (shell-quote-argument "*~")	; Emacs backup
              (shell-quote-argument "!")
              (shell-quote-argument "*,v")	; RCS file
              (shell-quote-argument "!")
              (shell-quote-argument "s.*")	; SCCS file
              (shell-quote-argument "!")
              (shell-quote-argument ".#*")	; CVS file
              (shell-quote-argument "!")
              (shell-quote-argument "*.sql*")	; SQL file
              )
)

;; =================== TRAMP ==============================
(require 'tramp)
;(setq tramp-default-method "ssh")
(setq tramp-debug-buffer t)
(setq tramp-verbose 10)
(add-to-list 'tramp-default-method-alist '("\\`arisappdev3\\.aris\\.wgenhq\\.net\\'" "\\'apache\\'" "sudo"))
(add-to-list 'tramp-default-proxies-alist
;	     '("\\`arisappdev3\\.aris\\.wgenhq\\.net\\'" "\\`apache\\'" "/ssh:cpennington@%h:"))
	     '("\\`arisappdev3\\.aris\\.wgenhq\\.net\\'" "\\`apache\\'" "/ssh:egoodman@%h:"))

;; ================== FONTS =================================
(add-to-list 'default-frame-alist '(font . "Inconsolata"))

;; =================== Scala ================================

(add-to-list 'load-path "/work/scala/scala-2.7.5.final/misc/scala-tool-support/emacs")
(require 'scala-mode-auto)
