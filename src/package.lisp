;;;; src/package.lisp

(defpackage #:clj
  (:use #:cl)
  (:shadow #:map #:set)
  (:export #:syntax
	   #:== #:alist->map #:list->set
	   #:-> #:->>
	   #:if-let #:when-let))
