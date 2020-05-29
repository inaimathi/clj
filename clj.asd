;;;; clj.asd

(asdf:defsystem #:clj
  :description "Describe clj here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:named-readtables #:cl-hamt #:optima #:arrow-macros #:test-utils #:local-package-aliases)
  :components ((:module
		src :components
		((:file "package")
		 (:file "generics")
		 (:file "types")
		 (:file "syntax")
		 (:file "map")
		 (:file "set")
		 (:file "generators")
		 (:file "clj")))))

(asdf:defsystem #:clj-test
  :description "Test suite for :clj"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
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
