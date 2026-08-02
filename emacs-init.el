;; hide title bar
(add-to-list 'default-frame-alist '(undecorated . t))

;; maximize window at startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; don't show the splash screen
(setq inhibit-startup-message t)

;; turn off some unneeded UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

;; disable line wrapping
(setq-default truncate-lines t)

;; automatically pair parentheses
(electric-pair-mode t)

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode t)

;; make C-x C-b act as C-x b everywhere
(keymap-set key-translation-map "C-x C-b" "C-x b")

;; built-in LSP client for code completion, navigation and diagnostics
(use-package eglot
  :ensure nil
  :hook ((php-ts-mode . eglot-ensure)
         (js-ts-mode  . eglot-ensure))
  :bind (:map eglot-mode-map
         ("C-c r"   . eglot-rename)
         ("C-c C-a" . eglot-code-actions)
         ("C-c f"   . eglot-format)
         ("C-c d"   . eldoc)
         ("M-."     . xref-find-definitions)
         ("M-,"     . xref-go-back)
         ("M-?"     . xref-find-references))
  :config
  (add-to-list 'eglot-server-programs '(php-ts-mode . ("npx" "intelephense" "--stdio")))
  ;; increase timeout for slow servers
  (setq eglot-connect-timeout 30))

;; open php/js files in tree-sitter major modes
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))

;; auto-install php-ts-mode's grammars (php, phpdoc, html, javascript, jsdoc,
;; css) when missing, using the mode's own pinned/compatible versions
(with-eval-after-load 'php-ts-mode
  (let ((treesit-language-source-alist php-ts-mode--language-source-alist))
    (dolist (src php-ts-mode--language-source-alist)
      (unless (treesit-language-available-p (car src))
        (condition-case err
            (progn
              (message "Installing tree-sitter grammar: %s" (car src))
              (treesit-install-language-grammar (car src)))
          (error (message "Failed to install grammar %s: %s" (car src) err)))))))

;; set font
(set-frame-font "Maple Mono NF 12" nil t)

;; make the fringes use the same background as the buffer
(setq modus-themes-common-palette-overrides
      '((fringe unspecified)))

;; load theme
(load-theme 'modus-vivendi-tinted t)

;; highlight the current line
(global-hl-line-mode t)

;; custom mode line
(setq-default mode-line-format
              '("%e" mode-line-front-space "%b" mode-line-format-right-align "%l:%c" "  "))

;; increase the mode-line height by padding it vertically
(dolist (face '(mode-line mode-line-active mode-line-inactive))
  (set-face-attribute face nil
                      :box (list :line-width '(1 . 4)
                                 :color (face-attribute 'mode-line :background nil t))))

;; install packages
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)

(package-initialize)

;; refresh the archive cache on a fresh machine so :ensure works
(unless package-archive-contents
  (package-refresh-contents))

;; apply per-project coding styles from .editorconfig files
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode t))

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

;; vertical completion UI for the minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; interactive buffer/file selection in the minibuffer
(ido-mode 1)
(setq ido-enable-flex-matching t)

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
