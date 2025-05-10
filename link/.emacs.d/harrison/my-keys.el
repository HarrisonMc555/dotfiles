;;; my-keys.el --- Generic key bindings                 -*- lexical-binding: t; -*-

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

(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-M-S-s-f") 'execute-extended-command)
(global-set-key (kbd "M-_") (lambda () (interactive ) (insert-char ?—)))

(with-library
 simple
 (global-set-key (kbd "C-j") 'newline)
 (global-set-key (kbd "RET") 'newline-and-indent))

(with-library
 subword
 (global-set-key (kbd "M-s") 'subword-mode))

(with-library
 shell
 (global-set-key (kbd "C-c s") 'shell))

(with-library
 align
 (global-set-key (kbd "C-=") 'align-regexp))

(with-library
 rect
 (global-set-key (kbd "C-x r q") 'string-rectangle))

(with-library
 ibuffer
 (global-set-key (kbd "C-x C-b") 'ibuffer))

(with-library
 whitespace
 (global-set-key (kbd "C-c C-w") 'whitespace-mode)
 (global-set-key (kbd "C-c M-w") 'whitespace-cleanup)
 (global-set-key (kbd "C-c w") 'whitespace-cleanup))

(with-library
 my-files
 (global-set-key (kbd "<f12>") 'write-file)
 (global-set-key (kbd "<M-f4>") 'save-buffers-kill-terminal)
 (global-set-key (kbd "C-c C-l") 'load-current-file))

(with-library
 my-functions
 (global-set-key (kbd "<f5>") 'revert-buffer-no-confirmation)
 (global-set-key (kbd "C-<f1>") 'show-file-name)
 (global-set-key (kbd "C-;") 'comment-and-copy)
 (global-set-key (kbd "C-M-;") 'comment-and-copy)
 (global-set-key (kbd "M-;") 'comment-dwim-custom)
 (global-set-key (kbd "M-k") 'copy-line)
 (global-set-key (kbd "C-/") 'indent-dwim)
 (global-set-key (kbd "M-'") 'indent-dwim)
 (global-set-key (kbd "C-x l") 'load-current-file)
 (global-set-key (kbd "C-x k") 'kill-current-buffer)
 (global-set-key (kbd "C-S-t") 'reopen-killed-file)
 (global-set-key (kbd "C-(") 'surround-with-parentheses)
 (global-set-key (kbd "C-+") 'toggle-hiding)
 (global-set-key (kbd "C-\\") 'toggle-selective-display)
 (global-set-key (kbd "C-S-J") 'join-line))


(if (string-equal system-type "darwin")
    (with-library
     my-functions
     (global-set-key (kbd "s-w") 'kill-current-buffer)))

(with-library
 view
 (global-set-key (kbd "C-v") 'View-scroll-half-page-forward)
 (global-set-key (kbd "M-v") 'View-scroll-half-page-backward))

(with-library
 magit
 (global-set-key (kbd "C-x g") 'magit-status))

(with-library
 flycheck
 (global-set-key (kbd "C-c f") 'flycheck-next-error)
 (global-set-key (kbd "C-c b") 'flycheck-previous-error))

(with-library
 hideshow
 (global-set-key (kbd "s-+") 'hs-show-block)
 (global-set-key (kbd "s-_") 'hs-hide-block))

;; (global-set-key (kbd "C-c <right>") 'hs-show-block)
;; (global-set-key (kbd "C-c <left>")  'hs-hide-block)
;; (global-set-key (kbd "C-c <up>")    'hs-hide-all)
;; (global-set-key (kbd "C-c <down>")  'hs-show-all)

(global-set-key (kbd "C->") 'hi-lock-face-symbol-at-point)
(with-library
 my-functions
 (global-set-key (kbd "C-<") 'unhighlight-all-in-buffer))

(when (fboundp 'org-mode)
  (defun my-org-mode-hook ()
    "Custom org-mode hook."
    (local-set-key (kbd "M-[") 'org-metaleft)
    (local-set-key (kbd "M-]") 'org-metaright)
    (local-set-key (kbd "C-c C-6") 'org-up-element)
    (local-set-key (kbd "<M-S-return>") 'org-insert-checkbox-respect-contents)
    (local-set-key (kbd "C-S-n") 'org-next-item)
    (local-set-key (kbd "C-S-p") 'org-previous-item)
    (local-set-key (kbd "M-q") 'org-fill-paragraph)
    )

  (add-hook 'org-mode-hook 'my-org-mode-hook))

(with-library
 paredit
 (global-set-key (kbd "M-(") 'paredit-wrap-round))

(with-library
 move-text
 (move-text-default-bindings)
 )

;;  recentf
(with-library
 recentf
 (global-set-key (kbd "C-x M-f") 'recentf-open-files))

(with-library
 goto-chg
 (global-set-key (kbd "C-.") 'goto-last-change)
 (global-set-key (kbd "C-,") 'goto-last-change-reverse)
 (global-set-key (kbd "S-s-<backspace>") 'goto-last-change)
 )

;; diff-hl
(with-library
 diff-hl
 (global-set-key (kbd "C-M-S-<up>") 'diff-hl-previous-hunk)
 (global-set-key (kbd "C-M-S-<down>") 'diff-hl-next-hunk))

;; ibuffer
(define-key ibuffer-mode-map (kbd "M-o") 'other-window)

(define-key isearch-mode-map (kbd "C-S-y") #'isearch-yank-kill-literally)

(provide 'my-keys)
;;; my-keys.el ends here
