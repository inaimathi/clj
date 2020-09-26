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

	   #:inc #:dec

	   #:lookup #:insert #:dissoc #:invert #:len #:contains? #:empty?

	   #:merge-with #:update #:as-list
	   #:seq? #:fmap #:walk))
