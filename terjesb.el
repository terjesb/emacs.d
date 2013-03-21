(setq elnode-do-init nil)
(setq tramp-default-method "scp")

(setq backup-directory-alist
      `(("." . ,(expand-file-name (concat user-emacs-directory "backups")))))
(setq vc-make-backup-files t)

(require 'undo-tree)
(global-undo-tree-mode)

(add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))

(custom-set-faces
  '(default ((t (:height 140 :width normal :family "Consolas")))))

;(setq org-mobile-directory "~/Dropbox/MobileOrg")
;(setq org-mobile-use-encryption f)
;(setq org-mobile-encryption-password "")
;org-mobile-files org-mobile-directory org-agenda-files org-directory
;org-mobile-inbox-for-pull

;; ==== erc

;; (define-key shell-mode-map (kbd "C-l") (lambda (seq) (interactive "k") (process-send-string nil seq)))
(setq erc-prompt ">"
      erc-fill-column 75
      erc-header-line-format nil
      erc-hide-list '("JOIN" "PART" "QUIT")
      erc-track-exclude-types '("MODE" "JOIN" "PART" "QUIT" "NICK")
      erc-track-priority-faces-only t)
;;      erc-autojoin-timing :ident
;;      erc-flood-protect nil
;;      erc-autojoin-channels-alist
;;      '(("freenode.net" "#emacs" "#clojure" "#leiningen" "#datomic"))
;;      erc-prompt-for-nickserv-password nil
;;(setq-default erc-ignore-list '("Lajla" "pjb" "e1f"))

(eval-after-load 'erc
  '(progn
     ;
     (when (not (package-installed-p 'erc-hl-nicks))
       (package-install 'erc-hl-nicks)
       )
     (require 'erc-spelling)
     ;(require 'erc-services)
     (require 'erc-truncate)
     (require 'erc-hl-nicks)
     ;(erc-services-mode 1)
     (erc-truncate-mode 1)
     ;(setq-default erc-ignore-list '("xxxxxxxx" "yyyyyyyy")))
     (add-to-list 'erc-modules 'hl-nicks)
     (add-to-list 'erc-modules 'spelling)
     ;(set-face-foreground 'erc-input-face "dim gray")
     ;(set-face-foreground 'erc-my-nick-face "blue")
     ))
;;(remove-hook 'prog-mode-hook 'esk-pretty-lambdas)

;; ==== programming

(setq-default tab-width 2
              indent-tabs-mode nil)

(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 80)

(add-hook 'clojure-mode-hook (lambda () (whitespace-mode 1)))
(add-hook 'clojure-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(require 'paredit)
(add-hook 'clojure-mode-hook 'paredit-mode)

(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.dtm\\'" . clojure-mode))

(require 'auto-complete-config)
(ac-config-default)

(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))

(global-rainbow-delimiters-mode)

(add-hook 'nrepl-connected-hook
          (defun add-clojure-mode-eldoc-hook ()
            (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)))

(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)

(add-hook 'nrepl-interaction-mode-hook
          'my-nrepl-mode-setup)

(defun my-nrepl-mode-setup ()
  (require 'nrepl-ritz))


(setq nrepl-popup-stacktraces nil)
(setq ac-auto-show-menu 0.5)
;;(setq ac-show-menu-immediately-on-auto-complete t)

;; make C-c C-z switch to the *nrepl* buffer in the current window
;;(add-to-list 'same-window-buffer-names "*nrepl*")
;;(add-hook 'nrepl-mode-hook 'subword-mode)
;;(add-hook 'nrepl-mode-hook 'paredit-mode)
;;(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)

;; ==== org-babel

(when (locate-file "ob" load-path load-suffixes)
  (require 'ob)
  (require 'ob-tangle)
  (require 'ob-clojure)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (clojure    . t)
     (ruby       . t)
     (python     . t)
     (sh         . t)
     (R          . t))))

(require 'htmlize)

(declare-function nrepl-send-string-sync "ext:nrepl" (code &optional ns))
(defun org-babel-execute:clojure (body params)
  "Execute a block of Clojure code with Babel."
  (require 'nrepl)
  (with-temp-buffer
    (insert (org-babel-expand-body:clojure body params))
    ((lambda (result)
       (let ((result-params (cdr (assoc :result-params params))))
         (if (or (member "scalar" result-params)
                 (member "verbatim" result-params))
             result
           (condition-case nil (org-babel-script-escape result)
             (error result)))))
     (plist-get (nrepl-send-string-sync
                 (buffer-substring-no-properties (point-min) (point-max))
                 (cdr (assoc :package params)))
                :value))))

(defun org-babel-execute:clojure-3 (body params)
  "Execute a block of Clojure code with Babel."
  (let* ((selected-nrepl-ns (read-string "Namespace: " nil nil nrepl-buffer-ns))
         (result-plist (nrepl-send-string-sync (org-babel-expand-body:clojure body params) selected-nrepl-ns))
         (result-type  (cdr (assoc :result-type params))))
    (org-babel-script-escape
     (cond ((eq result-type 'value)  (plist-get result-plist :value))
           ((eq result-type 'output) (plist-get result-plist :value))
           (t                        (message "Unknown :results type!"))))))

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))
;;; ob-clojure.el --- org-babel functions for clojure evaluation

;; Copyright (C) 2009-2012  Free Software Foundation, Inc.

;; Author: Joel Boehland
;;Eric Schulte
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; support for evaluating clojure code, relies on slime for all eval

;;; Requirements:

;;; - clojure (at least 1.2.0)
;;; - clojure-mode
;;; - slime

;;; By far, the best way to install these components is by following
;;; the directions as set out by Phil Hagelberg (Technomancy) on the
;;; web page: http://technomancy.us/126

;;; Code:
(require 'ob)
(require 'ob-eval)

(declare-function slime-eval "ext:slime" (sexp &optional package))

;;(defvar org-babel-tangle-lang-exts)
;;(add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

(defvar org-babel-default-header-args:clojure '())
(defvar org-babel-header-args:clojure '((package . :any)))

(defun org-babel-expand-body:clojure (body params)
  "Expand BODY according to PARAMS, return the expanded body."
  (let* ((vars (mapcar #'cdr (org-babel-get-header params :var)))
         (result-params (cdr (assoc :result-params params)))
         (print-level nil) (print-length nil)
         (body (org-babel-trim
                (if (> (length vars) 0)
                    (concat "(let ["
                            (mapconcat
                             (lambda (var)
                               (format "%S (quote %S)" (car var) (cdr var)))
                             vars "\n      ")
                            "]\n" body ")")
                  body))))
    (cond ((or (member "code" result-params) (member "pp" result-params))
           (format (concat "(let [org-mode-print-catcher (java.io.StringWriter.)] "
                           "(clojure.pprint/with-pprint-dispatch clojure.pprint/%s-dispatch "
                           "(clojure.pprint/pprint (do %s) org-mode-print-catcher) "
                           "(str org-mode-print-catcher)))")
                   (if (member "code" result-params) "code" "simple") body))
          ;; if (:results output), collect printed output
          ((member "output" result-params)
           (format "(clojure.core/with-out-str %s)" body))
          (t body))))

(defun org-babel-execute:clojure (body params)
  "Execute a block of Clojure code with Babel."
  (require 'slime)
  (with-temp-buffer
    (insert (org-babel-expand-body:clojure body params))
    ((lambda (result)
       (let ((result-params (cdr (assoc :result-params params))))
         (if (or (member "scalar" result-params)
                 (member "verbatim" result-params))
             result
           (condition-case nil (org-babel-script-escape result)
             (error result)))))
     (slime-eval
      `(swank:eval-and-grab-output
        ,(buffer-substring-no-properties (point-min) (point-max)))
      (cdr (assoc :package params))))))

