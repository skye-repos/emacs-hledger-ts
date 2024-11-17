;;; hledger-ts-mode.el --- Hledger Mode using treesitter -*- lexical-binding: t -*-

;; Author: Skye
;; Version: 0.0.0alpha
;; Package-Requires: ((hledger-mode) (emacs 30) (treesit))
;; Homepage: https://github.com/skye-repos
;; Keywords: Ledger, Major Mode, Tree Sitter

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A quick draft of a hledger mode built with tree-sitter

;;; Code:
(require 'treesit)
(require 'hledger-mode)

(defvar hledger-ts-font-lock-rules
  '( :language hledger
	 :override t
	 :feature comment
	 ((comment) @font-lock-comment-face)

	 :language hledger
	 :override t
	 :feature date
	 ((date) @font-lock-builtin-face)

	 :language hledger
	 :override t
	 :feature description
	 ((description) @font-lock-string-face)

	 :language hledger
	 :override t
	 :feature account
	 ((account) @font-lock-type-face)

	 :language hledger
	 :override t
	 :feature currency
	 ((currency) @font-lock-keyword-face)

	 :language hledger
	 :override t
	 :feature value
	 ((value) @font-lock-escape-face)))

(defun hledger-ts-setup ()
  "Setup treesit for hledger-ts-mode."
  (interactive)
  (setq-local font-lock-defaults nil)
  (setq-local treesit-font-lock-level 5)
  (setq-local treesit-font-lock-settings
			  (apply #'treesit-font-lock-rules
					 hledger-ts-font-lock-rules))
  (setq-local treesit-font-lock-feature-list
			'((comment)
			  (date)
			  (description)
			  (account)
			  (currency)
			  (value)))
  
  (setq-local treesit-simple-indent-rules
			  `((hledger
				 ((parent-is "document") column-0 0)
				 ((node-is "journal_entry") column-0 0)
				 ((node-is "value") column-0 16)
				 ((node-is "account") column-0 4)
				 ((node-is "comment") column-0 4)
				 (no-node parent 0))))
  
  (treesit-major-mode-setup))

;;;###autoload
(define-derived-mode hledger-ts-mode hledger-mode "Hledger[ts]"
  "Major mode for editing Hledger files."
  :syntax-table hledger-mode-syntax-table
  (when (treesit-ready-p 'hledger)
	(treesit-parser-create 'hledger)
	(hledger-ts-setup)))

(provide 'hledger-ts-mode)
;;; hledger-ts-mode.el ends here
