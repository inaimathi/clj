(in-package :clj)

(defun hash-literal-reader (stream char)
  (declare (ignore char))
  (reduce
   (lambda (dict elem)
     (cl-hamt:dict-insert dict (car elem) (cdr elem)))
   (loop for (k v) on (read-delimited-list #\} stream t) by #'cddr
      collect (cons k v))
   :initial-value (cl-hamt:empty-dict)))

(defun set-literal-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (reduce
   (lambda (set elem)
     (cl-hamt:set-insert set elem))
   (read-delimited-list #\} stream t)
   :initial-value (cl-hamt:empty-set)))

(named-readtables:defreadtable syntax
  (:merge :standard)
  (:macro-char #\{ #'hash-literal-reader nil)
  (:macro-char #\} (get-macro-character #\)) nil)
  (:dispatch-macro-char #\# #\{ #'set-literal-reader))
