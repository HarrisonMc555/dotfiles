;;; minitest-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "minitest" "minitest.el" (0 0 0 0))
;;; Generated autoloads from minitest.el

(autoload 'minitest-mode "minitest" "\
Minor mode for *_test (minitest) files

If called interactively, enable Minitest mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'minitest-enable-appropriate-mode "minitest" nil nil nil)

(dolist (hook '(ruby-mode-hook enh-ruby-mode-hook)) (add-hook hook 'minitest-enable-appropriate-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "minitest" '("colorize-compilation-buffer" "minitest-")))

;;;***

;;;### (autoloads nil nil ("minitest-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; minitest-autoloads.el ends here
