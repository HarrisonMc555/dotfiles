;;; clang-format-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "../../../.dotfiles/link/.emacs.d/elpa/clang-format-20191121.1708/clang-format"
;;;;;;  "clang-format.el" "79bc1e87ac5f2047220f6450581a96de")
;;; Generated autoloads from clang-format.el

(autoload 'clang-format-region "../../../.dotfiles/link/.emacs.d/elpa/clang-format-20191121.1708/clang-format" "\
Use clang-format to format the code between START and END according to STYLE.
If called interactively uses the region or the current statement if there is no
no active region. If no STYLE is given uses `clang-format-style'. Use
ASSUME-FILE-NAME to locate a style config file, if no ASSUME-FILE-NAME is given
uses the function `buffer-file-name'.

\(fn START END &optional STYLE ASSUME-FILE-NAME)" t nil)

(autoload 'clang-format-buffer "../../../.dotfiles/link/.emacs.d/elpa/clang-format-20191121.1708/clang-format" "\
Use clang-format to format the current buffer according to STYLE.
If no STYLE is given uses `clang-format-style'. Use ASSUME-FILE-NAME
to locate a style config file. If no ASSUME-FILE-NAME is given uses
the function `buffer-file-name'.

\(fn &optional STYLE ASSUME-FILE-NAME)" t nil)

(defalias 'clang-format 'clang-format-region)

;;;### (autoloads "actual autoloads are elsewhere" "../../../.dotfiles/link/.emacs.d/elpa/clang-format-20191121.1708/clang-format"
;;;;;;  "clang-format.el" (0 0 0 0))
;;; Generated autoloads from clang-format.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "../../../.dotfiles/link/.emacs.d/elpa/clang-format-20191121.1708/clang-format" '("clang-format-")))

;;;***

;;;***

;;;### (autoloads nil "clang-format" "../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format.el"
;;;;;;  "79bc1e87ac5f2047220f6450581a96de")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format.el

(autoload 'clang-format-region "clang-format" "\
Use clang-format to format the code between START and END according to STYLE.
If called interactively uses the region or the current statement if there is no
no active region. If no STYLE is given uses `clang-format-style'. Use
ASSUME-FILE-NAME to locate a style config file, if no ASSUME-FILE-NAME is given
uses the function `buffer-file-name'.

\(fn START END &optional STYLE ASSUME-FILE-NAME)" t nil)

(autoload 'clang-format-buffer "clang-format" "\
Use clang-format to format the current buffer according to STYLE.
If no STYLE is given uses `clang-format-style'. Use ASSUME-FILE-NAME
to locate a style config file. If no ASSUME-FILE-NAME is given uses
the function `buffer-file-name'.

\(fn &optional STYLE ASSUME-FILE-NAME)" t nil)

(defalias 'clang-format 'clang-format-region)

;;;### (autoloads "actual autoloads are elsewhere" "clang-format"
;;;;;;  "../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "clang-format" '("clang-format-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/clang-format-20191121.1708/clang-format.el"
;;;;;;  "clang-format.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; clang-format-autoloads.el ends here
