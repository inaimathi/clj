(in-package #:clj)

(defmacro if-let ((name test) then &optional else)
  (let ((tmp (gensym "TMP")))
    `(let ((,tmp ,test))
       (if ,tmp
	   (let ((,name ,tmp)) ,then)
	   ,else))))

(defmacro when-let ((name test) &body then)
  `(if-let (,name ,test)
     (progn ,@then)
     nil))

(defmacro fn (&rest args)
  (optima:match args
    ((optima:guard
      (cons name (cons params body))
      (and (symbolp name) (listp params)))
     `(labels ((,name ,params ,@body))
	#',name))
    ((optima:guard
      (cons params body)
      (and (listp params)))
     `(lambda ,params ,@body))))

(defmacro as (&rest package/alias-pairs)
  "as duplicates local-package-aliases:set, but checks that the aliased packages exist before establishing them."
  `(progn
     (loop for (k v) on (list ,@package/alias-pairs) by #'cddr
	do (assert (find-package k) nil "No such package: ~s" k)
	do (assert (symbolp v) nil "Package alias must be a symbol: ~s" v))
     (local-package-aliases:set ,@package/alias-pairs)))

(named-readtables:in-readtable syntax)
