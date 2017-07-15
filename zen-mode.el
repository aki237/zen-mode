;;; zen-mode.el --- Zen Editing Mode for emacs

;; Copyright (C) 2017 Akilan Elango

;; Author: Akilan Elango <akilan1997 [at] gmail.com>
;; Keywords: convenience
;; X-URL: https://github.com/aki237/zen-mode
;; URL: https://github.com/aki237/zen-mode
;; Version: 0.0.1

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
;; Zen mode for emacs is a distraction free editing mode for emacs.
;;
;;; Installation:
;;
;;   (require 'zen-mode)
;;
;;; Use:
;; This is used to start a distraction free editing session in emacs like in
;; Sublime Text.
;;
;;; Code:

;; require


;; variables
(defvar zen-mode:disable-mode-line t
  "Zen mode option to hide the mode line. Set true to hide the mode line in Zen-mode.")

;;;###autoload
(define-minor-mode zen-mode
  "Sublime like zen mode for Emacs"
  :lighter " Zen"
  (zen-run)
  )

;; functions
(defun zen-run()
  "This function actually activates the zen by disabling all visual obstructions"
  (defvar-local zen-run-mode nil)
  (defvar-local zen-mode-line-cache nil)
  (defvar-local zen-menubar-state menu-bar-mode)
  (defvar-local zen-toolbar-state tool-bar-mode)
  (defvar-local zen-linum-state (if (boundp 'linum-mode) linum-mode nil))
  (defvar-local zen-blink-cursor-state blink-cursor-mode)
  (defvar-local zen-lm-state left-margin-width)
  (defvar-local zen-rm-state right-margin-width)
  (defvar-local zen-lf-state left-fringe-width)
  (defvar-local zen-rf-state right-fringe-width)
  (if zen-run-mode
      (progn
        (message "Distraction free disabled")

	(if zen-linum-state
	    (linum-mode 1))
	
	(if zen-blink-cursor-state
	    (blink-cursor-mode 1))

	(if zen-mode:disable-mode-line
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
        (toggle-frame-fullscreen)
        (set-window-buffer nil (current-buffer))
        (setq zen-run-mode nil))
    (progn
      (if zen-mode:disable-mode-line
          (progn
            (setq zen-mode-line-cache mode-line-format)
            (setq mode-line-format nil)))
      (message "Distraction free enabled")
      (set-frame-parameter nil 'fullscreen 'fullboth)
      (linum-mode -1)
      (setq right-fringe-width 0)
      (setq left-fringe-width 0)
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (blink-cursor-mode -1)
      (setq left-margin-width 40)
      (setq right-margin-width 40)
      (set-window-buffer nil (current-buffer))
      (setq zen-run-mode t))))

(provide 'zen-mode)

;; coding: utf-8
;; End:
;;; zen-mode.el ends here
