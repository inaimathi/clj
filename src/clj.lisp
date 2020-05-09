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

(defmacro -> (exp &rest ops)
  (reduce
   (lambda (memo op)
     (if (atom op)
	 `(,op ,memo)
	 `(,(first op) ,memo ,@(rest op))))
   ops :initial-value exp))

(defmacro ->> (exp &rest ops)
  (reduce
   (lambda (memo op)
     (if (atom op)
	 `(,op ,memo)
	 `(,@op ,memo)))
   ops :initial-value exp))

(named-readtables:in-readtable syntax)
