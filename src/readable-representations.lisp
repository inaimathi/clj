(in-package #:clj)

(defmethod print-object ((object cl-hamt:hash-dict) stream)
  (format
   stream
   "{~{~s ~s~^ ~}}"
   (reverse (cl-hamt:dict-reduce (lambda (memo k v) (cons v (cons k memo))) object nil))))

(defmethod print-object ((object cl-hamt:hash-set) stream)
  (format stream "#{~{~s~^ ~}}" (cl-hamt:set->list object)))
