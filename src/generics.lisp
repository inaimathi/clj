(in-package :clj)

(defgeneric == (a b))
(defgeneric lookup (container key))
(defgeneric insert (container elem))
(defgeneric len (container))
(defgeneric contains? (container elem))

(defmethod == (a b) (equalp a b))
(defmethod == ((a number) (b number)) (= a b))
(defmethod == ((a string) (b string)) (string= a b))
(defmethod == ((a character) (b character)) (char= a b))
(defmethod == ((a symbol) (b symbol)) (eq a b))
(defmethod == ((a list) (b list)) (equal a b))

(defmethod lookup ((container list) key)
  (nth key container))
(defmethod lookup ((container hash-table) key)
  (gethash key container))

(defmethod insert ((container list) elem) (cons elem container))
(defmethod insert ((container hash-table) k/v)
  ;; NOTE - strictly, this should copy the hash-table in order to be functional
  ;;        Not right now.
  (setf (gethash (car k/v) container) (cdr k/v)))

(defmethod len ((container list)) (length container))
(defmethod len ((container hash-table)) (hash-table-count container))

(defmethod contains? ((container list) elem) (not (not (member elem container :test #'==))))
(defmethod contains? ((container hash-table) elem) (nth-value 1 (gethash elem container)))
