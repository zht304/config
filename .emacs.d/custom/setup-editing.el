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
(add-hook 'diff-mode-hook
          (lambda ()
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


(defvar yank-advised-indent-threshold 1000
  "Threshold (chars ) over which indentation does not auto occur")

(defun yank-advised-indent-function (beg end)
  "Do indentation as long as the region is not too large."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(defadvice yank (after yank-indent activate)
  "If current mode is one of the 'yank-indent-modes, indent
yanked text (with prefix arg doesn't indent)."
  (if(and (not (ad-get-arg 0))
          (not (member major-mode yank-indent-blacklisted-modes))
          (or (derived-mode-p 'prog-mode)
              (member major-mode yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

(defadvice yank-pop (after yank-pop-indent activate)
  "If current mode is one of the 'yank-indent-modes, indent
yanked text (with prefix arg doesn't indent)."
  (if(and (not (ad-get-arg 0))
          (not (member major-mode yank-indent-blacklisted-modes))
          (or (derived-mode-p 'prog-mode)
              (member major-mode yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

;;
(defun prelude-duplicate-current-line-or-region (arg)
  "Duplicate the current line or region ARG times.
If there is no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated.
The duplicated contents are appened after the next line of the origin
line"
  (interactive "p")
  (pcase-let* ( (origin (point))
                (`(,beg . ,end) (prelude-get-positions-of-line-or-region))
                (region (buffer-substring-no-properties beg end)))
    (-dotimes arg
      (lambda (n) "duplicate"
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point))))
    (goto-char (+ origin (* (length region) arg) arg))))


(defun prelude-get-positions-of-line-or-region ()
  "Return positions (beg . end) of the current line or region."
  (let (beg end) ;nil two var
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (cons beg end)))


(defun indent-buffer()
  "Indent the current buffer."
  (interactive)
  (indent-region (point-min) (point-max)))


(defcustom prelude-indent-sensitive-modes
  '(coffee-mode python-mode slim-mode halm-mode yaml-mode)
  "Modes for which auto-indenting is suppressed."
  :type 'list)

(defun indent-region-or-buffer ()
  "Indent a region if selected. otherwise the whole buffer."
  (interactive)
  (unless (member major-mode prelude-indent-sensitive-modes)
    (save-excursion
      (if (region-active-p)
          (progn
            (indent-region (region-beginning) (region-end))
            (message "Indenting selected region.")
            )
        (progn
          (indent-buffer)
          (message "Indent buffer.")
          )
        (whitespace-cleanup)))))

(global-set-key (kbd "C-c i") 'indent-region-or-buffer)

;; kill the current buffer
(defun kill-default-buffer ()
  "Kill the currently active buffer"
  (interactive)
  (let (kill-buffer-query-functions)
    (kill-buffer)))

(global-set-key (kbd "C-x k") 'kill-default-buffer)

(defun prelude-smart-open-line (arg)
  "Insert an empty line after the current line.
Position the cursion at its beginning. according to the current
mode. With a prefix ARG open line above the current line."
  (interactive "P")
  (if arg
      (prelude-smart-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))


(defun prelude-smart-open-line-above ()
  "Insert an empty line before the current line.
Position the cursor at its begining."
  (interactive)
  (progn
    (move-beginning-of-line nil)
    (newline-and-indent)
    (forward-line -1)
    (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'prelude-smart-open-line)
(global-set-key (kbd "M-o") 'open-line)

;; dulicate thing...
(use-package duplicate-thing
  :ensure t
  :bind ("M-c" . duplicate-thing))

(use-package volatile-highlights
  :ensure t
  :config 
(volatile-highlights-mode t))


(use-package smartparens
  :ensure t
  :init
   (setq sp-base-key-bindings 'paredit)
   (setq sp-autoskip-closing-pair 'always)
   (setq sp-hybrid-kill-entire-symbol nil)
  :config (sp-use-paredit-bindings))


(use-package clean-aindent-mode
  :ensure t
  :config 
  (add-hook 'prog-mode-hook 'clean-aindent-mode))
