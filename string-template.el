;;; string-template.el --- Support for $-substitution.

;; Copyright © 2010 Sebastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>

;; Author: Sebastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>
;; Keywords: emacs, string, functionality
;; Last changed: 2010-08-11 17:40:41

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;


;;; Code:

(eval-when-compile
  (require 'cl))

(defcustom string-template-start-delimiter "${"
  "Default value for placeholder start delimiter in `string-template'."
  :type 'string)

(defcustom string-template-end-delimiter "}"
  "Default value for placeholder end delimiter in `string-template'."
  :type 'string)

;;;###autoload
(defun string-template (string values &optional start-delimiter end-delimiter)
  "Return a copy of STRING with substituted placeholders from VALUES.

STRING is an input string with both START-DELIMITER and END-DELIMITER
surrounded placeholders.

VALUES is a PLIST from which each property is a placehoder definition and
each value is its substitute.

Optional values START-DELIMITER and END-DELIMITER would override their default
values which are `string-template-start-delimiter' and
`string-template-end-delimiter' respectively.

Example

  (string-template
    \"The value of foo is ${Foo}, and bar's ${bar}. ${Foobar} is unchanged but ${Foo}${bar} is.\"
    '(:Foo \"FOO\" :bar \"BAR\"))

Would return

  \"The value of foo is FOO, and bar's BAR. ${Foobar} is unchanged but FOOBAR is.\""
  (let (keys)
    (unless start-delimiter
      (setq start-delimiter string-template-start-delimiter))
    (unless end-delimiter
      (setq end-delimiter string-template-end-delimiter))
    (save-match-data
      (with-temp-buffer
	(insert string)
	(loop for (a b) on values by #'cddr
	      do (replace-string
		  (concat start-delimiter
			  (substring (symbol-name a) 1)
			  end-delimiter)
		  b
		  nil (point-min) (point-max)))
	(buffer-string)))))

(provide 'string-template)
