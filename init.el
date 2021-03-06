;;; package -- init
;;; code:

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq-default tab-width 2)

;;guru
(setq prelude-guru nil)

;;multiple-cursors
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-set-key (kbd "M->") 'mc/edit-lines)

;;elisp
(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (paredit-mode t)
                                  (aggressive-indent-mode t)))

;;editing
(global-set-key (kbd "C-c DEL") #'join-line)

;;ace
(use-package ace-window
  :ensure t
  :config (progn
            (global-set-key [remap other-window] 'ace-window)
                                        ;make ace window numbers a little bigger
            (custom-set-faces
             '(aw-leading-char-face
               ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

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
            (add-hook 'cider-repl-mode-hook (lambda ()
                                              (paredit-mode)
                                              (eldoc-mode)))
            (setq cider-repl-use-pretty-printing t)

            ;;clojure-mode formatting
            (require 'clojure-mode)
            (put-clojure-indent 'GET 2)
            (put-clojure-indent 'DELETE 2)
            (put-clojure-indent 'POST 2)
            (put-clojure-indent 'PUT 2)
            (setq cider-cljs-lein-repl
                  "(do (require 'figwheel-sidecar.repl-api)
                       (figwheel-sidecar.repl-api/start-figwheel!)
                       (figwheel-sidecar.repl-api/cljs-repl))")))

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
  :disabled
  :ensure t
  :config (progn
            (eval-after-load 'flycheck '(flycheck-clojure-setup))
            (add-hook 'after-init-hook #'global-flycheck-mode)))

;;flycheck-pos-tip
(use-package flycheck-pos-tip
  :disabled
  :ensure t
  :config (when (boundp 'flycheck-pos-tip-error-messages)
            (eval-after-load 'flycheck
              '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

;;Org
(use-package org-bullets
  :ensure t
  :config (add-hook 'org-mode-hook #'org-bullets-mode))

(use-package htmlize :ensure t) ;fix code colour coding in org

;;Reveal
(use-package ox-reveal
  :ensure t
  :config (progn
            (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
            (setq org-reveal-mathjax t)))

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
                                                             ("ClojureC" (name . ".*\.cljc"))
                                                             ("Clojurescript" (mode . clojurescript-mode))
                                                             ("Cider" (name . "^\\*cider-.*"))
                                                             ("Dired" (mode . dired-mode))
                                                             ("Go" (mode . go-mode))
                                                             ("Org" (mode . org-mode))
                                                             ("emacs" (or
                                                                       (name . "^\\*scratch\\*$")
                                                                       (name . "^\\*Messages\\*$")))))))

;;groovy
(use-package gradle-mode :ensure t)
(use-package groovy-mode :ensure t)
(use-package groovy-imports :ensure t)
;;;
