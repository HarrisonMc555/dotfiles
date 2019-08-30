;;; my-functions.el --- Personal functions              -*- lexical-binding: t; -*-

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

(defun show-file-name ()
  "Show the full path file name in the minibuffer"
  (interactive)
  (message (buffer-file-name)))

(defun revert-buffer-no-confirmation (&optional force-reverting)
  "Revert the buffer without prompting for confirmation"
  (interactive "P")
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer nil t t)
    (error "The buffer has been modified")))

(defun comment-and-copy ()
  "Comments the selection and copies it (uncommented) immediately below."
  (interactive)
  (if (use-region-p)
      (progn (kill-ring-save (region-beginning) (region-end))
             (comment-region (region-beginning) (region-end))
             (goto-char (region-end))
             (yank))
    (let ((p (point)) (m (mark)))
      (select-current-line)
      (next-logical-line)
      (beginning-of-line nil)
      (comment-and-copy)
      (goto-char p)
      (next-logical-line)
      (beginning-of-line nil))))

(defun select-current-line ()
  "Select the current line"
  (interactive)
  (beginning-of-line nil)
  (set-mark-command nil)
  (end-of-line nil)
  (setq deactivate-mark nil))

(defun comment-dwim-custom ()
  "Comment the current line"
  (interactive)
  (if (use-region-p)
      (progn
        (message "Using region")
        (comment-dwim nil))
    (let ((p (point)))
      (select-current-line)
      (comment-dwim nil)
      (beginning-of-line nil))))

(defun copy-line ()
  "Acts the same as kill-line but doesn't delete the line"
  (interactive)
  (if (use-region-p)
      (nil)
    (kill-ring-save (point) (1+ (line-end-position)))
    (goto-char (line-end-position))
    (forward-char)))

(defun indent-dwim ()
  "Indents the current selective if active, else the current line"
  (interactive)
  (if (use-region-p)
      (indent-region (region-beginning) (region-end))
    (indent-region (line-beginning-position) (line-end-position))))

(with-library
 ps-print
 (when (executable-find "ps2pdf")
   (defun pdf-print-buffer-with-faces (&optional filename)
      "Print file in the current buffer as pdf, including font, color, and
underline information.  This command works only if you are using a window system,
so it has a way to determine color values.

C-u COMMAND prompts user where to save the Postscript file (which is then
converted to PDF at the same location."
      (interactive (list (if current-prefix-arg
                             (ps-print-preprint 4)
                           (concat (file-name-sans-extension (buffer-file-name))
                                   ".ps"))))
      (ps-print-with-faces (point-min) (point-max) filename)
      (shell-command (concat "ps2pdf " filename))
      (delete-file filename)
      (message "Deleted %s" filename)
      (message "Wrote %s" (concat (file-name-sans-extension filename) ".pdf")))))

(defun load-dot-emacs ()
  "Load the dot Emacs file in the home directory."
  (interactive)
  (load-file "~/.emacs"))

(defun load-gui-elisp ()
  "Load the GUI code."
  (interactive)
  (load-file "~/.emacs.d/harrison/my-gui.el"))

(defun surround-with-parentheses ()
  "Surround sexp at point in parentheses."
  (interactive)
  (progn (insert ?\()
         (forward-sexp)
         (insert ?\))
         (backward-sexp)
         (forward-char)))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(with-library
 hideshow

 (defun toggle-selective-display (column)
   (interactive "P")
   (set-selective-display
    (or column
        (unless selective-display
          (1+ (current-column)))))))

;; org mode
(defun org-convert-to-checkbox ()
  (interactive)
  (move-beginning-of-line nil)
  (search-forward-regexp "[^ ]")
  (forward-char 1)
  (insert "[ ] "))

(defun org-convert-to-checkbox-goto-next-item ()
  "Inserts a checkbox at the current item, then goes to the next item."
  (interactive)
  (org-convert-to-checkbox)
  (org-next-item))

(defun org-convert-all-items-to-checkboxes ()
  "Inserts checkboxes in all items at the current level."
  (interactive)
  (save-excursion
    (condition-case nil
        (while (org-previous-item))
      ('error))
    (condition-case nil
        (while (add-checkbox-goto-next-item))
      ('error))))

(defun org-insert-checkbox-respect-contents ()
  "Inserts a checkbox after the contents of the current item"
  (interactive)
  (condition-case nil
      (progn
        (org-next-item)
        (org-insert-item t))
    ('error
     (move-end-of-line nil)
     (org-insert-todo-heading nil))))

;; Debugging printing information about selected region
(defun region-info ()
  "Region info"
  (interactive)
  (message (format "Beg:   %d\nEnd:   %d\nMark:  %d\nPoint: %d"
                   (region-beginning)
                   (region-end)
                   (mark)
                   (point))))

;; ;; Load .el files (recursively)
;; (defun load-recursively (directory)
;;   (dolist (file-name (directory-files directory))
;;     (unless (string-prefix-p "." file-name)
;;       (let ((path (concat (file-name-as-directory directory)
;;                           file-name)))
;;         (if (f-file? path)
;;             (if (string-suffix-p ".el" path)
;;                 (load path))
;;           (load-recursively path))))))

;; (load-recursively "~/.emacs.d/custom/")

(defun my-flymd-browser-function (url)
  (let ((browse-url-browser-function 'browse-url-firefox))
    (browse-url url)))
(setq flymd-browser-open-function 'my-flymd-browser-function)

(defun unhighlight-all-in-buffer ()
  "Remove all highlights made by `hi-lock' from the current buffer.
The same result can also be be achieved by \\[universal-argument] \\[unhighlight-regexp]."
  (interactive)
  (unhighlight-regexp t))

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

(defun cells-to-identifier ()
  (interactive)
  ;; http://ergoemacs.org/emacs/elisp_find_replace_text.html
  (save-restriction
    (narrow-to-region (point) (mark))
    (goto-char (point-min))
    (while (search-forward " " nil t)
      (replace-match ""))
    (while (search-forward "	" nil t)
      (replace-match "_"))
    (while (re-search-forward "\\W" nil t)
      (replace-match ""))
    (downcase-region (point-min) (point-max))
    (goto-char (point-min))))

(provide 'my-functions)
;;; my-functions.el ends here
