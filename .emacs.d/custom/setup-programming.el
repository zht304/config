;; (defun gtags/init-ggtags ()
;;   (use-package ggtags
;;     :defer t
;;     :config
;;     (when (package-usedp 'helm-gtags)
;;       ;; If anyone uses helm-gtags, they would want to use these key bindings.
;;       ;; These are bound in `ggtags-mode-map', since the functionality of
;;       ;; `helm-gtags-mode' is basically entirely contained within
;;       ;; `ggtags-mode-map' --- this way we don't have to enable both.
;;       ;; Note: all of these functions are autoloadable.
;;       (define-key ggtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;;       (define-key ggtags-mode-map (kbd "C-x 4 .") 'helm-gtags-find-tag-other-window)
;;       (define-key ggtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;       (define-key ggtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack))))


;;(gtags/init-ggtags)


;;;;;;;;;;;;;; python;;;
(use-package elpy)
(use-package py-autopep8)

(elpy-enable)
(require 'py-autopep8 )
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

 (provide 'setup-programming)
