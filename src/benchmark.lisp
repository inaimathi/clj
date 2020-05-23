(in-package :clj)

(ql:quickload :static-dispatch)
(ql:quickload :test-utils)

(static-dispatch:defmethod static-dispatch-== (a b) (equalp a b))
(static-dispatch:defmethod static-dispatch-== ((a number) (b number)) (= a b))
(static-dispatch:defmethod static-dispatch-== ((a string) (b string)) (string= a b))
(static-dispatch:defmethod static-dispatch-== ((a character) (b character)) (char= a b))
(static-dispatch:defmethod static-dispatch-== ((a symbol) (b symbol)) (eq a b))
(static-dispatch:defmethod static-dispatch-== ((a list) (b list)) (equal a b))
(static-dispatch:defmethod static-dispatch-== ((a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-eq a b :value-test #'==))
(static-dispatch:defmethod static-dispatch-== ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))

(static-dispatch:defmethod static-dispatch-lookup ((container list) key)
  (nth key container))
(static-dispatch:defmethod static-dispatch-lookup ((container hash-table) key)
  (gethash key container))
(static-dispatch:defmethod static-dispatch-lookup ((container cl-hamt:hash-set) key)
  (cl-hamt:set-lookup container key))
(static-dispatch:defmethod static-dispatch-lookup ((container cl-hamt:hash-dict) key)
  (cl-hamt:dict-lookup container key))

(static-dispatch:defmethod static-dispatch-insert ((container list) elem) (cons elem container))
(static-dispatch:defmethod static-dispatch-insert ((container hash-table) k/v)
  ;; NOTE - strictly, this should copy the hash-table in order to be functional
  ;;        Not right now.
  (setf (gethash (car k/v) container) (cdr k/v)))
(static-dispatch:defmethod static-dispatch-insert ((container cl-hamt:hash-dict) k/v)
  (cl-hamt:dict-insert container (car k/v) (cdr k/v)))
(static-dispatch:defmethod static-dispatch-insert ((container cl-hamt:hash-set) elem)
  (cl-hamt:set-insert container elem))

(static-dispatch:defmethod static-dispatch-len ((container list)) (length container))
(static-dispatch:defmethod static-dispatch-len ((container hash-table)) (hash-table-count container))
(static-dispatch:defmethod static-dispatch-len ((container cl-hamt:hash-set)) (cl-hamt:set-size container))
(static-dispatch:defmethod static-dispatch-len ((container cl-hamt:hash-dict)) (cl-hamt:dict-size container))

(defun seal-all-domains (generic-function)
  (loop for m in (closer-mop:generic-function-methods generic-function)
     do (format t "SEALING ~s~%" (mapcar #'class-name (closer-mop:method-specializers m)))
     do (ignore-errors
	  (progn (fast-generic-functions:seal-domain
		  generic-function
		  (mapcar #'class-name (closer-mop:method-specializers m)))
		 (format t "  Sealed...~%"))) ))

(defmacro -definlineable (name (&rest args) &body body)
  `(defmethod ,name ,args
       (declare (fast-generic-functions:method-properties fast-generic-functions:inlineable))
       ,@body))

(defgeneric fgf-== (a b)
  (:generic-function-class fast-generic-functions:fast-generic-function))
(defgeneric fgf-lookup (container key)
  (:generic-function-class fast-generic-functions:fast-generic-function))
(defgeneric fgf-insert (container elem)
  (:generic-function-class fast-generic-functions:fast-generic-function))
(defgeneric fgf-len (container)
  (:generic-function-class fast-generic-functions:fast-generic-function))

;; (-definlineable fgf-== (a b) (equalp a b))
(-definlineable fgf-== ((a number) (b number)) (= a b))
(-definlineable fgf-== ((a string) (b string)) (string= a b))
(-definlineable fgf-== ((a character) (b character)) (char= a b))
(-definlineable fgf-== ((a symbol) (b symbol)) (eq a b))
(-definlineable fgf-== ((a list) (b list)) (equal a b))
(-definlineable fgf-== ((a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-eq a b :value-test #'==))
(-definlineable fgf-== ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))
(seal-all-domains #'fgf-==)

(-definlineable fgf-lookup ((container list) key)
  (nth key container))
(-definlineable fgf-lookup ((container hash-table) key)
  (gethash key container))
(-definlineable fgf-lookup ((container cl-hamt:hash-set) key)
  (cl-hamt:set-lookup container key))
(-definlineable fgf-lookup ((container cl-hamt:hash-dict) key)
  (cl-hamt:dict-lookup container key))
(seal-all-domains #'fgf-lookup)

(-definlineable fgf-insert ((container list) elem) (cons elem container))
(-definlineable fgf-insert ((container hash-table) k/v)
  ;; NOTE - strictly, this should copy the hash-table in order to be functional
  ;;        Not right now.
  (setf (gethash (car k/v) container) (cdr k/v)))
(-definlineable fgf-insert ((container cl-hamt:hash-dict) k/v)
  (cl-hamt:dict-insert container (car k/v) (cdr k/v)))
(-definlineable fgf-insert ((container cl-hamt:hash-set) elem)
  (cl-hamt:set-insert container elem))
(seal-all-domains #'fgf-insert)

(-definlineable fgf-len ((container list)) (length container))
(-definlineable fgf-len ((container hash-table)) (hash-table-count container))
(-definlineable fgf-len ((container cl-hamt:hash-set)) (cl-hamt:set-size container))
(-definlineable fgf-len ((container cl-hamt:hash-dict)) (cl-hamt:dict-size container))
(seal-all-domains #'fgf-insert)

(defun fgn-fn (a b)
  (declare (inline fgf-==))
  (fgf-== a b))
(defun static-fn (a b)
  (declare (inline static-dispatch-==))
  (static-dispatch-== a b))
(defun naive-fn (a b)
  (declare (inline ==))
  (== a b))
(defun built-in-fn (a b)
  (declare (inline =))
  (= a b))

(defun equality-benchmark ()
  (loop for f in (list #'naive-fn #'built-in-fn #'fgn-fn #'static-fn)
     do (loop repeat 1000000
	   do (funcall f (random 256) (random 256)))))

(defun lookup/insert/len-benchmark (equality insert lookup len &key (times 10000))
  (let* ((elem-gen (test-utils:a-member (test-utils:a-member
					 test-utils:a-keyword
					 test-utils:a-number
					 test-utils:a-string)))
	 (pair-gen (test-utils:a-pair elem-gen elem-gen)))
    (loop repeat times
       do (let* ((map (alist->map
		       (test-utils:generate (test-utils:a-list pair-gen))
		       :equality equality))
		 (inserted (funcall insert map (cons :test-key :test-value))))
	    (list (funcall len map)
		  (funcall lookup inserted :test-key)
		  (funcall len inserted))))))

(defun typed/untyped-benchmark (&key (times 10000))
  (loop repeat times
     do (let* ((map (alist->map
		     (test-utils:generate (test-utils:a-list pair-gen))
		     :equality equality))
	       (inserted (funcall insert map (cons :test-key :test-value))))
	  (list (funcall len map)
		(funcall lookup inserted :test-key)
		(funcall len inserted)))))
