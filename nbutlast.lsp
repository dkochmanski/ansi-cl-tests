;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Apr 19 22:41:54 2003
;;;; Contains: Tests of NBUTLAST

(in-package :cl-test)

(deftest nbutlast.1
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((y (cdr x))
	  (z (cddr x)))
      (let ((result (nbutlast x 2)))
	(and (eqt x result)
	     (eqt (cdr x) y)
	     (eqt (cddr x) z)
	     result))))
  (a b c))

(deftest nbutlast.2
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((result (nbutlast x 5)))
      (list x result)))
  ((a b c d e) nil))

(deftest nbutlast.3
  (let ((x (list 'a 'b 'c 'd 'e)))
    (let ((result (nbutlast x 500)))
      (list x result)))
  ((a b c d e) nil))

(deftest nbutlast.4
  (let ((x (list* 'a 'b 'c 'd)))
    (let ((result (nbutlast x 1)))
      (and (eqt result x)
	   result)))
  (a b))

(deftest nbutlast.5
  (nbutlast nil)
  nil)

(deftest nbutlast.6
  (nbutlast (list 'a))
  nil)

(deftest nbutlast.7
  (nbutlast (list 'a 'b 'c 'd) (1+ most-positive-fixnum))
  nil)

(deftest nbutlast.8
  (nbutlast (list 'a 'b 'c 'd) most-positive-fixnum)
  nil)

(deftest nbutlast.9
  (nbutlast (list 'a 'b 'c 'd) (1- most-positive-fixnum))
  nil)

(deftest nbutlast.order.1
  (let ((i 0) x y)
    (values
     (nbutlast (progn (setf x (incf i))
		      (list 'a 'b 'c 'd 'e))
	       (progn (setf y (incf i))
		      2))
     i x y))
  (a b c) 2 1 2)

(deftest nbutlast.order.2
  (let ((i 0))
    (values
     (nbutlast (progn (incf i) (list 'a 'b 'c 'd)))
     i))
  (a b c) 1)

(deftest nbutlast.error.1
  (classify-error (let ((x (list* 'a 'b 'c 'd))) (nbutlast x 'a)))
  type-error)

(deftest nbutlast.error.2
  (classify-error (nbutlast 'a 10))
  type-error)

(deftest nbutlast.error.3
  (classify-error (nbutlast 2 10))
  type-error)

(deftest nbutlast.error.4
  (classify-error (nbutlast #\w 10))
  type-error)

(deftest nbutlast.error.5
  (classify-error (nbutlast (list 'a 'b 'c 'd) -3))
  type-error)

(deftest nbutlast.error.6
  (classify-error (nbutlast (list 'a) 20.0))
  type-error)

(deftest nbutlast.error.7
  (classify-error (nbutlast (list 'a) -100.0))
  type-error)

(deftest nbutlast.error.8
  (classify-error (nbutlast))
  program-error)

(deftest nbutlast.error.9
  (classify-error (nbutlast (list 'a 'b 'c) 3 3))
  program-error)

(deftest nbutlast.error.10
  (classify-error (locally (nbutlast 'a 10) t))
  type-error)
