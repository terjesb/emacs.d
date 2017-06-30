(when (locate-library "clojure-mode")
  (setq initial-major-mode 'clojure-mode))

(setq-default tab-width 2
              indent-tabs-mode nil)

(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 80)

(blink-cursor-mode 0)

;; http://blog.gleitzman.com/post/35416335505/hunting-for-unicode-in-emacs
;; C-q C-j
;; C-s C-q 1 a
;; C-u C-x =
;; (replace-string "\u2122" "TM")
(setq read-quoted-char-radix 16)

;; "always 2 spaces" option
;;(setq clojure-defun-style-default-indent t)
;;(global-linum-mode t)

(projectile-global-mode)

;;(require 'ess-site)

(require 'cider)
;;(require 'nrepl-inspect)
(require 'paredit)

(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.dtm\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.es$" . es-mode))

;;;(require 'auto-complete-config)
;;;(ac-config-default)
;;;(require 'ac-nrepl)

(require 'company)
(require 'yasnippet)
(yas/global-mode 1)
(global-company-mode)
(company-quickhelp-mode 1)

(require 'dash-at-point)
(global-set-key "\C-cd" 'dash-at-point)


;;(global-rainbow-delimiters-mode)

(setq hs-show-all-p t)
(defun hs-mode-toggle-show-all ()
  (interactive)
  (if hs-show-all-p
      (hs-hide-all)
    (hs-show-all))
  (setq hs-show-all-p (not hs-show-all-p)))
(global-set-key (kbd "C-.") 'hs-toggle-hiding)
(global-set-key (kbd "C-C C-.") 'hs-mode-toggle-show-all)



(add-hook 'clojure-mode-hook (lambda () (whitespace-mode 1)))
(add-hook 'clojure-mode-hook (lambda () (add-to-list 'write-file-functions
                                                     'delete-trailing-whitespace)))
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'cider-mode)
(add-hook 'clojure-mode-hook 'hs-minor-mode)

(add-hook 'cider-mode-hook #'eldoc-mode)

(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

;;; company-cider deprecated
;;;(eval-after-load 'company '(add-to-list 'company-backends 'company-cider))

;;(setq nrepl-log-events t)
(setq nrepl-hide-special-buffers t)
(setq nrepl-buffer-name-show-port t)
(setq cider-prefer-local-resources t)
(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-popup-stacktraces t)
(setq cider-repl-popup-stacktraces t)
(setq cider-stacktrace-default-filters '(tooling dup))
(setq cider-repl-print-length 1000)
(setq cider-repl-history-size 5000)
(setq cider-repl-history-file (concat user-emacs-directory ".cider-repl-hist"))

(setq ac-auto-show-menu 0.5)
;;(setq ac-show-menu-immediately-on-auto-complete t)

;; make C-c C-z switch to the *cider* buffer in the current window
(add-to-list 'same-window-buffer-names "*cider*")


(require 'multiple-cursors)

;; http://blog.bookworm.at/2007/03/pretty-print-xml-with-emacs.html
(setq rng-nxml-auto-validate-flag nil)

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


;; http://inclojurewetrust.blogspot.de/2013/01/duplicating-s-expressions-on-line.html
;; https://github.com/kototama/.emacs.d/blob/master/elisp/setup-lisp.el#L51
(defun paredit-duplicate-after-point
  ()
  "Duplicates the content of the line that is after the point."
  (interactive)
  ;; skips to the next sexp
  (while (looking-at " ")
    (forward-char))
  (set-mark-command nil)
  ;; while we find sexps we move forward on the line
  (while (and (<= (point) (car (bounds-of-thing-at-point 'sexp)))
              (not (= (point) (line-end-position))))
    (forward-sexp)
    (while (looking-at " ")
      (forward-char)))
  (kill-ring-save (mark) (point))
  ;; go to the next line and copy the sexprs we encountered
  (paredit-newline)
  (set-mark-command nil)
  (yank)
  (exchange-point-and-mark))

(defun write-fn-into-buffer (m)
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (cider-repl--replace-input (format "(%s)" m))))

(defun cider-ido-fns-form (ns)
  "Construct a Clojure form for reading fns using supplied NS."
  (format "(let [fn-pred (fn [[k v]] (and (fn? (.get v)) (not (re-find #\"clojure.\" (str v)))))]
              (sort
                (map (comp name key)
                     (filter fn-pred
                         (concat
                           (ns-interns '%s)
                           (ns-refers '%s))))))" ns ns))

(defun cider-ido-read-fns (ns ido-callback)
  "Perform ido read fns in NS using supplied IDO-CALLBACK."
  ;; Have to be stateful =(
  (setq cider-ido-ns ns)
  (interactive)
  (cider-tooling-eval (cider-ido-fns-form cider-ido-ns)
                      (cider-ido-read-var-handler ido-callback (current-buffer))
                      nrepl-buffer-ns))

(defun cider-load-fn-into-repl-buffer ()
  "Browse functions available in current repl buffer using ido.
Once selected, the name of the fn will appear in the repl buffer in parens
ready to call."
  (interactive)
  (cider-ido-read-fns (cider-current-ns) 'write-fn-into-buffer))

(global-set-key (kbd "C-c n f") 'cider-load-fn-into-repl-buffer)


(require 'cider)
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")
