(in-package :clj)

(defmethod print-object ((object cl-hamt:hash-set) stream)
  (format stream "#{~{~s~^ ~}}" (cl-hamt:set->list object)))

(defmethod cl-murmurhash:murmurhash ((object cl-hamt:hash-set) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (cl-hamt:set->list object) :seed seed :mix-only mix-only))

(defmethod lookup ((container cl-hamt:hash-set) key)
  (cl-hamt:set-lookup container key))

(defmethod == ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))
