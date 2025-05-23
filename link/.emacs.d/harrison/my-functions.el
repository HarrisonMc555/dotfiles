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
    (let ((pos (min (1+ (line-end-position)) (point-max))))
      (kill-ring-save (point) pos)
      (goto-char pos))))

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
  (search-forward-regexp " ")
  (search-forward-regexp "[^ ]")
  (forward-char -1)
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
        (while (org-convert-to-checkbox-goto-next-item))
      ('error))))

(defun org-insert-checkbox-respect-contents ()
  "Inserts a checkbox after the contents of the current item"
  (interactive)
  (condition-case nil
      (progn
        (org-next-item)
        (org-insert-item t))
    ('error
     (org-end-of-item)
     (backward-char)
     (org-insert-item t))))

;; Debugging printing information about selected region
(defun region-info ()
  "Region info"
  (interactive)
  (message (format (concat
                    "Mark:  %d\n"
                    "Point: %d\n"
                    "Beg:   %d\n"
                    "End:   %d\n"
                    "Chars: %d")
                   (mark)
                   (point)
                   (region-beginning)
                   (region-end)
                   (- (region-end) (region-beginning)))))

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

(defun is-at-end-of-line ()
  "Returns t if the point is at the end of the current line"
  (looking-at "$"))

(defun join-line ()
  (interactive)
  (move-end-of-line nil)
  (delete-horizontal-space)
  (when (not (is-at-end-of-line))
    (user-error "Not at end of line"))
  (delete-char 1)
  (delete-horizontal-space))

(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

(defun center-rectangle (beg end)
  (interactive "*r")
  (kill-rectangle beg end)
  (with-temp-buffer
    (yank-rectangle)
    (setq fill-column (current-column))
    (center-region (point-min) (point-max))
    (goto-char (point-max))
    (move-to-column fill-column t)
    (kill-rectangle (point-min) (point)))
  (goto-char beg)
  (yank-rectangle))

(defun ibuffer-ido-find-file (file &optional wildcards)
  "Like `ido-find-file', but default to the directory of the buffer at point."
  (interactive
   (let ((default-directory
           (let ((buf (ibuffer-current-buffer)))
             (if (buffer-live-p buf)
                 (with-current-buffer buf
                   default-directory)
               default-directory))))
     (list (ido-read-file-name "Find file: " default-directory) t)))
  (find-file file wildcards))

(defun trim-whitespace (string)
  "Trim leading and trailing whitespace"
  (car (split-string string
                     split-string-default-separators
                     t
                     split-string-default-separators)))

(defun join-dirs (root &rest dirs)
  "Joins a series of directories together, like Python's os.path.join,
  (join-dirs \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"

  (if (not dirs)
      root
    (apply 'join-dirs
           (expand-file-name (car dirs) root)
           (cdr dirs))))

(defun draft-mode ()
  "Enable/disable appropriate modes for drafting text that will be copy/pasted
   into another program that doesn't want hard line breaks."
  (interactive)
  (auto-fill-mode -1)
  (visual-fill-column-mode 1)
  (visual-line-mode 1)
  (flyspell-mode 1)
  )

;; Used to paste into isearch-regexp without escaping slashes, etc.
;; https://www.reddit.com/r/emacs/comments/8aepnk/yank_text_in_isearch_without_escape_character/dwzib7n?utm_source=share&utm_medium=web2x&context=3
(defun isearch-yank-kill-literally ()
  "Pull string from kill ring into search string literally."
  (interactive)
  (setq isearch-yank-flag t)
  (let ((string (current-kill 0)))
    (isearch-process-search-string
     string
     (mapconcat 'isearch-text-char-description string ""))))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "BNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; https://gist.github.com/hyOzd/23b87e96d43bca0f0b52
;; based on http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

;; https://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (file-name-nondirectory (buffer-file-name)))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun copy-file-path-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file path '%s' to the clipboard." filename))))

;; Useful tips:
; https://stackoverflow.com/questions/605846/how-do-i-access-the-contents-of-the-current-region-in-emacs-lisp
; https://www.gnu.org/software/emacs/manual/html_node/elisp/String-Conversion.html
; https://emacs.stackexchange.com/questions/12334/elisp-for-applying-command-to-only-the-selected-region
; https://emacs.stackexchange.com/questions/40981/convert-unix-time-to-org-mode-timestamp
; https://stackoverflow.com/questions/14201740/replace-region-with-result-of-calling-a-function-on-region
; File rect.el.gz rectangle-number-lines
; https://emacs.stackexchange.com/questions/24551/how-to-reuse-last-input-in-command-with-a-prompt
; Needs time zones in the form like "America/Chicago", trying to use zones like
; "CST" gives inconsistent results.
(defun convert-region-to-timestamp (beg end &optional zone)
  "Convert the region into a timestamp.

ZONE is the time zone to use, as per format-time-string. When called
interactively with a prefix argument, prompt for ZONE."
  (interactive "r")
  (if (use-region-p)
      (save-excursion
        (let* ((zone (if current-prefix-arg
                         (setq convert-region-to-timestamp-zone
                               (read-string (format "Time zone [%s]: "
                                                    convert-region-to-timestamp-zone)
                                            nil 'convert-region-to-timestamp-zone-history
                                            convert-region-to-timestamp-zone))
                       nil))
               (region-contents (buffer-substring beg end))
               (timestamp-num-raw (string-to-number region-contents))
               ;; Heuristic to distinguish betwen milliseconds and seconds
               (timestamp-seconds (if (< timestamp-num-raw 100000000000)
                                      timestamp-num-raw
                                    (/ timestamp-num-raw 1000.0)))
               (timestamp-time (seconds-to-time timestamp-seconds))
               (timestamp-string (format-time-string "%Y-%m-%d %H:%M:%S.%3N"
                                                     timestamp-time zone)))
          (kill-region beg end)
          (insert timestamp-string)))
    (message "Region is not active")))

(provide 'my-functions)
;;; my-functions.el ends here
