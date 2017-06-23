(ido-mode t)

;;elisp
(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (paredit-mode t)
                                  (aggressive-indent-mode t)))

;;editing
(global-set-key (kbd "C-c DEL") #'join-line)

;;ace
(global-set-key (kbd "C-x o") #'ace-window)

;;smooth-scrolling
(require 'smooth-scrolling)
(smooth-scrolling-mode 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; mouse wheel scroll one line at a time

;;neotree
(global-set-key [f8] 'neotree-toggle)

;;winner-mode
(winner-mode t)
(global-set-key (kbd "C-c <up>") 'delete-other-windows) ;;maximize window
(global-set-key (kbd "C-c <down>") 'winner-undo) ;;restore windows

;;cider
(add-hook 'clojure-mode-hook (lambda ()
                               (paredit-mode t)
                               (aggressive-indent-mode t)))
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'paredit-mode)
(setq cider-repl-use-pretty-printing t)

;;clojure-mode formatting
(require 'clojure-mode)
(put-clojure-indent 'GET 2)
(put-clojure-indent 'POST 2)

;;clj-refactor
(require 'clj-refactor)
(setq cljr-warn-on-eval nil)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               (yas-minor-mode 1) ; for adding require/use/import statements
                               ;; This choice of keybinding leaves cider-macroexpand-1 unbound
                               (cljr-add-keybindings-with-prefix "C-c RET")))

;;flycheck-clojure
(eval-after-load 'flycheck '(flycheck-clojure-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)

;;flycheck-pos-tip
(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;;Do Re Mi
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
(define-key doremi-map "w" 'doremi-window-height+)

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