(provide 'ob-clojure)

;;; ob-clojure.el ends here

;; ==== bindings

(setq mac-function-modifier 'super)
(setq mac-command-modifier 'meta)
(setq mac-command-key-is-meta t)
(setq mac-option-modifier 'none)
(setq mac-option-key-is-meta nil)

(global-set-key (kbd "C-c C-j") 'nrepl-jack-in)
;(global-set-key "\C-x\C-m" 'execute-extended-command)
;(global-set-key "\C-c\C-m" 'execute-extended-command)

;(global-set-key "\C-w" 'backward-kill-word)
;(global-set-key "\C-x\C-k" 'kill-region)
;(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "C-\\") 'delete-indentation)
(global-set-key (kbd "C-ø") 'delete-indentation)
(global-set-key (kbd "M-ø") 'delete-indentation)
(global-set-key (kbd "M-æ") 'delete-horizontal-space)

(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-v") 'clipboard-yank)
(global-set-key (kbd "s-<") 'previous-buffer)
(global-set-key (kbd "s->") 'next-buffer)

(define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)
(eval-after-load 'paredit
  '(ignore-errors
     (define-key paredit-mode-map (kbd "M-(") 'paredit-wrap-round)
     (define-key paredit-mode-map (kbd "C-S-<left>") 'paredit-backward-slurp-sexp)
     (define-key paredit-mode-map (kbd "C-S-<right>") 'paredit-backward-barf-sexp)))

;; Norwegian keyboard
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])
(define-key input-decode-map "\e[1;6A" [C-S-up])
(define-key input-decode-map "\e[1;6B" [C-S-down])
(define-key input-decode-map "\e[1;6C" [C-S-right])
(define-key input-decode-map "\e[1;6D" [C-S-left])
(define-key input-decode-map "\e[1;8A" [C-M-up])
(define-key input-decode-map "\e[1;8B" [C-M-down])
(define-key input-decode-map "\e[1;8C" [C-M-right])
(define-key input-decode-map "\e[1;8D" [C-M-left])
(define-key input-decode-map "\e[1;9A" [M-up])
(define-key input-decode-map "\e[1;9B" [M-down])
(define-key input-decode-map "\e[1;9C" [M-right])
(define-key input-decode-map "\e[1;9D" [M-left])
(define-key input-decode-map "\e[1;10A" [S-M-up])
(define-key input-decode-map "\e[1;10B" [S-M-down])
(define-key input-decode-map "\e[1;10C" [S-M-right])
(define-key input-decode-map "\e[1;10D" [S-M-left])

;;(setq org-replace-disputed-keys t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
