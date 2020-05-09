;;;; clj.asd

(asdf:defsystem #:clj
  :description "Describe clj here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:named-readtables #:cl-hamt) ;; #:arrow-macros
  :components ((:module
		src :components
		((:file "package")
		 (:file "syntax")
		 (:file "readable-representations")
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
		 (:test-file "syntax")
                 (:test-file "clj"))))
  :perform (test-op
	    :after (op c)
	    (funcall (intern #.(string :run) :prove) c)))
