(global-set-key (kbd "C-x C-b") 'ibuffer)


(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
(if (not (package-installed-p 'use-package))
    (progn (package-refresh-contents)
	   (package-install 'use-package)))
(require 'use-package)


;;(add-hook 'dired-mode-hook 'ggtags-mode)


;; my modules load
(add-to-list 'load-path "~/.emacs.d/custom/")
(mapc 'load (directory-files "~/.emacs.d/custom" t ".*\.el$"))

(require 'setup-applications)
(require 'setup-communication)
(require 'setup-convenience)
(require 'setup-data)
(require 'setup-development)
(require 'setup-editing)
(require 'setup-environment)
(require 'setup-external)
(require 'setup-faces-and-ui)
(require 'setup-files)
(require 'setup-help)
(require 'setup-programming)
(require 'setup-text)
(require 'setup-local)


;; package: workgroups2

(use-package workgroups2
  :ensure t
  :config (workgroups-mode 1))
