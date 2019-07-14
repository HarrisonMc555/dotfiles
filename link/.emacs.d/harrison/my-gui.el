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

(with-library
 tabbar
 (tabbar-mode)
 (global-set-key (kbd "C-c C-t") 'tabbar-mode)
 (global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
 (global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)
 (global-set-key (kbd "<C-S-iso-lefttab>") 'tabbar-backward-tab)
 (global-set-key (kbd "C-c n") 'tabbar-forward-group)
 (global-set-key (kbd "C-c p") 'tabbar-backward-group)
 (global-set-key (kbd "<M-up>") 'tabbar-forward-group)
 (global-set-key (kbd "<M-down>") 'tabbar-backward-group)
 (global-set-key (kbd "<M-wheel-up>") 'tabbar-forward-group)
 (global-set-key (kbd "<M-wheel-down>") 'tabbar-backward-group))

(provide 'my-gui)
;;; my-gui.el ends here