(defun gtags/init-ggtags ()
  (use-package ggtags
    :defer t
    :config
    (when (package-usedp 'helm-gtags)
      ;; If anyone uses helm-gtags, they would want to use these key bindings.
      ;; These are bound in `ggtags-mode-map', since the functionality of
      ;; `helm-gtags-mode' is basically entirely contained within
      ;; `ggtags-mode-map' --- this way we don't have to enable both.
      ;; Note: all of these functions are autoloadable.
      (define-key ggtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
      (define-key ggtags-mode-map (kbd "C-x 4 .") 'helm-gtags-find-tag-other-window)
      (define-key ggtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
      (define-key ggtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack))))

(defun gtags/init-helm-gtags ()
  (use-package helm-gtags
    :defer t
    :init
    (progn
      (setq helm-gtags-ignore-case t
            helm-gtags-auto-update t
            helm-gtags-use-input-at-cursor t
            helm-gtags-pulse-at-cursor t))))

(gtags/init-helm-gtags)
(gtags/init-ggtags)

 (provide 'setup-programming)
