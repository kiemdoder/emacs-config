;;; package -- init
;;; code:

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package paredit :ensure t)

(ido-mode t)

;;elisp
(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (paredit-mode t)
                                  (aggressive-indent-mode t)))

;;editing
(global-set-key (kbd "C-c DEL") #'join-line)

;;ace
(use-package ace-window
  :ensure t
  :config (global-set-key (kbd "C-x o") #'ace-window))

;;smooth-scrolling
(use-package smooth-scrolling
  :ensure t
  :config (progn
            (smooth-scrolling-mode)
            (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))))) ;; mouse wheel scroll one line at a time

;;neotree
(use-package neotree
  :ensure t
  :config (global-set-key [f8] 'neotree-toggle))

;;winner-mode
(winner-mode t)
(global-set-key (kbd "C-c <up>") 'delete-other-windows) ;;maximize window
(global-set-key (kbd "C-c <down>") 'winner-undo) ;;restore windows

;;cider
(use-package aggressive-indent :ensure t)
(use-package cider
  :ensure t
  :config (progn
            (add-hook 'clojure-mode-hook (lambda ()
                                           (paredit-mode)
                                           (aggressive-indent-mode)))
            (add-hook 'cider-mode-hook #'eldoc-mode)
            (add-hook 'cider-repl-mode-hook #'paredit-mode)
            (setq cider-repl-use-pretty-printing t)

            ;;clojure-mode formatting
            (require 'clojure-mode)
            (put-clojure-indent 'GET 2)
            (put-clojure-indent 'POST 2)))

;;clj-refactor
(use-package clj-refactor
  :ensure t
  :config (progn
            (require 'clj-refactor)
            (setq cljr-warn-on-eval nil)
            (add-hook 'clojure-mode-hook (lambda ()
                                           (clj-refactor-mode 1)
                                           (yas-minor-mode 1) ; for adding require/use/import statements
                                           ;; This choice of keybinding leaves cider-macroexpand-1 unbound
                                           (cljr-add-keybindings-with-prefix "C-c RET")))))

;;flycheck-clojure
(use-package flycheck-clojure
  :ensure t
  :config (progn
            (eval-after-load 'flycheck '(flycheck-clojure-setup))
            (add-hook 'after-init-hook #'global-flycheck-mode)))

;;flycheck-pos-tip
(use-package flycheck-pos-tip
  :ensure t
  :config (when (boundp 'flycheck-pos-tip-error-messages)
            (eval-after-load 'flycheck
              '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

;;Org
(use-package org-bullets
  :ensure t
  :config (add-hook 'org-mode-hook #'org-bullets-mode))

;;Do Re Mi
(use-package doremi-cmd
  :ensure t
  :config (progn
            (require 'doremi)
            (defalias 'doremi-prefix (make-sparse-keymap))
            (defvar doremi-map (symbol-function 'doremi-prefix)
              "Keymap for Do Re Mi commands.")
            (define-key global-map "\C-xt" 'doremi-prefix)
            (define-key doremi-map "b" 'doremi-buffers+)
            (define-key doremi-map "g" 'doremi-global-marks+)
            (define-key doremi-map "m" 'doremi-marks+)
            (define-key doremi-map "r" 'doremi-bookmarks+) ; reading books?
            (define-key doremi-map "s" 'doremi-custom-themes+) ; custom schemes
            (define-key doremi-map "w" 'doremi-window-height+)))

;;iBuffer
(add-hook 'ibuffer-mode-hook (lambda ()
                               (setq ibuffer-filter-groups '(("Clojure" (mode . clojure-mode))
                                                             ("Cider" (name . "^\\*cider-.*"))
                                                             ("Dired" (mode . dired-mode))
                                                             ("Go" (mode . go-mode))
                                                             ("Org" (mode . org-mode))
                                                             ("emacs" (or
                                                                       (name . "^\\*scratch\\*$")
                                                                       (name . "^\\*Messages\\*$")))))))

;;Go
(use-package go-mode
  :ensure t
  :config (progn
            (add-hook 'go-mode-hook (lambda ()
                                      (flycheck-mode t)
                                      (gorepl-mode t)
                                      (go-eldoc-setup)
                                      
                                      (if (not (string-match "go" compile-command))   ; set compile command default
                                          (set (make-local-variable 'compile-command)
                                               "go build -v && go test -v && go vet"))

                                      ;; guru settings
                                      (go-guru-hl-identifier-mode)                    ; highlight identifiers
                                      
                                      ;; Key bindings specific to go-mode
                                      (local-set-key (kbd "M-.") 'godef-jump)         ; Go to definition
                                      (local-set-key (kbd "M-,") 'pop-tag-mark)       ; Return from whence you came
                                      (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
                                      (local-set-key (kbd "M-P") 'recompile)          ; Redo most recent compile cmd
                                      (local-set-key (kbd "M-]") 'next-error)         ; Go to next error (or msg)
                                      (local-set-key (kbd "M-[") 'previous-error)     ; Go to previous error or msg
                                      ))))

;;go-eldoc           
;;go-guru            
;;go-projectile
;;go-rename          
;;gorepl-mode

;;to install goflymake -> go get -u github.com/dougm/goflymake
(add-to-list 'load-path "~/.emacs.d/personal/goflymake")
(require 'go-flycheck)

;;;
