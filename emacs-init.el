;; tell emacs to write customizations into a separated file
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror )

;; disable backup files
(setq make-backup-files nil)

;; hide title bar
(add-to-list 'default-frame-alist '(undecorated . t))

;; maximaze window at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; don't show the splash screen
(setq inhibit-startup-message t)

;; don't show the window fringes
(setq set-fringe-mode 0)

;; turn off some unneeded UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; automatically pair parentheses
(electric-pair-mode 1)

;; set font
(set-frame-font "Maple Mono NF 13" nil t)

;; disable line wrapping
(setq-default truncate-lines t)

;; hide the scroll percentage in the mode line
(setq mode-line-percent-position nil)

;; hide line and column number in the mode line
(line-number-mode -1)
(column-number-mode -1)

;; highlight the current line
(global-hl-line-mode 1)

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode 1)

;; disable the kill buffer confirmation
(setq confirm-kill-buffer nil)

;; install packages
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)

(package-initialize)

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-plain-dark t))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map ("C-c p" . projectile-command-map)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))
