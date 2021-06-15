;;; wucuo-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "wucuo" "wucuo.el" (0 0 0 0))
;;; Generated autoloads from wucuo.el

(autoload 'wucuo-register-extra-typo-detection-algorithms "wucuo" "\
Register extra typo detection algorithms." nil nil)

(autoload 'wucuo-current-font-face "wucuo" "\
Get font face under cursor.
If QUIET is t, font face is not output.

\(fn &optional QUIET)" t nil)

(autoload 'wucuo-split-camel-case "wucuo" "\
Split camel case WORD into a list of strings.
Ported from 'https://github.com/fatih/camelcase/blob/master/camelcase.go'.

\(fn WORD)" nil nil)

(autoload 'wucuo-check-camel-case-word-predicate "wucuo" "\
Use aspell to check WORD.  If it's typo return t.

\(fn WORD)" nil nil)

(autoload 'wucuo-typo-p "wucuo" "\
Spell check WORD and return t if it's typo.
This is slow because new shell process is created.

\(fn WORD)" nil nil)

(autoload 'wucuo-generic-check-word-predicate "wucuo" "\
Function providing per-mode customization over which words are spell checked.
Returns t to continue checking, nil otherwise." nil nil)

(autoload 'wucuo-create-aspell-personal-dictionary "wucuo" "\
Create aspell personal dictionary." t nil)

(autoload 'wucuo-create-hunspell-personal-dictionary "wucuo" "\
Create hunspell personal dictionary." t nil)

(autoload 'wucuo-version "wucuo" "\
Output version." nil nil)

(autoload 'wucuo-spell-check-visible-region "wucuo" "\
Spell check visible region in current buffer." t nil)

(autoload 'wucuo-spell-check-buffer "wucuo" "\
Spell check current buffer." nil nil)

(autoload 'wucuo-start "wucuo" "\
Turn on wucuo to spell check code.  ARG is ignored.

\(fn &optional ARG)" t nil)

(autoload 'wucuo-aspell-cli-args "wucuo" "\
Create arguments for aspell cli.
If RUN-TOGETHER is t, aspell can check camel cased word.

\(fn &optional RUN-TOGETHER)" nil nil)

(autoload 'wucuo-flyspell-highlight-incorrect-region-hack "wucuo" "\
Don't mark doublon (double words) as typo.  ORIG-FUNC and ARGS is part of advice.

\(fn ORIG-FUNC &rest ARGS)" nil nil)

(autoload 'wucuo-spell-check-file "wucuo" "\
Spell check FILE and report all typos.
If KILL-EMACS-P is t, kill the Emacs and set exit program code.
If FULL-PATH-P is t, always show typo's file full path.
Return t if there is typo.

\(fn FILE &optional KILL-EMACS-P FULL-PATH-P)" nil nil)

(autoload 'wucuo-find-file-predicate "wucuo" "\
True if FILE does match `wucuo-find-file-regexp'.
And FILE does not match `wucuo-exclude-file-regexp'.
DIR is the directory containing FILE.

\(fn FILE DIR)" nil nil)

(autoload 'wucuo-find-directory-predicate "wucuo" "\
True if DIR is not a dot file, and not a symlink.
And DIR does not match `wucuo-exclude-directories'.
PARENT is the parent directory of DIR.

\(fn DIR PARENT)" nil nil)

(autoload 'wucuo-spell-check-directory "wucuo" "\
Spell check DIRECTORY and report all typos.
If KILL-EMACS-P is t, kill the Emacs and set exit program code.
If FULL-PATH-P is t, always show typo's file full path.

\(fn DIRECTORY &optional KILL-EMACS-P FULL-PATH-P)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "wucuo" '("wucuo-")))

;;;***

;;;### (autoloads nil "wucuo-flyspell-html-verify" "wucuo-flyspell-html-verify.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from wucuo-flyspell-html-verify.el

(autoload 'wucuo-flyspell-html-verify "wucuo-flyspell-html-verify" "\
Verify typo in html and xml file." nil nil)

;;;***

;;;### (autoloads nil "wucuo-flyspell-org-verify" "wucuo-flyspell-org-verify.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from wucuo-flyspell-org-verify.el

(autoload 'wucuo-flyspell-org-verify "wucuo-flyspell-org-verify" "\
Verify typo in org file." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "wucuo-flyspell-org-verify" '("wucuo-org-mode-code-snippet-p")))

;;;***

;;;### (autoloads nil "wucuo-sdk" "wucuo-sdk.el" (0 0 0 0))
;;; Generated autoloads from wucuo-sdk.el

(autoload 'wucuo-sdk-current-line "wucuo-sdk" "\
Current line." nil nil)

(autoload 'wucuo-sdk-get-font-face "wucuo-sdk" "\
Get font face at POSITION.

\(fn POSITION)" nil nil)

;;;***

;;;### (autoloads nil nil ("wucuo-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; wucuo-autoloads.el ends here
