(provide 'setup-editing)

;; GROUP: editing basic
(setq global-mark-ring-max 5000  ; increase mark ring
      mark-ring-max 5000         ; increase mark ring
      mode-require-final-newline t  ;
      )

(setq-default tab-width 4)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq-default indent-tabs-mode nil)
(delete-selection-mode)
(global-set-key (kbd "RET") 'newline-and-indent)


;; GROUP: Killing
(setq
 kill-ring-max   5000 ;; increase kill-ring capacity
 kill-whole-line t
 )

;; whitespace show in diff-mode
(add-hook 'diff-mode-hook (lambda ()
			    (setq-local whitespace-style
					'(face
					  tabs
					  tab-mark
					  spaces
					  space-mark
					  trailingg
					  indentation::space
					  indentation::tab
					  newline
					  newline-mark))
			    (whitespace-mode 1)))

;;; built-in commands customized
;;; customized function

(defun prelude-move-beginning-of-line (arg)
  "move point back to the indentation of the begining of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character andd
the beginning of the line.

If ARG is not nil or 1, move forward ARG -1 lines first. If point
reaches the beginning or end of the buffer, stop there."

  (interactive "^p") ;number
  (setq arg (or arg 1)) ; if arg is nil or zero, set it to 1.

  ;; move line first
  (when (/= arg 1) ; arg not 1
    (let ((line-move-visual nil))
      (forward-line (- 1 arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a
single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
                 (message "Copied line")
                 (list (line-beginning-position)
                       (line-beginning-position 2)))))

(defadvice kill-region(before slick-cut activate compile)
  "When called interactively with no active region, kill a
single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
                 (list (line-beginning-position)
                       (line-beginning-position 2)))))


(defadvice kill-line (before check-position activate)
  "If position is end of the line, kill a line (C-k) will kill whitespace
characters until next non-whitespace character of next line"
  (if (member major-mode '(emacs-lisp-mode scheme-mode lisp-mode
                                           c-mode c++-mode objc-mode
                                           latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp))) ; end of line, except an empty line.
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

(defvar yank-indent-modes
  '(LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked.
Only modes that don't derive from 'prog-mode' should be listed here")

(defvar yank-indent-blacklisted-modes
  '(python-mode slim-mode halm-mode)
  "Modes for which auto-indenting is suppressed.")


