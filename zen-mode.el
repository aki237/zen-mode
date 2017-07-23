;;; zen-mode.el --- Zen Editing Mode

;; Copyright (C) 2017 Akilan Elango

;; Author: Akilan Elango <akilan1997 [at] gmail.com>
;; Keywords: convenience
;; X-URL: https://github.com/aki237/zen-mode
;; URL: https://github.com/aki237/zen-mode
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))

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
;; Zen mode for Emacs is a distraction free editing mode for Emacs.
;;
;;; Installation:
;;
;;   (require 'zen-mode)
;;
;;; Use:
;; This is used to start a distraction free editing session in Emacs like in
;; Sublime Text.
;;
;;; Code:

;; require


;; variables
(defvar zen-mode-disable-mode-line t
  "Zen mode option to hide the mode line.  Set true to hide the mode line in Zen-mode.")

;; local variables
(defvar-local zen-run-mode nil
  "zen-run-mode variable is to set state of whether zen mode is enabled in the current buffer"
  )

(defvar-local zen-mode-margin-width (/ (/ (display-pixel-width) (/ (window-pixel-width) (window-width))) 5)
  "Zen mode option to specify the margin width."
  )

(defvar-local zen-mode-line-cache nil
  "zen-mode-line-cache variable is used to save the modeline format content for future when it is disabled"
  )

(defvar-local zen-menubar-state nil
  "zen-menubar-state variable is used to save whether menu-bar-mode is enabled before entering the zen mode"
  )

(defvar-local zen-toolbar-state nil
  "zen-toolbar-state variable is used to save whether tool-bar-mode is enabled before entering the zen mode"
  )

(defvar-local zen-linum-state nil
  "zen-linum-state variable is used to save whether linum-mode is enabled before entering the zen mode"
  )

(defvar-local zen-blink-cursor-state nil
  "zen-blink-cursor-state variable is used to save whether blink-cursor-mode is enabled before entering the zen mode"
  )

(defvar-local zen-lm-state 0
  "zm-lm-state variable is used to store the left margin width before the activation of zen-mode"
  )

(defvar-local zen-rm-state 0
  "zm-rm-state variable is used to store the right margin width before the activation of zen-mode"
  )


(defvar-local zen-lf-state 0
  "zm-lf-state variable is used to store the left fringe width before the activation of zen-mode"
  )

(defvar-local zen-rf-state 0
  "zm-rf-state variable is used to store the right fringe width before the activation of zen-mode"
  )

(defvar-local zen-fullscreen-state nil
  "zm-fullscreen-state variable is used to store fullscreen state before the activation of zen-mode"
  )

;;;###autoload
(define-minor-mode zen-mode
  "zen-mode is a distraction free editing mode for Emacs"
  :lighter " Zen"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-<") 'zen-mode-increase-margin-width)
            (define-key map (kbd "C-c C->") 'zen-mode-decrease-margin-width)
            map)
  (zen-run)
  )

;; functions
(defun zen-run()
  "zen-run is a lisp function which activates and deactivates the zen-mode"
  (if zen-run-mode
      (progn
        (message "Distraction free disabled")
        (setq window-size-change-functions (remove 'zen-mode-refresh-buffer 'window-size-change-functions))
	(if zen-linum-state
	    (linum-mode 1))
	
	(if zen-blink-cursor-state
          (blink-cursor-mode 1))

	(if zen-mode-disable-mode-line
          (progn
            (setq mode-line-format zen-mode-line-cache)))

	(if zen-toolbar-state
	    (tool-bar-mode 1))

	(if zen-menubar-state
	    (menu-bar-mode 1))
	(setq left-fringe-width zen-lf-state)
	(setq right-fringe-width zen-rf-state)
	(setq left-margin-width zen-lm-state)
        (setq right-margin-width zen-rm-state)
        (set-frame-parameter nil 'fullscreen 'zen-fullscreen-state)
        (set-window-buffer nil (current-buffer))
        (setq zen-run-mode nil))
    (progn
      (if zen-mode-disable-mode-line
          (progn
            (setq zen-mode-line-cache mode-line-format)
            (setq mode-line-format nil)))

      (setq zen-menubar-state (and (boundp 'menu-bar-mode) menu-bar-mode))

      (setq zen-toolbar-state (and (boundp 'tool-bar-mode) tool-bar-mode))

      (setq zen-linum-state (and (boundp 'linum-mode) linum-mode))

      (setq zen-blink-cursor-state (and (boundp 'blink-cursor-mode) blink-cursor-mode))

      (setq zen-lm-state left-margin-width)

      (setq zen-rm-state right-margin-width)

      (setq zen-lf-state left-fringe-width)

      (setq zen-rf-state right-fringe-width)

      (setq zen-fullscreen-state (frame-parameter (selected-frame) 'fullscreen))
      
      (message "Distraction free enabled")
      (add-to-list 'window-size-change-functions 'zen-mode-refresh-buffer)
      (set-frame-parameter nil 'fullscreen 'fullboth)
      (linum-mode -1)
      (setq right-fringe-width 0)
      (setq left-fringe-width 0)
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (blink-cursor-mode -1)
      (zen-mode-set-margins)
      (setq zen-run-mode t))))

(defun zen-mode-increase-margin-width()
  "zen-mode-increase-margin-width is a interactive lisp function to increase the margin width in zen-mode (by 5 units)."
  (interactive)
  (setq zen-mode-margin-width (+ zen-mode-margin-width 5))
  (zen-mode-set-margins)
  )

(defun zen-mode-decrease-margin-width()
  "zen-mode-increase-margin-width is a interactive lisp function to increase the margin width in zen-mode (by 5 units)."
  (interactive)
  (setq zen-mode-margin-width (+ zen-mode-margin-width -5))
  (zen-mode-set-margins)
  )

(defun zen-mode-set-margins()
  "zen-mode-set-margins is a lisp function to set the margin width (both left and right)."
  (setq left-margin-width zen-mode-margin-width)
  (setq right-margin-width zen-mode-margin-width)
  (set-window-buffer nil (current-buffer))
  )

(defun zen-mode-refresh-buffer(frame)
  "zen-mode-refresh-buffer is a lisp function to refresh the buffer's margin width when window is resized"
  (setq zen-mode-margin-width (/ (/ (display-pixel-width) (/ (window-pixel-width) (window-width))) 5))
  (zen-mode-set-margins)
  )

(provide 'zen-mode)

;; coding: utf-8
;; End:
;;; zen-mode.el ends here
