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

(defmethod insert ((container cl-hamt:hash-dict) k &optional v)
  (cl-hamt:dict-insert container k v))

(defmethod lookup ((container cl-hamt:hash-dict) key)
  (cl-hamt:dict-lookup container key))

(defmethod == ((a cl-hamt:hash-dict) (b cl-hamt:hash-dict))
  (cl-hamt:dict-eq a b :value-test #'==))
