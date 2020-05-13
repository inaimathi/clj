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
      (cons name (cons params (cons docstring body)))
      (and (symbolp name) (listp params) (stringp docstring)))
     `(labels ((,name ,params ,docstring ,@body))
	#',name))
    ((optima:guard
      (cons name (cons params body))
      (and (symbolp name) (listp params)))
     `(labels ((,name ,params ,@body))
	#',name))
    ((optima:guard
      (cons params (cons docstring body))
      (and (listp params) (stringp docstring)))
     `(lambda ,params ,docstring ,@body))
    ((optima:guard
      (cons params body)
      (and (listp params)))
     `(lambda ,params ,@body))))

(defmacro -> (exp &rest ops)
  (reduce
   (lambda (memo op)
     (cond ((atom op) `(,op ,memo))
	   ((and (consp op)
		 (or (eq 'cl:function (car op))
		     (eq 'cl:lambda (car op))))
	    `(funcall ,op ,memo))
	   (t `(,(first op) ,memo ,@(rest op)))))
   ops :initial-value exp))

(defmacro ->> (exp &rest ops)
  (reduce
   (lambda (memo op)
     (cond ((atom op) `(,op ,memo))
	   ((and (consp op)
		 (or (eq 'cl:function (car op))
		     (eq 'cl:lambda (car op))))
	    `(funcall ,op ,memo))
	   (t `(,@op ,memo))))
   ops :initial-value exp))

(defmethod == (a b) (equalp a b))

(named-readtables:in-readtable syntax)
