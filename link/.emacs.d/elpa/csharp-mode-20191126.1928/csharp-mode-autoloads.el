;;; csharp-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode"
;;;;;;  "csharp-mode.el" "c60c91d2fdcc8801f411cc4647ec5747")
;;; Generated autoloads from csharp-mode.el

(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))

(autoload 'csharp-mode "../../../.dotfiles/link/.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode" "\
Major mode for editing C# code.

The mode provides fontification and indent for C# syntax, as well
as some other handy features.

At mode startup, there are two interesting hooks that run:
`prog-mode-hook' is run with no args, then `csharp-mode-hook' is run after
that, also with no args.

To run your own logic after csharp-mode starts, do this:

  (defun my-csharp-mode-fn ()
    \"my function that runs when csharp-mode is initialized for a buffer.\"
    (turn-on-font-lock)
    (turn-on-auto-revert-mode) ;; helpful when also using Visual Studio
    (setq indent-tabs-mode nil) ;; tabs are evil
    ....your own code here...
  )
  (add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)


The function above is just a suggestion.


Imenu Integration
===============================

Check the menubar for menu entries for Imenu; it is labelled
\"Index\".

The Imenu index gets computed when the file is .cs first opened and loaded.
This may take a moment or two.  If you don't like this delay and don't
use Imenu, you can turn this off with the variable `csharp-want-imenu'.



Key bindings:
\\{csharp-mode-map}

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode"
;;;;;;  "csharp-mode.el" (0 0 0 0))
;;; Generated autoloads from csharp-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode" '("csharp-")))

;;;***

;;;***

;;;### (autoloads nil "csharp-mode" "../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode.el"
;;;;;;  "c60c91d2fdcc8801f411cc4647ec5747")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode.el

(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))

(autoload 'csharp-mode "csharp-mode" "\
Major mode for editing C# code.

The mode provides fontification and indent for C# syntax, as well
as some other handy features.

At mode startup, there are two interesting hooks that run:
`prog-mode-hook' is run with no args, then `csharp-mode-hook' is run after
that, also with no args.

To run your own logic after csharp-mode starts, do this:

  (defun my-csharp-mode-fn ()
    \"my function that runs when csharp-mode is initialized for a buffer.\"
    (turn-on-font-lock)
    (turn-on-auto-revert-mode) ;; helpful when also using Visual Studio
    (setq indent-tabs-mode nil) ;; tabs are evil
    ....your own code here...
  )
  (add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)


The function above is just a suggestion.


Imenu Integration
===============================

Check the menubar for menu entries for Imenu; it is labelled
\"Index\".

The Imenu index gets computed when the file is .cs first opened and loaded.
This may take a moment or two.  If you don't like this delay and don't
use Imenu, you can turn this off with the variable `csharp-want-imenu'.



Key bindings:
\\{csharp-mode-map}

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "csharp-mode"
;;;;;;  "../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "csharp-mode" '("csharp-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/csharp-mode-20191126.1928/csharp-mode.el"
;;;;;;  "csharp-mode.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; csharp-mode-autoloads.el ends here
