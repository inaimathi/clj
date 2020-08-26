(in-package :clj)

(defmethod print-object ((object cl-hamt:hash-set) stream)
  (if (eq 'clj:syntax (named-readtables:readtable-name *readtable*))
      (format stream "#{~{~s~^ ~}}" (cl-hamt:set->list object))
      (format stream "(CLJ:LIST->SET (LIST ~{~S~^ ~}))" (cl-hamt:set->list object))))

(defmethod cl-murmurhash:murmurhash ((object cl-hamt:hash-set) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (cl-hamt:set->list object) :seed seed :mix-only mix-only))

(defmethod == ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))

(defmethod lookup ((container cl-hamt:hash-set) key)
  (cl-hamt:set-lookup container key))

(defmethod insert ((container cl-hamt:hash-set) elem)
  (cl-hamt:set-insert container elem))

(defmethod len ((container cl-hamt:hash-set)) (cl-hamt:set-size container))

(defmethod contains? ((container cl-hamt:hash-set) elem)
  (nth-value 1 (cl-hamt:set-lookup container elem)))
