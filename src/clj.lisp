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

(defmethod print-object ((object cl-hamt:hash-dict) stream)
  (format
   stream
   "{~{~s ~s~^ ~}}"
   (reverse (cl-hamt:dict-reduce (lambda (memo k v) (cons v (cons k memo))) object nil))))

(defmethod print-object ((object cl-hamt:hash-set) stream)
  (format stream "#{~{~s~^ ~}}" (cl-hamt:set->list object)))

(named-readtables:in-readtable syntax)

;; TEST CASES
;; {:a 1 :b 2} => cl-hamt:hash-dict
;; {:a {:b 2} :c 3 :d {:e 4}}
;; #{1 2 3 4}  => cl-hamt:hash-set

;; #{1 2 #{3 4}
;;   4 5 6
;;   7 8 9}

;; (defun |#(-reader| (stream sub-char numarg)
;;   (declare (ignore sub-char numarg))
;;   (let ((chars))
;;     (do ((prev (read-char stream) curr)
;;          (curr (read-char stream) (read-char stream)))
;;         ((char= ) (and (char= prev #\") (char= curr #\#)))
;;       (push prev chars))
;;     (coerce (nreverse chars) 'string)))

;; (set-dispatch-macro-character
;;   #\# #\" #'|#"-reader|)
