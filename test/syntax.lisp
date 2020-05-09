(in-package #:clj-test)

(named-readtables:in-readtable clj:syntax)

(tests

 (subtest "Hash literals"
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
