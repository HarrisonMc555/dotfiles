;;; my-files.el --- Dealing with files                  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Harrison

;; Author: Harrison <harrison@saturn>
;; Keywords: files

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

(defun load-current-file ()
  "Loads the current file"
  (interactive)
  (load-file (buffer-file-name)))

(defun kill-current-buffer ()
  "Kill the current buffer"
  (interactive)
  (kill-buffer (current-buffer)))

(defvar killed-file-list nil
  "List of recently killed files.")

(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (if killed-file-list
      (find-file (pop killed-file-list))
    (message "No recently killed file.")))

;; recentf
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(setq recentf-max-saved-items 100)

(provide 'my-files)
;;; my-files.el ends here
