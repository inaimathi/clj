;;;; src/package.lisp

(defpackage #:clj
  (:use #:cl #:arrow-macros)
  (:shadow #:map #:set)
  (:export #:syntax #:as #:~ #:fn
	   #:== #:alist->map #:list->set
	   #:-> #:->> #:<> #:-<> #:-<>>
	   #:as-> #:some-> #:some->> #:some-<> #:some-<>>
	   #:cond-> #:cond->>
	   #:if-let #:when-let

	   #:lookup #:insert #:dissoc #:len #:contains? #:empty?

	   #:merge-with #:update #:as-list))
