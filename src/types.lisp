(in-package :clj)

(defparameter *type* nil)

(defun tightest-equality (equalities)
  (find-if
   (lambda (e) (member e equalities :test #'eq))
   '(cl:= cl:string= cl:eq cl:eql cl:equal cl:equalp clj:==)))

(defun fullest-equality (equalities)
  (find-if
   (lambda (e) (member e equalities :test #'eq))
   '(clj:== cl:equalp cl:equal cl:eql cl:eq cl:string= cl:=)))

(defun equality-function (name) (fdefinition name))

(defun equality-of (type)
  (cond
    ((member type '(integer number float ratio rational bignum bit complex long-float short-float signed-byte unsigned-byte single-float double-float fixnum))
     'cl:=)
    ((member type '(string simple-string))
     'cl:string=)
    ((member type '(atom symbol keyword package readtable null stream random-state))
     'cl:eq)
    ((member type '(standard-char character pathname))
     'cl:eql)
    ((member type '(cons list))
     'cl:equal)
    ((and (listp type) (eq 'or (first type)))
     (fullest-equality (mapcar #'equality-of (rest type))))
    ((member type '(hash-table sequence array bit-vector simple-array simple-bit-vector simple-vector vector))
     'cl:equalp)
    ((and (listp type) (member (car type) '(array simple-array simple-bit-vector simple-vector vector)))
     'cl:equalp)
    ((member type '(compiled-function function))
     nil)
    (t 'clj:==)))

(defun map? (thing)
  (typep thing 'cl-hamt:hash-dict))

(defun map-type? (type)
  (and type
       (listp type)
       (eq (car type) 'dict)))

(defun kv-types (k-type v-type)
  (lambda (map)
    (cl-hamt:dict-reduce
     (lambda (memo k v)
       (and memo (typep k k-type) (typep v v-type)))
     map t)))

(deftype dict (&optional keys vals)
  (format t "TYPECHECK ~a ~b" keys vals)
  (let ((sym (intern (format nil "MAP-TYPE-~a-~a" keys vals) :clj)))

    (unless (fboundp sym)
      (setf (fdefinition sym) (kv-types keys vals)))

    `(and (satisfies map?) (satisfies ,sym))))
