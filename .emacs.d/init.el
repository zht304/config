(global-set-key (kbd "C-x C-b") 'ibuffer)


(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
	      (ggtags-mode 1))))

(add-hook 'dired-mode-hook 'ggtags-mode)


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

(require 'workgroups2)
(workgroups-mode 1)
