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

(named-readtables:in-readtable syntax)
