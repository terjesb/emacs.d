(when (eq system-type 'darwin)
  (setq mac-function-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)
  ;;(setq mac-command-key-is-meta t)
  ;;(setq mac-option-key-is-meta nil)
  )

(global-set-key (kbd "C-c C-j") 'cider-jack-in)
(global-set-key (kbd "C-c C-i") 'nrepl-inspect)

;(global-set-key "\C-x\C-m" 'execute-extended-command)
;(global-set-key "\C-c\C-m" 'execute-extended-command)

(global-set-key (kbd "C-c f") 'find-file-in-project)
(global-set-key (kbd "C-c g") 'magit-status)

;(global-set-key "\C-w" 'backward-kill-word)
;(global-set-key "\C-x\C-k" 'kill-region)
;(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "C-\\") 'delete-indentation)
(global-set-key (kbd "C-ø") 'delete-indentation)
(global-set-key (kbd "M-ø") 'delete-indentation)
(global-set-key (kbd "M-æ") 'delete-horizontal-space)
(global-set-key (kbd "M-7") 'shell-command-on-region)

(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-v") 'clipboard-yank)
(global-set-key (kbd "s-<") 'previous-buffer)
(global-set-key (kbd "s->") 'next-buffer)
(global-set-key (kbd "s-Z") 'undo-tree-redo)
(global-set-key (kbd "C-S-c C-S-C") 'mc/edit-lines)
(global-set-key (kbd "s-w") 'delete-window)

(global-set-key (kbd "C-<home>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<end>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<prior>") 'shrink-window)
(global-set-key (kbd "C-<next>") 'enlarge-window)

(define-key global-map (kbd "C-ø") 'ace-jump-mode)
(define-key global-map (kbd "C-Ø") 'ace-jump-mode-pop-mark)

(global-set-key (kbd "M-s e") 'sudo-edit)

;;(eval-after-load 'cider
;;  '(ignore-errors
;;     (define-key cider-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)))

;;(eval-after-load 'ac-nrepl
;;  '(ignore-errors
;;    (define-key popup-menu-keymap (kbd "<down>") 'popup-next)))

(eval-after-load 'paredit
  '(ignore-errors
     (define-key paredit-mode-map (kbd "C-S-d") 'paredit-duplicate-after-point)
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

(define-key key-translation-map (kbd "s-8") (kbd "["))
(define-key key-translation-map (kbd "s-(") (kbd "{"))
(define-key key-translation-map (kbd "s-9") (kbd "]"))
(define-key key-translation-map (kbd "s-)") (kbd "}"))
(define-key key-translation-map (kbd "s-7") (kbd "|"))
(define-key key-translation-map (kbd "s-/") (kbd "\\"))
(define-key key-translation-map (kbd "M-s-7") (kbd "M-|"))

;;(setq org-replace-disputed-keys t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
