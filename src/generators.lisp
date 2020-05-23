(in-package :test-utils)

(defun a-map (key-generator val-generator)
  (lambda ()
    (clj:alist->map
     (generate (a-list (a-pair key-generator val-generator))))))

(defun a-specific-map (&rest k/gen-pairs)
  (lambda ()
    (clj:alist->map
     (loop for (k gen) on k/gen-pairs by #'cddr
	collect (cons k (generate gen))))))

(defun a-set (val-generator)
  (lambda () (clj:list->set (a-list val-generator))))

(export (list 'a-set 'a-specific-map 'a-map))
