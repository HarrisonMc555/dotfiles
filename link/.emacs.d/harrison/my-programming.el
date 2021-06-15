;;; my-programming.el --- Customizations for programming modes  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Harrison

;; Author: Harrison <harrison@saturn>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

;; C ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq c-default-style "k&r"
      c-basic-offset 4)

;; C++ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Java ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'meghanada)
;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             ;; meghanada-mode on
;;             (meghanada-mode t)
;;             (flycheck-mode +1)
;;             (setq c-basic-offset 2)
;;             ;; use code format
;;             (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))
;; (cond
;;    ((eq system-type 'windows-nt)
;;     (setq meghanada-java-path (expand-file-name "bin/java.exe" (getenv "JAVA_HOME")))
;;     (setq meghanada-maven-path "mvn.cmd"))
;;    (t
;;     (setq meghanada-java-path "java")
;;     (setq meghanada-maven-path "mvn")))

;; (add-to-list 'flycheck-checkers 'meghanada)


;; Kotlin ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ktlint-fix-file ()
  "Run ktlint on current buffer."
  (interactive)
  (message "Running ktlint on %s" (buffer-file-name))
  (shell-command (concat "ktlint -F " (buffer-file-name))))

(defun ktlint-fix-file-and-revert ()
  "Run ktlint on current buffer and revert it."
  (interactive)
  (ktlint-fix-file)
  (revert-buffer t t))

;; (add-hook 'kotlin-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook #'ktlint-fix-file-and-revert
;;                       nil 'local)))
(add-hook 'kotlin-mode-hook
          (lambda () (local-set-key (kbd "C-c C-f")
                                    #'ktlint-fix-file-and-revert)))

(setq-default kotlin-tab-width 4)

;; Lisp ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")


;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 4-space indentation for python-mode
(setq python-indent 4)
;; (add-to-list 'load-path "~/.emacs.d") ;; check path
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq python-indent 4))))

;; https://github.com/purcell/flymake-python-pyflakes
(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook #'flymake-python-pyflakes-load)

;; Haskell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'inf-haskell)
;; (add-hook 'haskell-mode-hook #'turn-on-haskell-doc-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook #'interactive-haskell-mode)
(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))
(custom-set-variables '(haskell-process-type 'stack-ghci))

;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This causes emacs to hang...
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

;; (when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" "/home/harrison/go")

(add-to-list 'exec-path "/home/harrison/go/bin")

(defun my-go-mode-hook ()
                                        ; Call Gofmt before saving
  (add-hook 'before-save-hook #'gofmt-before-save)
                                        ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
                                        ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark))
(add-hook 'go-mode-hook #'my-go-mode-hook)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook #'auto-complete-for-go)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

;; Javascript ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq js-indent-level 2)
(setq js2-basic-offset 2)

;; ;; Typescript
;; (setq typescript-indent-level 4)
;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
;; (add-hook 'typescript-mode-hook
;;           (lambda ()
;;             (tide-mode t)
;;             (flycheck-mode t)
;;             (company-mode t)))

;; Web Programming ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))
(add-to-list 'auto-mode-alist '("\\.tera\\'" . jinja2-mode))


;; web-mode files
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(setq web-mode-enable-engine-detection t)

;; Assembly ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-asm-mode-hook ()
  ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (local-unset-key (vector asm-comment-char))
  ;; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent)))

(add-hook 'asm-mode-hook #'my-asm-mode-hook)

(add-to-list 'auto-mode-alist '("\\.ys\\'" . asm-mode))

;; Markdown ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-markdown-mode-hook ()
  (visual-line-mode)
  ;; (visual-fill-column-mode)
  (turn-off-auto-fill)
  ;; (auto-fill-mode -1)
  ;; (linum-mode)
  )

(add-hook 'markdown-mode-hook #'my-markdown-mode-hook)

;; Rust ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

;; (defun my-project-try-cargo-toml (dir)
;;   "Try to locate a Rust project."
;;   (when (locate-dominating-file dir "Cargo.toml")
;;     `(transient . ,dir)))

;; (defun my-rust-mode-hook ()
;;   (set-fill-column 100)
;;   )

;; (add-hook 'rust-mode-hook #'my-rust-mode-hook)

;; (setq lsp-rust-server 'rust-analyzer)

;; Ruby ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'ruby-mode-hook (lambda () (flycheck-mode)))

;; Sql ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-sql-mode-hook ()
  (sqlind-minor-mode t)
  (setq-local sql-dialect 'mysql)
  )

(add-hook 'sql-mode-hook #'my-sql-mode-hook)

;; Clojure ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
;; (require 'clojure-mode-extra-font-locking)
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq inferior-lisp-program "lein repl")
            (font-lock-add-keywords
             nil
             '(("(\\(facts?\\)"
                (1 font-lock-keyword-face))
               ("(\\(background?\\)"
                (1 font-lock-keyword-face))))
            (define-clojure-indent (fact 1))
            (define-clojure-indent (facts 1))
            (rainbow-delimiters-mode)))

;; Use clojure mode for other extensions
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
(add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode))

;; Cider ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; provides minibuffer documentation for the code you're typing into the repl
(add-hook 'cider-mode-hook 'eldoc-mode)

;; go right to the REPL buffer when it's finished connecting
(setq cider-repl-pop-to-buffer-on-connect t)

;; When there's a cider error, show its buffer and switch to it
(setq cider-show-error-buffer t)
(setq cider-auto-select-error-buffer t)

;; Where to store the cider history.
(setq cider-repl-history-file "~/.emacs.d/cider-history")

;; Wrap when navigating history.
(setq cider-repl-wrap-history t)

;; enable paredit in your REPL
(add-hook 'cider-repl-mode-hook 'paredit-mode)


;;; Tmp ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.tmp$" . text-mode))

;;; svn-commit.tmp
(defun svn-commit-tmp-hook ()
  (when (string= (file-name-nondirectory (buffer-file-name)) "svn-commit.tmp")
    (setq-local fill-column 70)))

(add-hook 'find-file-hook 'svn-commit-tmp-hook)

;; XML ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'nxml-mode-hook
          (lambda ()
            (progn
              (setq-local nxml-child-indent 4)
              (setq-local nxml-attribute-indent 4)
              ;; optional key bindings, easier than hs defaults
              (define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)
              )))

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))


(add-hook 'nxml-mode-hook 'hs-minor-mode)


;; sh-mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'sh-mode-hook
          (lambda () (flycheck-mode t)))

;; VC (Version Control) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Try rust projects before version-control (vc) projects
;; (add-hook 'project-find-functions 'my-project-try-cargo-toml nil nil)

(global-diff-hl-mode t)
(diff-hl-flydiff-mode)
(add-hook 'dired-mode-hook 'diff-hl-dired-mode-unless-remote)

;;; my-programming.el ends here
(provide 'my-programming)

