(in-package :clj)

(defmethod cl-murmurhash:murmurhash ((object function) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (format nil "~a" object) :seed seed :mix-only mix-only))

(defgeneric == (a b))
(defgeneric lookup (container key &key default))
(defgeneric insert (container &rest args))
(defgeneric dissoc (container &rest ks-or-elems))
(defgeneric invert (container))
(defgeneric len (container))
(defgeneric contains? (container elem))
(defgeneric empty? (container))
(defgeneric as-list (container))
(defgeneric seq? (container))
(defgeneric fmap (f container))
(defgeneric union (container &rest containers))

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

(defmethod insert ((container list) &rest args)
  (let ((res container))
    (loop for el in args
       do (setf res (cons el res)))
    res))
(defmethod insert ((container hash-table) &rest args)
  ;; NOTE - strictly, this should copy the hash-table in order to be functional
  ;;        Not right now.
  (loop for (k v) on args by #'cddr
     do (setf (gethash k container) v))
  container)

(defmethod dissoc ((container list) &rest ks-or-elems)
  (let ((s (list->set ks-or-elems)))
    (loop for elem in container
       if (not (contains? s elem)) collect elem)))
(defmethod dissoc ((container hash-table) &rest ks-or-elems)
  (reduce (lambda (memo el) (remhash el memo) memo) ks-or-elems))

(defmethod invert ((container list))
  (let ((ct -1))
    (reduce
     (lambda (memo elem) (insert memo elem (incf ct)))
     container :initial-value {})))
(let ((ops (list->set '(cl:eq cl:eql cl:equal cl:equalp))))
  (defmethod invert ((container hash-table))
    (let* ((test (equality-of (loop for v being the hash-values of container)))
	   (test (if (contains? ops test) test 'cl:equalp))
	   (dest (make-hash-table :test test)))
      (loop for k being the hash-keys of container
	 for v being the hash-values of container
	 do (setf (gethash v dest) k))
      dest)))

(defmethod len ((container list)) (length container))
(defmethod len ((container hash-table)) (hash-table-count container))
(defmethod len ((container string)) (length container))

(defmethod contains? ((container list) elem) (not (not (member elem container :test #'==))))
(defmethod contains? ((container hash-table) elem) (nth-value 1 (gethash elem container)))
(defmethod contains? ((container string) (elem character)) (loop for c across container if (char= elem c) do (return t)))

(defmethod empty? ((container list)) (null container))
(defmethod empty? ((container hash-table)) (= 0 (hash-table-count container)))
(defmethod empty? ((container string)) (= 0 (length container)))

(defmethod as-list ((container list)) container)
(defmethod as-list ((container hash-table))
  (loop for k being the hash-keys of container
     for v being the hash-values of container
     collect (cons k v)))

(defmethod seq? (thing) nil)
(defmethod seq? ((container list)) t)
(defmethod seq? ((container hash-table)) t)

(defmethod fmap ((f function) (container list))
  (mapcar f container))
(defmethod fmap ((f function) (container hash-table))
  (let ((h (make-hash-table :test (hash-table-test container))))
    (loop for k being the hash-keys of container
       for v being the hash-values of container
       do (let ((res (funcall f k v)))
	    (setf (gethash (car res) h) (cdr res))))
    h))

(defun walk (f container)
  (if (not (seq? container))
      (funcall f container)
      (fmap f container)))

(defmethod union ((container list) &rest lists)
  (reduce
   (lambda (memo lst) (cl:union memo lst :test #'==))
   (cons container lists)))
