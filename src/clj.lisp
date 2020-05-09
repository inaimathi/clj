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
(defmethod == ((a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-eq a b :value-test #'==))
(defmethod == ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))

;; (defmethod get ((thing cl-hamt:hash-dict) key) (cl-hamt:dict-lookup thing key))

(named-readtables:in-readtable syntax)
