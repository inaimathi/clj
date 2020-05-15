(in-package :clj)

;;;;;;;;;; Maps
(defun alist->map (alist)
  (let ((equality (if (map-type? *type*)
		      (equality-function (equality-of (second *type*)))
		      #'==)))
    (loop with dict = (cl-hamt:empty-dict :test equality)
       for (k . v) in alist do (setf dict (cl-hamt:dict-insert dict k v))
       finally (return dict))))

(defun list->map (lst)
  (assert (evenp (length lst)) nil "Map literal must have an even number of elements")
  (format t "TYPE: ~s" *type*)
  (let ((equality (if (map-type? *type*)
		      (equality-function (equality-of (second *type*)))
		      #'==)))
    (loop with dict = (cl-hamt:empty-dict :test equality)
       for (k v) on lst by #'cddr
       do (setf dict (cl-hamt:dict-insert dict k v))
       finally (return dict))))

(defun map-literal-reader (stream char)
  (declare (ignore char))
  (list->map (read-delimited-list #\} stream t)))

;;;;;;;;;; Sets
(defun list->set (lst)
  (reduce
   (lambda (set elem)
     (cl-hamt:set-insert set elem))
   lst :initial-value (cl-hamt:empty-set :test #'==)))

(defun set-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (list->set (read-delimited-list #\} stream t)))

;;;;;;;;;; Types
(defun type-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (read-char stream)
  (let ((*type* (read stream)))
    (eval (read stream))))

;;;;;;;;;; Readtable definition
(named-readtables:defreadtable syntax
  (:merge :standard)
  (:macro-char #\{ #'map-literal-reader nil)
  (:macro-char #\} (get-macro-character #\)) nil)
  (:dispatch-macro-char #\# #\{ #'set-literal-reader)
  (:dispatch-macro-char #\# #\: #'type-literal-reader))
