(if window-system
  (invert-face 'default))

(setq load-prefer-newer t)

;;(add-to-list 'load-path "~/.emacs.d/non-elpa/org-mode/lisp")

(require 'package)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
;;(add-to-list 'package-pinned-packages '(org . "melpa-stable") t)
;;(add-to-list 'package-pinned-packages '(es-mode . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(zenburn-theme . "melpa-stable") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(require 'cl)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq org-directory "~/Documents/Org")
(setq org-agenda-files '("~/Documents/Org"))
(setq org-agenda-files (append org-agenda-files
                         (list (expand-file-name "~/Documents/daypages"))))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(load (concat user-emacs-directory "better-defaults.el"))

(require 'better-defaults)

(defvar my-packages
  '(find-file-in-project
    clojure-mode
    ace-jump-mode
    cider
    company
    company-quickhelp
    dash
    dash-at-point
    epl
    es-mode
    flx-ido
    htmlize
    idle-highlight-mode
    ido-hacks
    ido-ubiquitous
    ido-vertical-mode
    json
    magit
    markdown-mode
    multiple-cursors
    org
    paredit
    projectile
    rainbow-delimiters
    ;;scss-mode
    smex
    ;;tagedit
    tramp
    undo-tree
    yasnippet
    color-theme-sanityinc-solarized
    color-theme-sanityinc-tomorrow
    color-theme-solarized
    zenburn-theme))

(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(mapc 'load (directory-files
             (concat user-emacs-directory user-login-name)
             t "^[^#].*el$"))

(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)

(setq ido-everywhere t)
(ido-vertical-mode 1)

(require 'ido-hacks)
(ido-hacks-mode)

(global-set-key (kbd "M-x") 'smex)

(defalias 'yes-or-no-p 'y-or-n-p)

(column-number-mode t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;(eshell)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1df4f61bb50f58d78e88ea75fb8ce27bac04aef1032d4ea6dafe4667ef39eb41" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(doc-view-ghostscript-options
   (quote
    ("-dNOSAFER" "-dNOPAUSE" "-sDEVICE=png16m" "-dTextAlphaBits=4" "-dBATCH" "-dGraphicsAlphaBits=4" "-dQUIET")))
 '(doc-view-ghostscript-program "/usr/local/bin/gs")
 '(package-selected-packages
   (quote
    (erc-hl-nicks helm org-attach-screenshot org-alert org-plus-contrib zenburn-theme yasnippet undo-tree smex rainbow-delimiters projectile paredit multiple-cursors markdown-mode magit inf-clojure ido-vertical-mode ido-ubiquitous ido-hacks idle-highlight-mode htmlize flx-ido find-file-in-project f exec-path-from-shell ess es-mode deft dash-at-point company-quickhelp color-theme-solarized color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized cider ace-jump-mode))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(default ((t (:height 140 :width normal :family "PragmataPro")))))

(when (eq system-type 'darwin)
  (set-default-font "-*-Source Code Pro-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1")
  ;;(set-default-font "-*-Inconsolata-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1")
  ;;(set-default-font "-*-Consolas-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1")
  )


(load-theme 'zenburn t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
