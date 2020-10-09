(in-package :clj)

(defmethod print-object ((object cl-hamt:hash-set) stream)
  (if (eq 'clj:syntax (named-readtables:readtable-name *readtable*))
      (format stream "#{~{~s~^ ~}}" (cl-hamt:set->list object))
      (format stream "(CLJ:LIST->SET (LIST ~{~S~^ ~}))" (cl-hamt:set->list object))))

(defmethod cl-murmurhash:murmurhash ((object cl-hamt:hash-set) &key (seed cl-murmurhash:*default-seed*) mix-only)
  (cl-murmurhash:murmurhash (cl-hamt:set->list object) :seed seed :mix-only mix-only))

(defun set? (thing) (typep thing 'cl-hamt:hash-set))

(defmethod == ((a cl-hamt:hash-set) (b cl-hamt:hash-set))
  (cl-hamt:set-eq a b))

(defmethod lookup ((container cl-hamt:hash-set) key &key default)
  (or (cl-hamt:set-lookup container key) default))

(defmethod insert ((container cl-hamt:hash-set) &rest args)
  (apply #'cl-hamt:set-insert container args))

(defmethod dissoc ((container cl-hamt:hash-set) &rest ks-or-elems)
  (apply #'cl-hamt:set-remove container ks-or-elems))

(defmethod len ((container cl-hamt:hash-set)) (cl-hamt:set-size container))

(defmethod contains? ((container cl-hamt:hash-set) elem)
  (cl-hamt:set-lookup container elem))

(defmethod as-list ((container cl-hamt:hash-set))
  (cl-hamt:set->list container))

(defmethod seq? ((container cl-hamt:hash-set)) t)
(defmethod fmap ((f function) (container cl-hamt:hash-set))
  (cl-hamt:set-map f container))
