;;; elm-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-font-lock"
;;;;;;  "elm-font-lock.el" (0 0 0 0))
;;; Generated autoloads from elm-font-lock.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-font-lock" '("turn-on-elm-font-lock" "elm-")))

;;;***

;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-format"
;;;;;;  "elm-format.el" "6093d871db5bee14a44f7dec4adfbef4")
;;; Generated autoloads from elm-format.el
 (autoload 'elm-format-buffer "elm-format" nil t)
 (autoload 'elm-format-on-save-mode "elm-format" nil t)

(define-obsolete-function-alias 'elm-mode-format-buffer 'elm-format-buffer "20190113")

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-format"
;;;;;;  "elm-format.el" (0 0 0 0))
;;; Generated autoloads from elm-format.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-format" '("elm-format-")))

;;;***

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-imenu"
;;;;;;  "elm-imenu.el" (0 0 0 0))
;;; Generated autoloads from elm-imenu.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-imenu" '("elm-imenu-create-index")))

;;;***

;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-indent"
;;;;;;  "elm-indent.el" "72f2c623541669a9ad3fe16bc38c1bfc")
;;; Generated autoloads from elm-indent.el

(autoload 'elm-indent-mode "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-indent" "\
``Intelligent'' Elm indentation mode.

This deals with the layout rules of Elm.

\\[elm-indent-cycle] starts the cycle which proposes new
possibilities as long as the TAB key is pressed.  Any other key
or mouse click terminates the cycle and is interpreted except for
RET which merely exits the cycle.

Other special keys are:

    \\[elm-indent-insert-equal]
      inserts an =

Invokes `elm-indent-hook' if not nil.

\(fn &optional ARG)" t nil)

(define-obsolete-function-alias 'turn-on-elm-indent 'elm-indent-mode)

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-indent"
;;;;;;  "elm-indent.el" (0 0 0 0))
;;; Generated autoloads from elm-indent.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-indent" '("turn-off-elm-indent" "elm-indent-")))

;;;***

;;;***

;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive"
;;;;;;  "elm-interactive.el" "bc0d79dd3d520deaff3e4a3f45fa7b5e")
;;; Generated autoloads from elm-interactive.el

(autoload 'elm-interactive-mode "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Major mode for `run-elm-interactive'.

\\{elm-interactive-mode-map}

\(fn)" t nil)

(autoload 'run-elm-interactive "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Run an inferior instance of `elm-repl' inside Emacs.

\(fn)" t nil)

(autoload 'elm-repl-load "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Load an interactive REPL if there isn't already one running.
Changes the current root directory to be the directory with the closest
package json if one exists otherwise sets it to be the working directory
of the file specified.

\(fn)" t nil)

(autoload 'elm-repl-push "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Push the region from BEG to END to an interactive REPL.

\(fn BEG END)" t nil)

(autoload 'elm-repl-push-decl "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Push the current top level declaration to the REPL.

\(fn)" t nil)

(autoload 'run-elm-reactor "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Run the Elm reactor process.

\(fn)" t nil)

(autoload 'elm-preview-buffer "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Preview the current buffer using Elm reactor (in debug mode if DEBUG is truthy).

\(fn DEBUG)" t nil)

(autoload 'elm-preview-main "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Preview the main elm file using Elm reactor (in debug mode if DEBUG is truthy).

\(fn DEBUG)" t nil)

(autoload 'elm-compile-buffer "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Compile the current buffer into OUTPUT.

\(fn &optional OUTPUT)" t nil)

(autoload 'elm-compile-main "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Compile the main elm file into OUTPUT.

\(fn &optional OUTPUT)" t nil)

(autoload 'elm-compile-clean-imports "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Remove unused imports from the current buffer, PROMPT optionally before deleting.

\(fn &optional PROMPT)" t nil)

(autoload 'elm-sort-imports "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Sort the import list in the current buffer.

\(fn)" t nil)

(autoload 'elm-compile-add-annotations "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Add missing type annotations to the current buffer, PROMPT optionally before inserting.

\(fn &optional PROMPT)" t nil)

(autoload 'elm-create-package "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Generate a new package definition in the current directory.

\(fn)" t nil)

(autoload 'elm-package-catalog "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Show the package catalog, refreshing the list if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-package-refresh-contents "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Refresh the package list.

\(fn)" t nil)

(autoload 'elm-import "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Import a module, refreshing if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-documentation-lookup "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Lookup the documentation for a function, refreshing if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-package-mode "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Special mode for elm-package.

\\{elm-package-mode-map}

\(fn)" t nil)

(autoload 'elm-oracle-type-at-point "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Print the type of the function at point to the minibuffer.

\(fn)" t nil)

(autoload 'elm-eldoc "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Get the type of the function at point for eldoc.

\(fn)" nil nil)

(autoload 'elm-oracle-doc-at-point "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Show the documentation of the value at point.

\(fn)" t nil)

(autoload 'elm-oracle-completion-at-point-function "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Completion at point function for elm-oracle.

\(fn)" nil nil)

(autoload 'elm-oracle-setup-completion "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Set up standard completion.
Add this function to your `elm-mode-hook' to enable an
elm-specific `completion-at-point' function.

\(fn)" nil nil)

(autoload 'elm-oracle-setup-ac "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Set up auto-complete support.
Add this function to your `elm-mode-hook'.

\(fn)" nil nil)

(autoload 'company-elm "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Provide completion info according to COMMAND and ARG.  IGNORED is not used.

\(fn COMMAND &optional ARG &rest IGNORED)" t nil)

(autoload 'elm-test-project "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" "\
Run the elm-test command on the current project.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive"
;;;;;;  "elm-interactive.el" (0 0 0 0))
;;; Generated autoloads from elm-interactive.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive" '("elm-" "ac-source-elm")))

;;;***

;;;***

;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-mode"
;;;;;;  "elm-mode.el" "6bdd4a991fd934cdb588e88e6432691f")
;;; Generated autoloads from elm-mode.el

(autoload 'elm-mode "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-mode" "\
Major mode for editing Elm source code.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.elm\\'" . elm-mode))

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-mode"
;;;;;;  "elm-mode.el" (0 0 0 0))
;;; Generated autoloads from elm-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-mode" '("elm-")))

;;;***

;;;***

;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-tags"
;;;;;;  "elm-tags.el" "ad192d04983b9b9fae7e82a8c27320dd")
;;; Generated autoloads from elm-tags.el

(autoload 'elm-mode-goto-tag-at-point "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-tags" "\
Go to tag at point.

\(fn)" t nil)

(autoload 'elm-mode-generate-tags "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-tags" "\
Generate a TAGS file for the current project.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-tags"
;;;;;;  "elm-tags.el" (0 0 0 0))
;;; Generated autoloads from elm-tags.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-tags" '("elm-tags-")))

;;;***

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-util"
;;;;;;  "elm-util.el" (0 0 0 0))
;;; Generated autoloads from elm-util.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/elm-mode-20191125.1919/elm-util" '("elm-")))

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "elm-font-lock"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-font-lock.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-font-lock.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-font-lock" '("turn-on-elm-font-lock" "elm-")))

;;;***

;;;### (autoloads nil "elm-format" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-format.el"
;;;;;;  "6093d871db5bee14a44f7dec4adfbef4")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-format.el
 (autoload 'elm-format-buffer "elm-format" nil t)
 (autoload 'elm-format-on-save-mode "elm-format" nil t)

(define-obsolete-function-alias 'elm-mode-format-buffer 'elm-format-buffer "20190113")

;;;### (autoloads "actual autoloads are elsewhere" "elm-format" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-format.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-format.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-format" '("elm-format-")))

;;;***

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "elm-imenu" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-imenu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-imenu.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-imenu" '("elm-imenu-create-index")))

;;;***

;;;### (autoloads nil "elm-indent" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-indent.el"
;;;;;;  "72f2c623541669a9ad3fe16bc38c1bfc")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-indent.el

(autoload 'elm-indent-mode "elm-indent" "\
``Intelligent'' Elm indentation mode.

This deals with the layout rules of Elm.

\\[elm-indent-cycle] starts the cycle which proposes new
possibilities as long as the TAB key is pressed.  Any other key
or mouse click terminates the cycle and is interpreted except for
RET which merely exits the cycle.

Other special keys are:

    \\[elm-indent-insert-equal]
      inserts an =

Invokes `elm-indent-hook' if not nil.

\(fn &optional ARG)" t nil)

(define-obsolete-function-alias 'turn-on-elm-indent 'elm-indent-mode)

;;;### (autoloads "actual autoloads are elsewhere" "elm-indent" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-indent.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-indent.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-indent" '("turn-off-elm-indent" "elm-indent-")))

;;;***

;;;***

;;;### (autoloads nil "elm-interactive" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive.el"
;;;;;;  "bc0d79dd3d520deaff3e4a3f45fa7b5e")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive.el

(autoload 'elm-interactive-mode "elm-interactive" "\
Major mode for `run-elm-interactive'.

\\{elm-interactive-mode-map}

\(fn)" t nil)

(autoload 'run-elm-interactive "elm-interactive" "\
Run an inferior instance of `elm-repl' inside Emacs.

\(fn)" t nil)

(autoload 'elm-repl-load "elm-interactive" "\
Load an interactive REPL if there isn't already one running.
Changes the current root directory to be the directory with the closest
package json if one exists otherwise sets it to be the working directory
of the file specified.

\(fn)" t nil)

(autoload 'elm-repl-push "elm-interactive" "\
Push the region from BEG to END to an interactive REPL.

\(fn BEG END)" t nil)

(autoload 'elm-repl-push-decl "elm-interactive" "\
Push the current top level declaration to the REPL.

\(fn)" t nil)

(autoload 'run-elm-reactor "elm-interactive" "\
Run the Elm reactor process.

\(fn)" t nil)

(autoload 'elm-preview-buffer "elm-interactive" "\
Preview the current buffer using Elm reactor (in debug mode if DEBUG is truthy).

\(fn DEBUG)" t nil)

(autoload 'elm-preview-main "elm-interactive" "\
Preview the main elm file using Elm reactor (in debug mode if DEBUG is truthy).

\(fn DEBUG)" t nil)

(autoload 'elm-compile-buffer "elm-interactive" "\
Compile the current buffer into OUTPUT.

\(fn &optional OUTPUT)" t nil)

(autoload 'elm-compile-main "elm-interactive" "\
Compile the main elm file into OUTPUT.

\(fn &optional OUTPUT)" t nil)

(autoload 'elm-compile-clean-imports "elm-interactive" "\
Remove unused imports from the current buffer, PROMPT optionally before deleting.

\(fn &optional PROMPT)" t nil)

(autoload 'elm-sort-imports "elm-interactive" "\
Sort the import list in the current buffer.

\(fn)" t nil)

(autoload 'elm-compile-add-annotations "elm-interactive" "\
Add missing type annotations to the current buffer, PROMPT optionally before inserting.

\(fn &optional PROMPT)" t nil)

(autoload 'elm-create-package "elm-interactive" "\
Generate a new package definition in the current directory.

\(fn)" t nil)

(autoload 'elm-package-catalog "elm-interactive" "\
Show the package catalog, refreshing the list if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-package-refresh-contents "elm-interactive" "\
Refresh the package list.

\(fn)" t nil)

(autoload 'elm-import "elm-interactive" "\
Import a module, refreshing if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-documentation-lookup "elm-interactive" "\
Lookup the documentation for a function, refreshing if REFRESH is truthy.

\(fn REFRESH)" t nil)

(autoload 'elm-package-mode "elm-interactive" "\
Special mode for elm-package.

\\{elm-package-mode-map}

\(fn)" t nil)

(autoload 'elm-oracle-type-at-point "elm-interactive" "\
Print the type of the function at point to the minibuffer.

\(fn)" t nil)

(autoload 'elm-eldoc "elm-interactive" "\
Get the type of the function at point for eldoc.

\(fn)" nil nil)

(autoload 'elm-oracle-doc-at-point "elm-interactive" "\
Show the documentation of the value at point.

\(fn)" t nil)

(autoload 'elm-oracle-completion-at-point-function "elm-interactive" "\
Completion at point function for elm-oracle.

\(fn)" nil nil)

(autoload 'elm-oracle-setup-completion "elm-interactive" "\
Set up standard completion.
Add this function to your `elm-mode-hook' to enable an
elm-specific `completion-at-point' function.

\(fn)" nil nil)

(autoload 'elm-oracle-setup-ac "elm-interactive" "\
Set up auto-complete support.
Add this function to your `elm-mode-hook'.

\(fn)" nil nil)

(autoload 'company-elm "elm-interactive" "\
Provide completion info according to COMMAND and ARG.  IGNORED is not used.

\(fn COMMAND &optional ARG &rest IGNORED)" t nil)

(autoload 'elm-test-project "elm-interactive" "\
Run the elm-test command on the current project.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "elm-interactive"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-interactive" '("elm-" "ac-source-elm")))

;;;***

;;;***

;;;### (autoloads nil "elm-mode" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode.el"
;;;;;;  "6bdd4a991fd934cdb588e88e6432691f")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode.el

(autoload 'elm-mode "elm-mode" "\
Major mode for editing Elm source code.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.elm\\'" . elm-mode))

;;;### (autoloads "actual autoloads are elsewhere" "elm-mode" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-mode" '("elm-")))

;;;***

;;;***

;;;### (autoloads nil "elm-tags" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-tags.el"
;;;;;;  "ad192d04983b9b9fae7e82a8c27320dd")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-tags.el

(autoload 'elm-mode-goto-tag-at-point "elm-tags" "\
Go to tag at point.

\(fn)" t nil)

(autoload 'elm-mode-generate-tags "elm-tags" "\
Generate a TAGS file for the current project.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "elm-tags" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-tags.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-tags.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-tags" '("elm-tags-")))

;;;***

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "elm-util" "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-util.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-util.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "elm-util" '("elm-")))

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-font-lock.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-format.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-imenu.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-indent.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-interactive.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-mode.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-tags.el"
;;;;;;  "../../../../../.emacs.d/elpa/elm-mode-20191125.1919/elm-util.el"
;;;;;;  "elm-font-lock.el" "elm-format.el" "elm-imenu.el" "elm-indent.el"
;;;;;;  "elm-interactive.el" "elm-mode.el" "elm-tags.el" "elm-util.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; elm-mode-autoloads.el ends here
