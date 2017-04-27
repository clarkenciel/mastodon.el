;;; mastodon-account.el --- Account fetching functions for mastodon.el

;; Copyright (C) 2017 Johnson Denen
;; Author: Johnson Denen <johnson.denen@gmail.com>
;; Version: 0.6.0
;; Homepage: https://github.com/jdenen/mastodon.el

;; This file is not part of GNU Emacs.

;; This file is part of mastodon.el.

;; mastodon.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; mastodon.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with mastodon.el.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; mastodon-account.el provides account functions.

;;; Code:
(require 'mastodon-http)

(defgroup mastodon-account nil
  "Accounts in Mastodon."
  :prefix "mastodon-account-"
  :group 'mastodon)

(defcustom mastodon-account-suggestion-limit 5
  "Limit number of accounts displayed by suggestion dialog."
  :group 'mastodon
  :type 'number)

(defun mastodon-account--suggest (token)
  "Search for mastodon accounts featuring TOKEN."
  (interactive)
  (mastodon-account--make-suggestions
   token
   mastodon-account-suggestion-limit))

(defun mastodon-account--api (endpoint)
  "Return the url for the accounts ENDPOINT."
  (mastodon-http--api (concat "accounts/" endpoint)))

(defun mastodon-account--account (acct)
  "Format ACCT data."
  ())

(defun mastodon-account--search (token limit)
  "Search mastodon accounts featuring TOKEN up to LIMIT."
  (let* ((query-string (format "q=%s" token))
	 (limit-string (format "limit=%s" limit))
	 (url (mastodon-account--api (concat "search?" query-string "&" limit-string))))
    (json (mastodon-http--get-json url))))

(defun mastodon-account--suggestion-start-pos ()
  "Get the starting position of a suggestible string."
  (let ((sap (symbol-at-point)))
    (when (and sap (not (nth 3 (syntax-ppss))))
      (car (bounds-of-thing-at-point 'symbol)))))

(defun mastodon-account--make-suggestions (token limit)
  "Display account suggestions matching TOKEN up to a LIMIT."
  (interactive)
  (let* ((results (mastodon-account--search token limit))
	 (accounts (mapcar mastodon-account-- )))
    (popup-tip accounts
	       :point (mastodon-account--suggestion-start-pos)
	       :around t
	       :scroll-bar t
	       :margin t)))

(provide 'mastodon-account)
;;; mastodon-account.el ends here
