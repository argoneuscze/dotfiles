;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; UI
(use-package dracula-theme
  :config
  (load-theme 'dracula t))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-icon t))

;; Core
(use-package emacs
  :custom
  (inhibit-x-resources t)
  (inhibit-startup-screen t)
  (select-enable-clipboard t)
  (auto-save-default nil)
  (create-lockfiles nil)
  (make-backup-files nil)
  (scroll-margin 10)
  (scroll-step 1)
  (scroll-conservatively 10000)
  (pixel-scroll-precision-use-momentum nil)
  (use-short-answers t)
  (ring-bell-function 'ignore)
  (tab-always-indent 'complete)
  (indent-tabs-mode nil)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (enable-recursive-minibuffers t)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  :init
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  :config
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (set-face-attribute 'default nil :font "Hack Nerd Font" :height 115)
  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)
  (global-display-line-numbers-mode t)
  (pixel-scroll-precision-mode t)
  (column-number-mode t)
  (savehist-mode t)
  (save-place-mode t)
  (recentf-mode t)
  (which-key-mode t))

(use-package eldoc
  :custom
  (eldoc-idle-delay 0)
  (eldoc-documentation-strategy 'eldoc-documentation-compose)
  (eldoc-echo-area-use-multiline-p t)
  :init
  (global-eldoc-mode))

;; Editor
(use-package vundo)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-max-width 120)
  (corfu-popupinfo-delay 0.2)
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref))

;; Git
(use-package magit)

;; LSP
(use-package flymake
  :hook
  (prog-mode . flymake-mode))

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-suggest-server-download nil)
  :hook
  ((lsp-mode . lsp-enable-which-key-integration)
   (rust-ts-mode . lsp-deferred))
  :commands lsp)

(use-package lsp-pyright
  :custom
  (lsp-pyright-langserver-command "basedpyright")
  :hook
  (python-base-mode . (lambda ()
			(require 'lsp-pyright)
			(lsp-deferred))))

;; General
(use-package general
  :config
  (general-create-definer my-leader-def
    :prefix "SPC")
  (general-create-definer my-local-leader-def
    :prefix ",")
  (general-def 'normal
    "U" 'vundo)
  (general-def 'normal prog-mode-map
    "]d" 'flymake-goto-next-error
    "[d" 'flymake-goto-prev-error
    "K" 'lsp-describe-thing-at-point)
  (general-def 'normal emacs-lisp-mode-map
    "K" 'describe-symbol)
  (my-leader-def 'normal
    ;; Quick access
    ":" 'execute-extended-command
    "." 'find-file
    "SPC" 'project-find-file
    "," 'consult-buffer
    "/" 'consult-ripgrep
    "-" 'dired-jump
    ;; Find
    "f" (cons "Find" (make-sparse-keymap))
    "ff" 'find-file
    "fs" 'save-buffer
    "fr" 'consult-recent-file
    ;; Search
    "s" (cons "Search" (make-sparse-keymap))
    "ss" 'consult-line
    "sf" 'consult-find
    "sg" 'consult-ripgrep
    ;; Project
    "p" (cons "Project" (make-sparse-keymap))
    "pp" 'project-switch-project
    "pf" 'project-find-file
    ;; Buffer
    "b" (cons "Buffer" (make-sparse-keymap))
    "bb" 'consult-buffer
    "bi" 'ibuffer
    "bk" 'kill-current-buffer
    ;; Dired
    "d" (cons "Dired" (make-sparse-keymap))
    "dd" 'dired
    "dj" 'dired-jump
    ;; Git
    "g"  (cons "Git" (make-sparse-keymap))
    "gg" 'magit-status
    ;; Help
    "h" (cons "Help" (make-sparse-keymap))
    "hm" 'describe-mode
    "hf" 'describe-function
    "hv" 'describe-variable
    "hk" 'describe-key))

;; Evil mode
(use-package evil
  :custom
  (evil-undo-system 'undo-redo)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
  
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

