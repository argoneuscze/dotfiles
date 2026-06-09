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
(setq inhibit-x-resources t
      inhibit-startup-screen t)

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
  (indent-tabs-mode nil)
  (global-display-line-numbers-mode t)
  (pixel-scroll-precision-mode t)
  (column-number-mode t)
  (savehist-mode t)
  (save-place-mode t)
  (recentf-mode t)
  (which-key-mode t))

;; Editor
(use-package vundo
  :bind ("U" . vundo))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay 0.1)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :bind
  (:map corfu-map
    ("TAB" . corfu-next)
    ([tab] . corfu-next)
    ("S-TAB" . corfu-previous)
    ([backtab] . corfu-previous)))

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

;; Evil mode
(use-package evil
  :custom
  (evil-undo-system 'undo-redo)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-set-leader '(normal visual) (kbd ",") t)
  ;; Quick access
  (evil-define-key 'normal 'global (kbd "<leader> :") 'execute-extended-command)
  (evil-define-key 'normal 'global (kbd "<leader> .") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader> SPC") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> ,") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> -") 'dired-jump)
  ;; Find
  (evil-define-key 'normal 'global (kbd "<leader> f f") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader> f s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> f r") 'consult-recent-file)
  ;; Search
  (evil-define-key 'normal 'global (kbd "<leader> s s") 'consult-line)
  (evil-define-key 'normal 'global (kbd "<leader> s f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> s g") 'consult-ripgrep)
  ;; Project
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'project-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  ;; Buffer
  (evil-define-key 'normal 'global (kbd "<leader> b b") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b i") 'ibuffer)
  (evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer)
  ;; Dired
  (evil-define-key 'normal 'global (kbd "<leader> d d") 'dired)
  (evil-define-key 'normal 'global (kbd "<leader> d j") 'dired-jump)
  ;; Git
  (evil-define-key 'normal 'global (kbd "<leader> g g") 'magit-status)
  ;; Help
  (evil-define-key 'normal 'global (kbd "<leader> h m") 'describe-mode)
  (evil-define-key 'normal 'global (kbd "<leader> h f") 'describe-function)
  (evil-define-key 'normal 'global (kbd "<leader> h v") 'describe-variable)
  (evil-define-key 'normal 'global (kbd "<leader> h k") 'describe-key)) 
  
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

