;;(add-to-list 'load-path "~/.emacs.d/non-elpa/org-mode/contrib/lisp" t)
(add-to-list 'load-path "/Applications/Emacs.app/Contents/Resources/lisp/org" t)

(require 'org)
(require 'ob-clojure)

(setq org-babel-clojure-backend 'cider)
(require 'cider)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (clojure . t)))

;;(org-babel-do-load-languages
;; 'org-babel-load-languages
;; '((R . t)
;;   (python . t)
;;   (ruby . t)
;;   (clojure . t)
;;   (gnuplot . t)
;;   ))

;;(require 'ox-koma-letter)

;;(add-to-list 'org-latex-classes
;;             '("my-letter"
;;               "\\documentclass\{scrlttr2\}
;;\\usepackage[english]{babel}
;;\[NO-DEFAULT-PACKAGES]
;;\[NO-PACKAGES]
;;\[EXTRA]"))

;; No folding of any entries
;;(setq org-startup-folded "showall")
;; Cleaner view
;;(setq org-startup-indented t)
