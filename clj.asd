;;;; clj.asd

(asdf:defsystem #:clj
  :description "Some clojure conveniences for Common Lisp"
  :author "inaimathi <leo.zovic@gmail.com>"
  :license "MIT Expat <https://www.debian.org/legal/licenses/mit>"
  :version "0.0.1"
  :serial t
  :depends-on (#:named-readtables #:cl-hamt #:optima #:arrow-macros #:test-utils #:local-package-aliases #:agnostic-lizard)
  :components ((:module
		src :components
		((:file "package")
		 (:file "types")
		 (:file "syntax")
		 (:file "generics")
		 (:file "map")
		 (:file "set")
		 (:file "generators")
		 (:file "clj")))))

(asdf:defsystem #:clj-test
  :description "Test suite for :clj"
  :author "inaimathi <leo.zovic@gmail.com>"
  :license "MIT Expat <https://www.debian.org/legal/licenses/mit>"
  :serial t
  :depends-on (#:clj #:test-utils)
  :defsystem-depends-on (#:prove-asdf)
  :components ((:module
                test :components
                ((:file "package")
		 ;; (:test-file "types")
		 (:test-file "syntax")
                 (:test-file "clj"))))
  :perform (test-op
	    :after (op c)
	    (funcall (intern #.(string :run) :prove) c)))
