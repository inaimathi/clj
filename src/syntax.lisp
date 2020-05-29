(in-package :clj)

;;;;;;;;;; Maps
(defun alist->map (alist &key equality)
  (let ((equality (or equality
		      (if (map-type? *type*)
			  (equality-function (equality-of (second *type*)))
			  #'==))))
    (loop with dict = (cl-hamt:empty-dict :test equality)
       for (k . v) in alist do (setf dict (cl-hamt:dict-insert dict k v))
       finally (return dict))))

(defun list->map (lst &key equality)
  (assert (evenp (length lst)) nil "Map literal must have an even number of elements")
  (let ((equality (or equality
		      (if (map-type? *type*)
			  (equality-function (equality-of (second *type*)))
			  #'==))))
    (loop with dict = (cl-hamt:empty-dict :test equality)
       for (k v) on lst by #'cddr
       do (setf dict (cl-hamt:dict-insert dict k v))
       finally (return dict))))

(defun map-literal-reader (stream char)
  (declare (ignore char))
  (list->map (read-delimited-list #\} stream t)))

;;;;;;;;;; Sets
(defun list->set (lst)
  (let ((equality (if (set-type? *type*)
		      (equality-function (equality-of (second *type*)))
		      #'==)))
    (reduce
     (lambda (set elem)
       (cl-hamt:set-insert set elem))
     lst :initial-value (cl-hamt:empty-set :test equality))))

(defun set-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (list->set (read-delimited-list #\} stream t)))

;;;;;;;;;; Types
(defun type-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (let* ((*type* (read stream))
	 (form (read stream))
	 (res (gensym)))
    (if *type*
	`(let ((,res ,form))
	   (check-type ,res ,*type*)
	   ,res)
	res)))

;;;;;;;;;; Readtable definition
(named-readtables:defreadtable syntax
  (:merge :standard)
  (:macro-char #\{ #'map-literal-reader nil)
  (:macro-char #\} (get-macro-character #\)) nil)
  (:dispatch-macro-char #\# #\{ #'set-literal-reader)
  (:dispatch-macro-char #\# #\# #'type-literal-reader))

(local-package-aliases:set-aliasing-reader (named-readtables:find-readtable 'clj:syntax))
