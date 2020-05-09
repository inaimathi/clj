(in-package #:clj-test)

(named-readtables:in-readtable clj:syntax)

(tests

 (subtest "Dicts"
   (is t (cl-hamt:dict-eq (read-from-string "{:a 1 :b 2}") {:a 1 :b 2})
       "Basic dicts are readably printed")
   ;; FIXME - this doesn't pass at this point. cl-hamt _does_ support recursive dict
   ;;         comparisons, so this is a bug in your reading/printing thing
   ;; (is t (cl-hamt:dict-eq (read-from-string "{:a 1 :b {:c 3}}") {:a 1 :b {:c 3}})
   ;;     "Nested dicts are readably printed")
   )

 (subtest "Sets"
   (is t (cl-hamt:set-eq (read-from-string "#{1 2 3}") #{1 2 3})
       "Basic set syntax works")
   ;; (is t (cl-hamt:set-eq (read-from-string "#{:a :b :c}") #{:a :b :c})
   ;;     "Basic set syntax works")
   )

 (subtest "Dict literals"
   (is (cl-hamt:dict-lookup {:a 1 :b 2} :b) 2
       "Basic dict syntax works")
   (is nil (eq {:a 1} {:a 1})
       "Two equal dicts are not pointer equivalent")
   (is t (cl-hamt:dict-eq {:a 1} {:a 1})
       "Two equal dicts are structurally equivalent")
   (is t (cl-hamt:dict-eq (cl-hamt:dict-lookup {:a 1 :b {:c 3}} :b) {:c 3})
       "Dicts can contain dicts"))

 (subtest "Set literals"
   (is t (cl-hamt:set-eq #{1 2 3} #{1 2 3})
       "Basic set syntax works")
   (is nil (eq #{1 2 3} #{1 2 3})
       "Two equal sets are not pointer equivalent")
   (is t (cl-hamt:set-eq #{1 2 3} #{1 2 3})
       "Two equal sets are structurally equivalent"))

 ;; (subtest "TODOs"
 ;;   (is t (cl-hamt:dict-eq {:a 1 {:b 2} 3} {:a 1 {:b 2} 3})
 ;;       "You can use dicts as dict keys")
 ;;   (is t (cl-hamt:set-eq #{1 #{2 3} 4} #{1 #{2 3} 4})
 ;;       "You can have recursive sets"))
 )
