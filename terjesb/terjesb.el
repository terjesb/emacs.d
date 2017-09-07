(setq tramp-default-method "scp")

(setq vc-make-backup-files t)

(require 'undo-tree)
(global-undo-tree-mode)

(add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md" . gfm-mode))

(setq deft-directory "/Users/terjesb/Dropbox/nvALT/")
(setq deft-use-filename-as-title t)
;;(setq deft-text-mode 'org-mode)

(setq cider-known-endpoints
      '(
        ("nap-saprfcgw" "127.0.0.1" "58081")
        ("nap-idocr" "127.0.0.1" "44243")
        ("nap-sapgw" "127.0.0.1" "44244")
        ("nap-magegw" "127.0.0.1" "44245")
        ("nap-smsgw" "127.0.0.1" "44246")
        ("nap-adminx" "127.0.0.1" "44247")
        ("nap-reviews" "127.0.0.1" "44248")
        ("nap-feeds" "127.0.0.1" "44249")
        ("nap-jobs" "127.0.0.1" "44250")
        ("nap-zzcont" "127.0.0.1" "44251")
        ("nap-wakeup" "127.0.0.1" "44252")
        ("nap-returlapp" "127.0.0.1" "44253")
        ("nap-orderstatus" "127.0.0.1" "44254")
        ("nap-qlik" "127.0.0.1" "44255")
        ("nap-wmx" "127.0.0.1" "44256")
        ("nap-txmailer" "127.0.0.1" "44257")
        ("nap-checkout" "127.0.0.1" "44258")
        ("nap-zzprice" "127.0.0.1" "44259")

        ;;("fs-p-reviews" "127.0.0.1" "34248")
        ;;("fs-p-feeds" "127.0.0.1" "34249")
        ;;("fs-p-zzcont" "127.0.0.1" "34251")
        ;;("fs-p-wakeup" "127.0.0.1" "34252")
        ;;("fs-p-returlapp" "127.0.0.1" "34253")

        ("naq-saprfcgw" "127.0.0.1" "58889")
        ("naq-idocr" "127.0.0.1" "54243")
        ("naq-sapgw" "127.0.0.1" "54244")
        ("naq-magegw" "127.0.0.1" "54245")
        ("naq-smsgw" "127.0.0.1" "54246")
        ("naq-adminx" "127.0.0.1" "54247")
        ("naq-reviews" "127.0.0.1" "54248")
        ("naq-feeds" "127.0.0.1" "54249")
        ("naq-jobs" "127.0.0.1" "54250")
        ("naq-returlapp" "127.0.0.1" "54253")
        ("naq-orderstatus" "127.0.0.1" "54254")
        ("naq-wmx" "127.0.0.1" "54256")
        ("naq-txmailer" "127.0.0.1" "54257")

        ("fs-t-reviews" "127.0.0.1" "24248")
        ("fs-t-zzcont" "127.0.0.1" "24251")
        ("fs-t-wakeup" "127.0.0.1" "24252")
))

;;(custom-set-faces
;;  '(default ((t (:height 140 :width normal :family "Consolas")))))

(setq org-log-done 'time)
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-mobile-inbox-for-pull "~/Documents/Org/from-mobile.org")
;(setq org-mobile-use-encryption f)
;(setq org-mobile-encryption-password "")
;org-mobile-files org-mobile-directory org-agenda-files org-directory
;org-mobile-inbox-for-pull

(defun terjesb-show-agenda ()
  (interactive)
  (delete-other-windows)
  (org-agenda-list)
  (calendar)
  (other-window 1)
  (split-window-vertically)
  (other-window 1)
  (todays-daypage))

;; ==== erc

;; (define-key shell-mode-map (kbd "C-l") (lambda (seq) (interactive "k") (process-send-string nil seq)))
(setq erc-prompt ">"
      erc-fill-column 75
      erc-header-line-format nil
      erc-hide-list '("JOIN" "PART" "QUIT")
      erc-track-exclude-types '("MODE" "JOIN" "PART" "QUIT" "NICK")
      erc-track-priority-faces-only t
;;      erc-autojoin-timing :ident
;;      erc-flood-protect nil
      erc-autojoin-channels-alist
      '(("freenode.net" "#emacs" "#clojure" "#leiningen" "#datomic" "#clojurewerkz" "#immutant"))
;;      erc-prompt-for-nickserv-password nil
;;(setq-default erc-ignore-list '("Lajla" "pjb" "e1f"))
)

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
