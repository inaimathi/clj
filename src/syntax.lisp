(in-package :clj)

;;;;;;;;;; Maps
(defun alist->map (alist)
  (loop with dict = (cl-hamt:empty-dict :test #'==)
     for (k . v) in alist do (setf dict (cl-hamt:dict-insert dict k v))
     finally (return dict)))

(defun map-literal-reader (stream char)
  (declare (ignore char))
  (let ((parsed (read-delimited-list #\} stream t)))
    (assert (evenp (length parsed)) nil "Map literal must have an even number of elements")
    (loop with dict = (cl-hamt:empty-dict :test #'==)
       for (k v) on parsed by #'cddr
       do (setf dict (cl-hamt:dict-insert dict k v))
       finally (return dict))))

;;;;;;;;;; Sets
(defun list->set (lst)
  (reduce
   (lambda (set elem)
     (cl-hamt:set-insert set elem))
   lst :initial-value (cl-hamt:empty-set :test #'==)))

(defun set-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (list->set (read-delimited-list #\} stream t)))

;;;;;;;;;; Readtable definition
(named-readtables:defreadtable syntax
  (:merge :standard)
  (:macro-char #\{ #'map-literal-reader nil)
  (:macro-char #\} (get-macro-character #\)) nil)
  (:dispatch-macro-char #\# #\{ #'set-literal-reader))
