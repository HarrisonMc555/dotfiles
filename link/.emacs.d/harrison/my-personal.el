;;; my-personal.el --- Personal customizations          -*- lexical-binding: t; -*-

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

;; Enable subword mode (treats camel case as word breaks)
(subword-mode t)

;; Switching buffers
(global-set-key (kbd "C-x n") 'next-buffer)
(global-set-key (kbd "C-x p") 'previous-buffer)

;; Auto fill mode
(add-hook 'text-mode-hook #'turn-on-auto-fill)
(add-hook 'prog-mode-hook #'turn-on-auto-fill)

;; Electric minibuffer mode
(minibuffer-electric-default-mode nil)

;; No yes-or-no, only y-or-n
(defalias 'yes-or-no-p 'y-or-n-p)

(with-library
 company
 (company-mode))

(with-library
 hideshow
 (add-hook 'c-mode-common-hook   #'hs-minor-mode)
 (add-hook 'emacs-lisp-mode-hook #'hs-minor-mode)
 (add-hook 'java-mode-hook       #'hs-minor-mode)
 (add-hook 'lisp-mode-hook       #'hs-minor-mode)
 (add-hook 'perl-mode-hook       #'hs-minor-mode)
 (add-hook 'sh-mode-hook         #'hs-minor-mode)
 (add-hook 'vhdl-mode-hook       #'hs-minor-mode))
;; (add-to-list 'hs-special-modes-alist
;;              '(vhdl-mode "(begin|then|generate)" "end"))
;; (add-hook 'vhdl-mode-common-hook
;;   (lambda()
;;     (local-set-key (kbd "C-c <right>") 'hs-show-block)
;;     (local-set-key (kbd "C-c <left>")  'hs-hide-block)
;;     (local-set-key (kbd "C-c <up>")    'hs-hide-all)
;;     (local-set-key (kbd "C-c <down>")  'hs-show-all)
;;     (hs-minor-mode t)))

(with-library
 elec-pair
 (electric-pair-mode))

(setq linum-format "%d ")

(setq vc-follow-symlinks t)

(defun my-terminal-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell       nil
      ring-bell-function #'my-terminal-visible-bell)
;; (setq visible-bell 1)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-hook 'markdown-mode-hook
          (lambda ()
            (modify-syntax-entry ?` "$`" org-mode-syntax-table)))
(add-hook 'org-mode-hook
          (lambda ()
            (modify-syntax-entry ?~ "$~" org-mode-syntax-table)))

(setq org-export-with-section-numbers nil)

(if (string-equal system-type "darwin")
    (add-to-list 'exec-path "/usr/local/bin/"))

(add-hook 'after-init-hook #'global-emojify-mode)
;; (setq emojify-composed-text-p nil)
;; (emojify-set-emoji-styles '('unicode))

(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

(global-auto-revert-mode)
(setq revert-without-query t)

(setq ido-enable-flex-matching t)
(ido-mode 1)

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (define-key ibuffer-mode-map "\C-x\C-f"
              'ibuffer-ido-find-file)))

;; (setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/.local/bin/")))
;; (setq exec-path (append exec-path (expand-file-name "~/.local/bin/")))

(defvar exercism-workspace
  ;; (trim-whitespace (shell-command-to-string "exercism workspace")))
  "/Users/harrisonmccullough/exercism")

(defun exercism-mentor-hook ()
  "Run when in exercism mentor directory"
  (auto-fill-mode -1)
  (visual-fill-column-mode)
  (visual-line-mode)
  (flyspell-mode)
  (setq-local require-final-newline nil)
  )

(defun exercism-mentor-dir-p (file)
  "Return true if the file is in the exercism mentor directory"
  (let ((mentor-dir (join-dirs exercism-workspace "mentor")))
    (and file (string-prefix-p mentor-dir file))))

(defun exercism-mentor-find-file-hook ()
  "If in the exercism mentor directory, run exercism-mentor-hook"
  (when (exercism-mentor-dir-p (buffer-file-name))
      (exercism-mentor-hook)))

(add-hook 'find-file-hook 'exercism-mentor-find-file-hook)

;; Magit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-git-commit-setup-hook ()
  (let ((alert-project-dir "/Projects/Alert"))
    (when (string-prefix-p  file)
      (draft-mode))))

(add-hook 'git-commit-setup-hook 'my-git-commit-setup-hook)

;(setq tmp-directory "/tmp")
;(when (file-directory-p tmp-directory)
;  (open-dribble-file tmp-directory))

(edit-server-start)

(provide 'my-personal)
;;; my-personal.el ends here
