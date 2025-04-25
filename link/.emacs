(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(after-save-hook nil)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(asm-comment-char 35)
 '(auto-revert-remote-files t)
 '(case-fold-search t)
 '(column-number-mode t)
 '(company-dabbrev-code-time-limit 0.1)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   '("f78de13274781fbb6b01afd43327a4535438ebaeec91d93ebdbba1e3fba34d3c" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" default))
 '(debug-on-error nil)
 '(default-frame-alist '((fullscreen . maximized)))
 '(delete-selection-mode t)
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(edit-server-default-major-mode 'markdown-mode)
 '(edit-server-new-frame nil)
 '(emojify-composed-text-p t)
 '(emojify-emoji-styles '(unicode))
 '(fill-column 80)
 '(flycheck-python-pycompile-executable "python3")
 '(flycheck-python-pylint-executable "/home/harrison/.local/bin/pylint")
 '(flymake-python-pyflakes-executable "/home/harrison/.local/bin/pyflakes")
 '(git-commit-fill-column 70)
 '(global-auto-revert-mode t)
 '(global-auto-revert-mode-text "auto-revert")
 '(global-edit-server-edit-mode t)
 '(global-emojify-mode t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-path-ghci "ghci")
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type 'stack-ghci)
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    '("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2")))
 '(highlight-symbol-foreground-color "#586e75")
 '(hl-bg-colors
   '("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342"))
 '(hl-fg-colors
   '("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3"))
 '(ibuffer-never-show-predicates
   '("^\\*scratch\\*$" "^\\*Messages\\*$" "^\\*Warnings\\*$" "^\\*Help\\*$" "^\\*Info\\*$" "^\\*Completions\\*$" "^\\*Disabled Command\\*$") nil (ibuf-ext))
 '(indent-guide-delay -1)
 '(indent-guide-global-mode nil)
 '(indent-guide-recursive nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(ispell-choices-win-default-height 50)
 '(js2-indent-switch-body t)
 '(js2-strict-trailing-comma-warning nil)
 '(meghanada-cache-in-project nil)
 '(minibuffer-electric-default-mode t)
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4"))
 '(org-adapt-indentation t)
 '(org-cycle-include-plain-lists 'integrate)
 '(org-enforce-todo-dependencies t)
 '(org-export-with-sub-superscripts '{})
 '(org-indent-mode-turns-off-org-adapt-indentation nil)
 '(org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame)))
 '(org-table-default-size "2x5")
 '(package-archives
   '(("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/")
     ("melpa stable" . "https://stable.melpa.org/packages/")))
 '(package-selected-packages
   '(adoc-mode graphql-mode graphql typescript-mode kotlin-mode jq-format lua-mode rust-mode lsp-ui use-package emojify monokai-theme lsp-mode gitattributes-mode gitconfig-mode gitignore-mode org deadgrep protobuf-mode adaptive-wrap jq-mode editorconfig goto-chg vterm edit-server notmuch swift-mode minitest move-text drag-stuff diff-hl git-gutter ac-helm prettier-js string-inflection counsel-etags sql-indent wucuo helm clang-format gradle-mode paredit cider flycheck-clojure inf-clojure haskell-mode epl cmake-font-lock eglot matlab-mode elm-mode flycheck-elm csv csv-mode toml toml-mode meghanada yaml-mode web-mode tabbar solarized-theme smartparens ruby-extra-highlight markdown-mode magit jinja2-mode haskell-tab-indent haskell-emacs-text haskell-emacs-base go-autocomplete ghci-completion ghc-imported-from ghc flymd flymake-ruby flymake-python-pyflakes flymake-hlint flymake-haskell-multi flycheck-hdevtools flycheck-haskell flycheck-ghcmod exec-path-from-shell django-mode company-inf-ruby ac-js2 ac-inf-ruby ac-haskell-process 2048-game))
 '(paradox-github-token t)
 '(python-indent-offset 3)
 '(safe-local-variable-values '((engine . django)))
 '(send-mail-function 'mailclient-send-it)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(split-height-threshold 120)
 '(split-width-threshold 140)
 '(standard-indent 2)
 '(tab-always-indent 'complete)
 '(tab-width 2)
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(typescript-indent-level 2)
 '(vc-annotate-background-mode nil)
 '(vhdl-electric-mode nil)
 '(vhdl-highlight-special-words t)
 '(vhdl-highlight-translate-off t)
 '(vhdl-indent-comment-like-next-code-line t)
 '(vhdl-stutter-mode nil)
 '(whitespace-style
   '(face trailing tabs spaces newline missing-newline-at-eof empty indentation space-after-tab space-before-tab space-mark tab-mark newline-mark))
 '(xterm-color-names
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#073642"])
 '(xterm-color-names-bright
   ["#fdf6e3" "#cb4b16" "#93a1a1" "#839496" "#657b83" "#6c71c4" "#586e75" "#002b36"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-current-diff-Ancestor ((t (:background "darkblue"))))
 '(region ((t (:inherit highlight :extend t :background "#8a8875"))))
 '(whitespace-line ((t nil))))

;; list the packages you want
(defvar package-list '())

(setq package-list
  '(ac-haskell-process
    ac-js2
    async
    auto-complete
    company
    dash
    django-mode
    epl
    exec-path-from-shell
    flymd
    git-commit
    go-autocomplete
    ;; go-complete
    ;; go-mode
    haskell-emacs
    haskell-emacs-base
    haskell-emacs-text
    haskell-mode
    helm
    helm-core
    helm-make
    inf-ruby
    jinja2-mode
    js2-mode
    magit
    monokai-theme
    pkg-info
    popup
    projectile
    s
    simple-httpd
    skewer-mode
    solarized-theme
    tabbar
    web-mode
    with-editor
    yaml-mode
))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (when (yes-or-no-p (format "Install missing package: %s?" package))
      (package-install package))))

(defmacro with-library (symbol &rest body)
  "Include library dentoed by SYMBOL, and install it if necessary.

Execute contents of BODY if included."
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)
     (error (message (format "I guess we don't have %s available." ',symbol))
            nil)))

;; https://www.emacswiki.org/emacs/LoadingLispFiles
(defun load-directory (dir)
  "Load all .el files in DIR."
  (let ((load-it (lambda (f)
                   (load-file (concat (file-name-as-directory dir) f)))))
    (mapc load-it (directory-files dir nil "\\.el$"))))
(load-directory "~/.emacs.d/others")
(load-directory "~/.emacs.d/harrison")
(let ((file (expand-file-name "~/.emacs.d/harrison/LOCAL.el")))
  (when (file-exists-p file)
    (load-file file)))

(provide '.emacs)
;;; .emacs ends here
