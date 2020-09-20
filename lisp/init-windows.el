;;; init-windows.el --- Working with windows within frames -*- lexical-binding: t -*-
;;; Commentary:
;; This is not about the "Windows" OS, but rather Emacs's "windows"
;; concept: these are the panels within an Emacs frame which contain
;; buffers.
;;; Code:

;; Make "C-x o" prompt for a target window when there are more than 2
(require-package 'switch-window)
(setq-default switch-window-shortcut-style 'alphabet)
(setq-default switch-window-timeout nil)
(global-set-key (kbd "C-x o") 'switch-window)


;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window -- DISABLED -- 
;;----------------------------------------------------------------------------
(defun split-window-func-with-other-buffer (split-function)
  (lambda (&optional arg)
    "Split this window and switch to the new window unless ARG is provided."
    (interactive "P")
    (funcall split-function)
    (let ((target-window (next-window)))
      (set-window-buffer target-window (other-buffer))
      (unless arg
        (select-window target-window)))))

;;(global-set-key (kbd "C-x 2") (split-window-func-with-other-buffer 'split-window-vertically))
;;(global-set-key (kbd "C-x 3") (split-window-func-with-other-buffer 'split-window-horizontally))

(defun at/toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(global-set-key (kbd "C-x 1") 'at/toggle-delete-other-windows)

;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
(defun split-window-horizontally-instead ()
  "Kill any other windows and re-split such that the current window is on the top half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-horizontally)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(defun split-window-vertically-instead ()
  "Kill any other windows and re-split such that the current window is on the left half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-vertically)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(global-set-key (kbd "C-x |") 'split-window-horizontally-instead)
(global-set-key (kbd "C-x _") 'split-window-vertically-instead)


;; Borrowed from http://postmomentum.ch/blog/201304/blog-on-emacs
(defun at/split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'at/split-window)
      (progn
        (jump-to-register :at/split-window)
        (setq this-command 'at/unsplit-window))
    (window-configuration-to-register :at/split-window)
    (switch-to-buffer-other-window nil)))

(global-set-key (kbd "<f7>") 'at/split-window)


;;(defun at/toggle-current-window-dedication ()
;;  "Toggle whether the current window is dedicated to its current buffer."
;;  (interactive)
;;  (let* ((window (selected-window))
;;         (was-dedicated (window-dedicated-p window)))
;;    (set-window-dedicated-p window (not was-dedicated))
;;    (message "Window %sdedicated to %s"
;;             (if was-dedicated "no longer " "")
;;             (buffer-name))))
;;
;;(global-set-key (kbd "C-c <down>") 'at/toggle-current-window-dedication)

;; Windowed mode options
(when (display-graphic-p)
  ;; Window size
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  ;;(add-to-list 'default-frame-alist '(height . 48))
  ;;(add-to-list 'default-frame-alist '(width . 160))
  ;;(add-to-list 'default-frame-alist '(top . 10))
  ;;(add-to-list 'default-frame-alist '(left . 50))
  ;;(set-frame-font "ProggyClean")

  (set-face-attribute 'default nil :font "Ubuntu Mono 16" )
  (set-frame-font "Ubuntu Mono 16" nil t)

  ;; Disable graphical goodies
  ;; To disable the menu bar, place the following line in your .emacs file:
  (menu-bar-mode -1)
  ;; To disable the scrollbar, use the following line:
  (toggle-scroll-bar -1)
  ;; To disable the toolbar, use the following line:
  (tool-bar-mode -1)

  (run-with-idle-timer 0.001 nil 'toggle-frame-fullscreen)
  ;;(toggle-frame-fullscreen)

  ;; Two windows on start
  ;;(split-window-horizontally)
  ;;(other-window -1)
  ;;(switch-to-buffer (next-buffer))
  ;;(split-window-vertically)
  ;;(other-window 1)
  ;;(other-window 1)
  )


(provide 'init-windows)
;;; init-windows.el ends here
