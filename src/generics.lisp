(in-package :clj)

(defmethod cl-murmurhash:murmurhash ((object function) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (format nil "~a" object) :seed seed :mix-only mix-only))

(defgeneric == (a b))
(defgeneric lookup (container key &key default))
(defgeneric insert (container elem))
(defgeneric len (container))
(defgeneric contains? (container elem))

(defmethod == (a b) (equalp a b))
(defmethod == ((a number) (b number)) (= a b))
(defmethod == ((a string) (b string)) (string= a b))
(defmethod == ((a character) (b character)) (char= a b))
(defmethod == ((a symbol) (b symbol)) (eq a b))
(defmethod == ((a list) (b list)) (equal a b))

(defmethod lookup ((container list) key &key default)
  (or (nth key container) default))
(defmethod lookup ((container hash-table) key &key default)
  (if (nth-value 1 (gethash elem container))
      (gethash key container)
      default))

(defmethod insert ((container list) elem) (cons elem container))
(defmethod insert ((container hash-table) k/v)
  ;; NOTE - strictly, this should copy the hash-table in order to be functional
  ;;        Not right now.
  (setf (gethash (car k/v) container) (cdr k/v)))

(defmethod len ((container list)) (length container))
(defmethod len ((container hash-table)) (hash-table-count container))

(defmethod contains? ((container list) elem) (not (not (member elem container :test #'==))))
(defmethod contains? ((container hash-table) elem) (nth-value 1 (gethash elem container)))
(defmethod contains? ((container string) (elem character)) (loop for c across container if (char= elem c) do (return t)))
