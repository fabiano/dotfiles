;; hide title bar
(add-to-list 'default-frame-alist '(undecorated . t))

;; maximize window at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; don't show the splash screen
(setq inhibit-startup-message t)

;; turn off menu bar
(menu-bar-mode -1)

;; turn off toolbar
(tool-bar-mode -1)

;; turn off scrollbar
(scroll-bar-mode -1)

;; custom mode line
(setq-default mode-line-format
              '("%e" mode-line-front-space "%b" mode-line-format-right-align "%l:%c" "  "))

;; increase the mode line height by padding it vertically
(dolist (face '(mode-line mode-line-active mode-line-inactive))
  (set-face-attribute face nil
                      :box (list :line-width '(1 . 4)
                                 :color (face-attribute 'mode-line :background nil t))))

;; turn off bell sound
(setq ring-bell-function 'ignore)

;; tell emacs to write customizations into a separated file
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

;; disable backup files
(setq make-backup-files nil)

;; disable auto save
(setq auto-save-default nil)

;; disable lock files (.#file symlinks)
(setq create-lockfiles nil)

;; disable the kill buffer confirmation
(setq confirm-kill-buffer nil)

;; automatically reload buffers when the file changes on disk
(global-auto-revert-mode t)

;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; configure line wrapping
(setq-default truncate-lines nil)

(add-hook 'prog-mode-hook
          (lambda () (setq truncate-lines t)))

;; highlight the current line
(global-hl-line-mode t)

;; automatically pair parentheses
(electric-pair-mode t)

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode t)

;; make C-x C-b act as C-x b everywhere
(keymap-set key-translation-map "C-x C-b" "C-x b")

;; make C-p act as C-x p f
(keymap-set key-translation-map "C-p" "C-x p f")

;; when cycling buffers, only visit buffers that are visiting a real file
;; (skips *Messages*, EGLOT, *scratch*, Dired, terminals, help, etc.)
(setq switch-to-prev-buffer-skip
      (lambda (_window buffer _bury-or-kill)
        (not (buffer-file-name buffer))))

;; cycle buffers with Ctrl+Tab / Ctrl+Shift+Tab
(keymap-global-set "C-<tab>" #'next-buffer)
(keymap-global-set "C-<iso-lefttab>" #'previous-buffer)
(keymap-global-set "C-S-<iso-lefttab>" #'previous-buffer)

;; set font
(set-frame-font "Maple Mono NF 12" nil t)

;; make the fringes use the same background as the buffer
(setq modus-themes-common-palette-overrides
      '((fringe unspecified)))

;; set theme
(load-theme 'modus-vivendi-tinted t)

;; interactive buffer/file selection in the minibuffer
(ido-mode 1)
(setq ido-enable-flex-matching t)

;; install packages
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)

(package-initialize)

;; refresh the archive cache on a fresh machine so :ensure works
(unless package-archive-contents
  (package-refresh-contents))

;; apply per-project coding styles from .editorconfig files
(editorconfig-mode t)

;; render programming ligatures (e.g. =>, ->, !=) with the font
(use-package ligature
  :ensure t
  :init
  (global-ligature-mode t)
  :config
  (ligature-set-ligatures
   'prog-mode
   '("www" "--" "---" "==" "===" "!=" "!==" "=!=" "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!" "??" "???" "?:" "?." "?="
     "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>" "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####" "#{" "#[" "]#" "#(" "#?" "#_"
     "#_(" "#:" "#!" "#=" "^=" "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--" "-->" "->" "->>" "<<-" "<-" "<=<"
     "=<<" "<<=" "<==" "<=>" "<==>" "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|" "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>"
     "~~" "~~>" "~>" "~-" "-~" "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||" "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?"
     "::" ":::" ":=" "::=" ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__")))

;; vertical completion ui for the minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; show available keybindings in a popup as you type a prefix
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; completion style that splits what you type into space-separated components
;; and then matches candidates that satisfy all components in any order
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; enable rich annotations on the minibuffer completions
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; text and code completion framework
(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; markdown renderer used by eglot to fontify lsp hover/eldoc docs
(use-package markdown-mode
  :ensure t)

;; terminal emulator
(use-package ghostel
  :ensure t
  :bind (("C-x m" . ghostel)
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t))

;; php support (don't forget to run M-x php-ts-mode-install-parsers)
(use-package php-ts-mode
  :ensure t)

;; clojure support
(use-package clojure-ts-mode
  :ensure t
  :config
  ;; recognize folders with a deps.edn file as a project
  ;; so eglot analyzes the whole project (and returns docs)
  (add-to-list 'project-vc-extra-root-markers
               '"deps.edn"))

(use-package cider
  :ensure t
  :hook ((clojure-ts-mode . cider-mode)))

;; configure built-in lsp
(use-package eglot
  :ensure nil
  :hook ((clojure-ts-mode . eglot-ensure)
         (php-ts-mode     . eglot-ensure)
         (js-ts-mode      . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c r"   . eglot-rename)
              ("C-c C-a" . eglot-code-actions)
              ("C-c f"   . eglot-format)
              ("C-c d"   . eldoc)
              ("M-."     . xref-find-definitions)
              ("M-,"     . xref-go-back)
              ("M-?"     . xref-find-references))
  :config
  ;; increase timeout for slow servers
  (setq eglot-connect-timeout 30)
  ;; combine all eldoc sources instead of showing only the first one that answers
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  ;; use npx to start intelephense
  (add-to-list 'eglot-server-programs
               '(php-ts-mode . ("npx" "intelephense" "--stdio")))
  ;; use npx to start the typescript language server
  ;; NOTE: the (mode :language-id "javascript") form is required. Eglot would
  ;; otherwise derive the language id "js" from the mode name, and the language
  ;; server ignores files opened as "js"
  (add-to-list 'eglot-server-programs
               '((js-ts-mode :language-id "javascript") . ("npx" "@vtsls/language-server" "--stdio"))))

;; open js files in tree-sitter major mode
(add-to-list 'major-mode-remap-alist
             '(javascript-mode . js-ts-mode))
