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

;; Flyspell mode
(add-hook 'text-mode-hook #'flyspell-mode)

;; Save interprogram clipboard
(setq save-interprogram-paste-before-kill t)

;; Electric minibuffer mode
(minibuffer-electric-default-mode nil)

;; Set frame title as file name
(setq-default frame-title-format
              '(:eval
                (format "%s"
                        (buffer-name))))

;; This is intended to maximize emacs on startup.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Default font size
(set-face-attribute 'default nil :height 105)

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

(provide 'my-personal)
;;; my-personal.el ends here
