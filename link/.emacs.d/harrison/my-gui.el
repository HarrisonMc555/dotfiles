;;; my-gui.el --- Customizations only for emacs in GUI mode  -*- lexical-binding: t; -*-

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

(when (package-installed-p 'monokai-theme)
  (load-theme 'monokai t))

;; Set frame title as file name
(setq-default frame-title-format
              '(:eval
                (format "%s"
                        (buffer-name))))

;; This is intended to maximize emacs on startup.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Default font size
(set-face-attribute 'default nil :height 105)

;; Save interprogram clipboard
(setq save-interprogram-paste-before-kill t)

(with-library
 tabbar
 (tabbar-mode)
 (global-set-key (kbd "C-c C-t") 'tabbar-mode)
 (global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
 (global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)
 (global-set-key (kbd "<C-S-iso-lefttab>") 'tabbar-backward-tab)
 (global-set-key (kbd "<M-wheel-up>") 'tabbar-forward-group)
 (global-set-key (kbd "<M-wheel-down>") 'tabbar-backward-group)
 (global-set-key (kbd "s-{") 'tabbar-backward-tab)
 (global-set-key (kbd "s-}") 'tabbar-forward-tab))

(when (string-equal system-type "darwin")
  (global-unset-key (kbd "C-z"))
  (global-unset-key (kbd "s-w"))
  (global-unset-key (kbd "s-t")))

(add-hook 'server-switch-hook (lambda () (select-frame-set-input-focus (selected-frame))))

(tool-bar-mode -1)

;; http://blog.vivekhaldar.com/post/4809065853/dotemacs-extract-interactively-change-font-size
(defun my/zoom-in ()
  "Increase font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (+ (face-attribute 'default :height)
                         10)))

(defun my/zoom-out ()
  "Decrease font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (- (face-attribute 'default :height)
                         10)))

;; change font size, interactively
(global-set-key (kbd "C-M->") 'my/zoom-in)
(global-set-key (kbd "C-M-<") 'my/zoom-out)

;; Quit emacs with delete-frame so you don't accidentally delete last one
(global-set-key (kbd "C-x C-c") 'delete-frame)

(provide 'my-gui)
;;; my-gui.el ends here
