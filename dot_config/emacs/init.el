;; Packages
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Custom functions
(defun my/kill-other-buffers ()
  "Kill all buffers except the protected buffers and the current one."
  (interactive)
  (let ((protected '("*scratch*" "*Messages*"))
        (current (current-buffer))
        (killed-count 0))
    (dolist (buf (buffer-list))
      (let ((name (buffer-name buf)))
        (unless (or (eq buf current)
                    (string-prefix-p " " name)
                    (member name protected))
          (kill-buffer buf)
          (setq killed-count (1+ killed-count))))
      (message "Killed %d buffer(s)." killed-count))))

(defun my/eshell-other-window ()
  "Opens Eshell in another window."
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (eshell))

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
  :straight nil
  :custom
  (read-process-output-max (* 1024 1024))
  (gc-cons-threshold (* 100 1024 1024))
  (inhibit-x-resources t)
  (inhibit-startup-screen t)
  (nerd-icons-font-family "Hack Nerd Font")
  (select-enable-clipboard t)
  (auto-save-default nil)
  (create-lockfiles nil)
  (make-backup-files nil)
  (tab-bar-show 1)
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
  (pixel-scroll-precision-mode t)
  (column-number-mode t)
  (tab-bar-history-mode t)
  (savehist-mode t)
  (save-place-mode t)
  (recentf-mode t)
  (which-key-mode t)
  :hook
  (prog-mode . display-line-numbers-mode)
  (text-mode . display-line-numbers-mode))

(use-package eldoc
  :straight nil
  :custom
  (eldoc-idle-delay 0.1)
  (eldoc-documentation-strategy 'eldoc-documentation-compose)
  (eldoc-echo-area-use-multiline-p 3)
  (eldoc-echo-area-prefer-doc-buffer t)
  (eldoc-echo-area-display-truncation-message nil)
  :init
  (global-eldoc-mode))

(use-package exec-path-from-shell
  :if (not (eq system-type 'windows-nt))
  :custom
  (exec-path-from-shell-variables '("PATH" "MANPATH"))
  :config
  (when (or (daemonp) (display-graphic-p))
    (exec-path-from-shell-initialize)))

;; Editor
(use-package treesit-auto
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

(use-package vundo
  :commands vundo)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.3)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-preview-current nil)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-max-width 120)
  (corfu-popupinfo-delay 0.3)
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

(use-package embark
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  :commands (embark-act embark-dwim embark-bindings))

(use-package embark-consult
  :after (embark consult))

(use-package paredit
  :hook
  (emacs-lisp-mode lisp-mode))

;; Dired
(use-package dired
  :straight nil
  :custom
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  (setq dired-listing-switches
        (if (eq system-type 'gnu/linux)
            "-agho --group-directories-first")))

;; Git
(use-package magit
  :custom
  (magit-format-file-function #'magit-format-file-nerd-icons)
  :commands (magit-status magit-blame))

;; LSP
(use-package flymake
  :straight nil
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
   (bash-ts-mode . lsp-deferred)
   (rust-ts-mode . lsp-deferred)
   (go-ts-mode . lsp-deferred)
   (json-ts-mode . lsp-deferred)
   (yaml-ts-mode . lsp-deferred)
   (toml-ts-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
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

(use-package terraform-mode
  :hook
  (terraform-mode . lsp-deferred))

;; Formatting
(use-package apheleia
  :custom
  (apheleia-mode-alist '((emacs-lisp-mode . (lisp-indent))
                         (python-base-mode . (ruff-isort ruff))
                         (go-ts-mode . (goimports gofumpt))
                         (json-ts-mode . prettier-json)
                         (yaml-ts-mode . prettier-yaml)))
  :preface
  (defun my/format-buffer-smart ()
    "Format buffer - Apheleia first, fallback to LSP."
    (interactive)
    (let ((apheleia-fmt
           (and (bound-and-true-p apheleia-mode-alist)
                (seq-some (lambda (pair)
                            (when (derived-mode-p (car pair))
                              (cdr pair)))
                          apheleia-mode-alist)))
          (lsp-can-format
           (and (bound-and-true-p lsp-managed-mode)
                (fboundp 'lsp-feature?)
                (lsp-feature? "textDocument/formatting"))))
      (cond
       (apheleia-fmt
        (apheleia-format-buffer
         apheleia-fmt
         (lambda ()
           (message "Formatted via Apheleia."))))
       (lsp-can-format
        (lsp-format-buffer)
        (message "Formatted via LSP."))
       (t
        (message "No formatter available."))))))

;; Evil mode
(use-package evil
  :custom
  (evil-undo-system 'undo-redo)
  (evil-vsplit-window-right t)
  (evil-split-window-below t)
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
  (general-def
    "<f5>" 'recompile)
  (general-def 'override
    "C-." 'embark-act
    "C-;" 'embark-dwim
    "C-h B" 'embark-bindings)
  (general-def 'normal
    "U" 'vundo)
  (general-def 'normal prog-mode-map
    "]d" 'flymake-goto-next-error
    "[d" 'flymake-goto-prev-error
    "K" 'lsp-describe-thing-at-point)
  (general-def 'normal emacs-lisp-mode-map
    "K" 'describe-symbol)
  (my-leader-def 'normal
    ;; Movement
    "w" (cons "Window" (make-sparse-keymap))
    "ww" 'evil-window-next
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wv" 'evil-window-vsplit
    "ws" 'evil-window-split
    "wq" 'evil-window-delete
    "wd" 'evil-window-delete
    "wo" 'delete-other-windows
    ;; Quick access
    ":" 'execute-extended-command
    "." 'find-file
    "SPC" 'project-find-file
    "," 'consult-buffer
    "/" 'consult-ripgrep
    "-" 'dired-jump
    ;; Open
    "o" (cons "Open" (make-sparse-keymap))
    "oe" 'my/eshell-other-window
    ;; Find
    "f" (cons "Find" (make-sparse-keymap))
    "ff" 'find-file
    "fs" 'save-buffer
    "fr" 'consult-recent-file
    ;; Search
    "s" (cons "Search" (make-sparse-keymap))
    "ss" 'consult-line
    "sf" 'consult-fd
    "sg" 'consult-ripgrep
    ;; Workspace
    "TAB" (cons "Workspace" (make-sparse-keymap))
    "TAB n" 'tab-new
    "TAB c" 'tab-close
    "TAB r" 'tab-rename
    "TAB TAB" 'tab-next
    "TAB ]" 'tab-next
    "TAB [" 'tab-previous
    ;; Project
    "p" (cons "Project" (make-sparse-keymap))
    "pp" 'project-switch-project
    "pf" 'project-find-file
    "pc" 'project-compile
    "pk" 'project-kill-buffers
    "pt" 'project-other-tab-command
    ;; Buffer
    "b" (cons "Buffer" (make-sparse-keymap))
    "bb" 'consult-buffer
    "bi" 'ibuffer
    "bs" 'scratch-buffer
    "bk" 'kill-current-buffer
    "bo" 'my/kill-other-buffers
    ;; Code
    "c" (cons "Code" (make-sparse-keymap))
    "cc" 'compile
    "ca" 'lsp-execute-code-action
    "cr" 'lsp-rename
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

;; Load local configuration
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file)))

