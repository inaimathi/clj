;;;; test/clj.lisp

(in-package #:clj-test)

(tests
 (is-expand (-> a foo) (foo a))
 (is-expand (-> a foo bar) (bar (foo a)))
 (is-expand (-> a (foo 1)) (foo a 1))
 (is-expand (-> a (foo 1) (foo 2)) (foo (foo a 1) 2))
 (is-expand (-> a foo (bar 1) (bar 2)) (bar (bar (foo a) 1) 2))
 (is-expand (-> a foo (bar 1) (bar 2) baz) (baz (bar (bar (foo a) 1) 2))))

(tests
 (is-expand (->> a foo) (foo a))
 (is-expand (->> a foo bar) (bar (foo a)))
 (is-expand (->> a (foo 1)) (foo 1 a))
 (is-expand (->> a (foo 1) (foo 2)) (foo 2 (foo 1 a)))
 (is-expand (->> a foo (bar 1) (bar 2)) (bar 2 (bar 1 (foo a))))
 (is-expand (->> a foo (bar 1) (bar 2) baz) (baz (bar 2 (bar 1 (foo a))))))
