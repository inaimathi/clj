(in-package :clj)

(defmethod print-object ((object cl-hamt:hash-dict) stream)
  "The printable representation for clj:maps"
  (if (eq 'clj:syntax (named-readtables:readtable-name *readtable*))
      (format
       stream
       "{~{~s ~s~^ ~}}"
       (reverse (cl-hamt:dict-reduce (lambda (memo k v) (cons v (cons k memo))) object nil)))
      (format stream "(CLJ:ALIST->MAP (LIST ~{~S~^ ~}))" (cl-hamt:dict->alist object))))

(defmethod cl-murmurhash:murmurhash ((object cl-hamt:hash-dict) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (cl-hamt:dict->alist object) :seed seed :mix-only mix-only))

(defmethod == ((a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-eq a b :value-test #'==))

(defmethod lookup ((container cl-hamt:hash-dict) key &key default)
  (if (nth-value 1 (cl-hamt:dict-lookup container key))
      (cl-hamt:dict-lookup container key)
      default))

(defmethod insert ((container cl-hamt:hash-dict) &rest args)
  (apply #'cl-hamt:dict-insert container args))

(defmethod dissoc ((container cl-hamt:hash-dict) &rest ks-or-elems)
  (apply #'cl-hamt:dict-remove container ks-or-elems))

(defmethod invert ((container cl-hamt:hash-dict))
  (cl-hamt:dict-reduce
   (lambda (memo k v) (insert memo v k))
   container {}))

(defmethod len ((container cl-hamt:hash-dict)) (cl-hamt:dict-size container))

(defmethod contains? ((container cl-hamt:hash-dict) elem)
  (nth-value 1 (cl-hamt:dict-lookup container elem)))

(defmethod merge-with ((f function) (a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-reduce
   (lambda (memo k v)
     (cl-hamt:dict-insert
      memo k
      (if (nth-value 1 (cl-hamt:dict-lookup memo k))
	  (funcall f (cl-hamt:dict-lookup memo k) v)
	  v)))
   b a))

(defmethod update ((container cl-hamt:hash-dict) k f)
  (cl-hamt:dict-insert container k (funcall f (cl-hamt:dict-lookup container k))))

(defmethod as-list ((container cl-hamt:hash-dict))
  (cl-hamt:dict->alist container))
