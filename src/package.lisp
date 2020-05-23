;;;; src/package.lisp

(defpackage #:clj
  (:use #:cl #:arrow-macros)
  (:shadow #:map #:set)
  (:export #:syntax
	   #:== #:alist->map #:list->set
	   #:-> #:->> #:<> #:-<> #:-<>>
	   #:as-> #:some-> #:some->> #:some-<> #:some-<>>
	   #:cond-> #:cond->>
	   #:if-let #:when-let))
