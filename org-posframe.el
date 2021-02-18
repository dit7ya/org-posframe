;;; org-posframe.el --- Show a quick preview of linked files in org-mode.
;;; *- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 dit7ya
;;
;; Author: dit7ya <https://github.com/dit7ya>
;; Maintainer: dit7ya <7rat13@gmail.com>
;; Created: February 18, 2021
;; Modified: February 18, 2021
;; Version: 0.0.1
;; Keywords: "org-mode"
;; Homepage: https://github.com/dit7ya/org-posframe
;; Package-Requires: ((emacs "24.3") (org "9.4") (posframe "0.8.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(require 'posframe)

(defun org-posframe-show()
  "Show a posframe with the contents of the file at point."

  (if (org-posframe--org-link-at-point-p)

      (let ((uri-string (plist-get (get-text-property (point) 'htmlize-link) :uri) )) ;; careful to not eval like (point) here, that gets the current point and not the supplied function arg

        ;; Check if uri-string begins with "file".
        (if (string= (substring uri-string 0 4) "file")

            ;; Get the actual file name.
            (let ((flname (substring uri-string 5)))

              (message (format "%s" flname))

              ;; Popup a posframe with the file conent.

              (when (posframe-workable-p)
                (posframe-show (find-file-noselect flname)
                               :position (point) ;; recheck this
                               :width 60
                               :height 20
                               :internal-border-width 2
                               :internal-border-color "#93937070DBDB"
                               :timeout 60
                               :hidehandler #'org-posframe--outside-org-link-p)))))))

(defun org-posframe--outside-org-link-p (info)
  "Return t if current point is not an org-link.
INFO is required for passing this function to posframe-show hidehandler."
  (not (org-posframe--org-link-at-point-p)))

(defun org-posframe--org-link-at-point-p ()
  "Return the org link at the point or nil."
  (plist-get (get-text-property (point) 'htmlize-link) :uri))

(define-minor-mode org-posframe-mode
  "Org-posframe mode provides wikipedia style quick preview of files in org-mode when the pointer is on top of a file link."

  :init-value nil
  :lighter "opm"
  (progn

    (setq posframe-mouse-banish nil)

    (if org-posframe-mode
        ;; add the hook
        (add-hook 'post-command-hook 'org-posframe-show)

      ;; remove the hook
      (remove-hook 'post-command-hook 'org-posframe-show))))


(provide 'org-posframe)
;;; org-posframe.el ends here
