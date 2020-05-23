(in-package #:clj-test)

(named-readtables:in-readtable clj:syntax)

(tests

 (subtest "Map types work correctly"
   (is t nil
       "A map with a specific type declaration uses a more specific key test")
   (is t nil
       "A map with an appropriate set of values typechecks")
   (is t nli
       "A map whose type declaration does not match its values errors at read time"))
 (subtest "Set types work correctly"
   (is t nil
       "A map with a specific type declaration uses a more specific key test")
   (is t nil
       "A map with an appropriate set of values typechecks")
   (is t nli
       "A map whose type declaration does not match its values errors at read time"))
 (subtest "Type annotations work for built-in types"))
