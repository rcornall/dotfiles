(setq c-default-style "linux"
      c-basic-offset 4)(require 'package)

(setq scroll-margin 3)

; List the packages you want
(setq package-list '(evil
                     evil-leader))

; Add Melpa as the default Emacs Package repository
; only contains a very limited number of packages
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
; Activate all the packages (in particular autoloads)
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package evil
  :ensure t
  :defer .1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq evil-want-integration t) ;; required by evil-collection
  (setq evil-want-keybinding nil)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
  (setq evil-split-window-below t) ;; like vim's 'splitbelow'
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)

  ;; visual hints while editing
  (use-package evil-goggles
    :ensure t
    :config
    (evil-goggles-use-diff-faces)
    (evil-goggles-mode))

  ;; like vim-surround
  (use-package evil-surround
    :ensure t
    :commands
    (evil-surround-edit
     evil-Surround-edit
     evil-surround-region
     evil-Surround-region)
    :init
    (evil-define-key 'operator global-map "s" 'evil-surround-edit)
    (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
    (evil-define-key 'visual global-map "S" 'evil-surround-region)
    (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

  (use-package evil-leader
    :ensure t
    :defer t
    :init
    (progn
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      "b" 'switch-to-buffer
      "w" 'save-buffer)))
  
  (use-package undo-fu
    :ensure t
    :config
    (setq undo-limit 400000
      undo-strong-limit 3000000
      undo-outer-limit 3000000)
    (global-undo-tree-mode -1)
    (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
    (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))

  ; bindings
  (defun comment-or-uncomment-line-or-region ()
    "Comments or uncomments the current line or region."
    (interactive)
    (if (region-active-p)
  (comment-or-uncomment-region (region-beginning) (region-end))
(comment-or-uncomment-region (line-beginning-position) (line-end-position))
)
    )
  (define-key evil-normal-state-map (kbd "C-/") 'comment-or-uncomment-line-or-region)
  (define-key evil-normal-state-map (kbd "-") 'helm-find-files)
   

  (setq-default evil-kill-on-visual-paste nil)

  (message "Loading evil-mode...done"))

(use-package undo-fu-session
  :ensure t
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))
(global-undo-fu-session-mode)


(use-package helm
  :ensure t
  :custom
  (helm-completion-style 'emacs)
  :config
  (helm-mode 1)
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (setq-default helm-M-x-fuzzy-match t)
  (global-set-key (kbd "M-x") #'helm-M-x)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-map (kbd "C-j") 'helm-next-line)
  (define-key helm-map (kbd "C-k") 'helm-previous-line)
  (define-key helm-map (kbd "-") 'helm-find-files-up-one-level)
  (define-key global-map [remap find-file] 'helm-find-files)
  (setq completion-styles `(basic partial-completion emacs22 initials
			      ,(if (version<= emacs-version "27.0") 'helm-flex 'flex))))

;; (use-package evil-collection
;;   :after (evil helm)
;;   :ensure t
;;   :init (evil-collection-init))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

(use-package helm-projectile
  :bind (("C-S-P" . helm-projectile-switch-project)
         :map evil-normal-state-map
         ("C-p" . helm-projectile))
  :ensure t
  :config
  (evil-leader/set-key
    "ps" 'helm-projectile-ag
    "pa" 'helm-projectile-find-file-in-known-projects
  ))

(use-package seoul256-theme
  :ensure t
  :config)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (helm evil-iedit-state iedit evil-surround evil-goggles evil-leader evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))
