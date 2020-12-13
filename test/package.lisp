;;;; test/package.lisp

(defpackage #:clj/test
  (:use #:cl #:clj #:test-utils)
  (:shadow #:union))
