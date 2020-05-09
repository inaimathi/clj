;;;; test/clj.lisp

(in-package #:clj-test)

(tests

 (subtest "Thread"
   (is-expand (-> a foo) (foo a)
	      "Thread applies a function to an argument")
   (is-expand (-> a foo bar) (bar (foo a))
	      "Thread can compose multiple functions")
   (is-expand (-> a (foo 1)) (foo a 1)
	      "If called with a partially applied multi-argument function, thread plants the target in the first slot")
   (is-expand (-> a (foo 1) (foo 2)) (foo (foo a 1) 2)
	      "Thread can nest multi-arity function calls")
   (is-expand (-> a foo (bar 1) (bar 2)) (bar (bar (foo a) 1) 2)
	      "Thread can nest single and multi-arity function calls")
   (is-expand (-> a foo (bar 1) (bar 2) baz) (baz (bar (bar (foo a) 1) 2))
	      "Thread can nest single and multi-arity function calls. Again.")
   (is-expand (-> a #'foo (lambda (b) (bar b)) baz)
	      (BAZ (FUNCALL (LAMBDA (B) (BAR B)) (FUNCALL #'FOO A)))
	      "Thread handles #' terms and lambda forms properly"))

 (subtest "Rthread"
   (is-expand (->> a foo) (foo a)
	      "Rthread applies a function to an argument")
   (is-expand (->> a foo bar) (bar (foo a))
	      "Rthread can compose multiple functions")
   (is-expand (->> a (foo 1)) (foo 1 a)
	      "If called with a partially applied multi-argument function, rthread plants the target in the last slot")
   (is-expand (->> a (foo 1) (foo 2)) (foo 2 (foo 1 a))
	      "Rthread can nest multi-arity function calls")
   (is-expand (->> a foo (bar 1) (bar 2)) (bar 2 (bar 1 (foo a)))
	      "Rthread can nest single and multi-arity function calls")
   (is-expand (->> a foo (bar 1) (bar 2) baz) (baz (bar 2 (bar 1 (foo a))))
	      "Rthread can nest single and multi-arity function calls. Again.")
   (is-expand (->> a #'foo (lambda (b) (bar b)) baz)
	      (BAZ (FUNCALL (LAMBDA (B) (BAR B)) (FUNCALL #'FOO A)))
	      "Rthread handles #' terms and lambda forms properly")))
