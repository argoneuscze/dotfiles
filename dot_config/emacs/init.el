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
  (read-process-output-max (* 1024 1024))
  (gc-cons-threshold (* 100 1024 1024))
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
  (eldoc-echo-area-use-multiline-p 3)
  (eldoc-echo-area-prefer-doc-buffer t)
  (eldoc-echo-area-display-truncation-message nil)
  :init
  (global-eldoc-mode))

;; Editor
(use-package vundo)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-preview-current nil)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-max-width 120)
  (corfu-popupinfo-delay 0.2)
  (corfu-popupinfo-max-width 120)
  (corfu-popupinfo-max-height 30)
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("C-f" . corfu-popupinfo-scroll-up)
        ("C-b" . corfu-popupinfo-scroll-down))
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

(use-package yasnippet
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package yasnippet-capf
  :after cape
  :config
  (add-hook 'completion-at-point-functions #'yasnippet-capf))

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-suggest-server-download nil)
  (lsp-completion-provider :none)
  (lsp-diagnostics-provider :flymake)
  (lsp-log-io nil)
  (lsp-idle-delay 0.5)
  (lsp-enable-folding nil)
  (lsp-keep-workspace-alive nil)
  (lsp-enable-snippet t)
  (lsp-lens-enable t)
  (lsp-eldoc-enable-hover t)
  (lsp-eldoc-render-all nil)
  (lsp-signature-render-documentation nil)
  (lsp-headerline-breadcrumb-enable t)
  :hook
  ((lsp-mode . lsp-enable-which-key-integration)
   (lsp-completion-mode . my/lsp-corfu-setup)
   (rust-ts-mode . lsp-deferred))
  :commands lsp
  :config
  (defun my/lsp-corfu-setup ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'lsp-completion-at-point
                       #'yasnippet-capf)
                      #'cape-file
                      #'cape-dabbrev))))

(use-package flymake-ruff
  :hook
  (python-mode-hook . flymake-ruff-load))

(use-package lsp-pyright
  :custom
  (lsp-pyright-langserver-command "basedpyright")
  :hook
  (python-base-mode . (lambda ()
			(require 'lsp-pyright)
			(lsp-deferred))))

;; Formatting
(use-package apheleia
  :preface
  (defun my/format-buffer-smart ()
    "Format buffer - Apheleia first, fallback to LSP."
    (interactive)
    (let ((has-apheleia
           (and (bound-and-true-p apheleia-mode-alist)
                (catch 'found
                  (dolist (pair apheleia-mode-alist)
                    (when (derived-mode-p (car pair))
                      (throw 'found t)))
                  nil)))
          (lsp-can-format
           (and (bound-and-true-p lsp-mode)
                (fboundp 'lsp-feature?)
                (lsp-feature? "textDocument/formatting"))))
      (cond
       (has-apheleia
        (call-interactively #'apheleia-format-buffer)
        (message "Formatted via Apheleia."))
       (lsp-can-format
        (lsp-format-buffer)
        (message "Formatted via LSP."))
       (t
        (message "No formatter available.")))))
  :config
  (setq apheleia-mode-alist nil)
  (setf (alist-get 'emacs-lisp-mode apheleia-mode-alist) '(lisp-indent))
  (setf (alist-get 'python-base-mode apheleia-mode-alist) '(ruff-isort ruff)))

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
    ;; Code
    "c" (cons "Code" (make-sparse-keymap))
    "cx" 'consult-flymake
    "cf" 'my/format-buffer-smart
    ;; Toggle
    "t" (cons "Toggle" (make-sparse-keymap))
    "th" 'lsp-inlay-hints-mode
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

