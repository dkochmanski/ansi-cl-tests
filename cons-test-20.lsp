;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Mar 28 22:11:27 1998
;;;; Contains: Testing of CL Features related to "CONS", part 20

(in-package :cl-test)
(use-package :rt)
(declaim (optimize (safety 3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; union

(deftest union-1
    (union nil nil)
  nil)

(deftest union-2
    (union-with-check (list 'a) nil)
  (a))

(deftest union-3
    (union-with-check (list 'a) (list 'a))
  (a))

(deftest union-4
    (union-with-check (list 1) (list 1))
  (1))

(deftest union-5
    (let ((x (list 'a 'b)))
      (union-with-check (list x) (list x)))
  ((a b)))

(deftest union-6
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y)))
	(check-union x y result)))
  t)

(deftest union-6-a
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test #'eq)))
	(check-union x y result)))
  t)

(deftest union-7
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test #'eql)))
	(check-union x y result)))
  t)

(deftest union-8
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test #'equal)))
	(check-union x y result)))
  t)

(deftest union-9
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test-not (complement #'eql))))
	(check-union x y result)))
  t)

(deftest union-10
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test-not (complement #'equal))))
	(check-union x y result)))
  t)

(deftest union-11
    (let ((x (copy-list '(a b c d e f)))
	  (y (copy-list '(z c y a v b))))
      (let ((result (union-with-check x y :test-not (complement #'eq))))
	(check-union x y result)))
  t)

(deftest union-12
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check x y)))
	(check-union x y result)))
  t)

(deftest union-13
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check x y :test #'equal)))
	(check-union x y result)))
  t)

(deftest union-14
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check x y :test #'eql)))
	(check-union x y result)))
  t)

(deftest union-15
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check x y :test-not (complement #'equal))))
	(check-union x y result)))
  t)

(deftest union-16
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check x y :test-not (complement  #'eql))))
	(check-union x y result)))
  t)

(deftest union-17
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check-and-key x y #'1+)))
	(check-union x y result)))
  t)

(deftest union-18
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check-and-key x y #'1+ :test #'equal)))
	(check-union x y result)))
  t)

(deftest union-19
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check-and-key x y #'1+ :test #'eql)))
	(check-union x y result)))
  t)

(deftest union-20
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check-and-key x y #'1+
					      :test-not (complement #'equal))))
	(check-union x y result)))
  t)

(deftest union-21
    (let ((x (copy-list '(1 2 3 4 5 6 7)))
	  (y (copy-list '(10 19 5 3 17 1001 2))))
      (let ((result (union-with-check-and-key x y #'1+
					      :test-not (complement #'equal))))
	(check-union x y result)))
  t)

(deftest union-22
  (let ((x (copy-list '(1 2 3 4 5 6 7)))
	(y (copy-list '(10 19 5 3 17 1001 2))))
    (let ((result (union-with-check-and-key x y nil)))
      (check-union x y result)))
  t)

(deftest union-23
  (let ((x (copy-list '(1 2 3 4 5 6 7)))
	(y (copy-list '(10 19 5 3 17 1001 2))))
    (let ((result (union-with-check-and-key x y '1+)))
      (check-union x y result)))
  t)

;; Do large numbers of random units

(deftest union-24
  (do-random-unions 100 100 200)
  nil)

(deftest union-25
  (let ((x (shuffle '(1 4 6 10 45 101)))
	(y (copy-list '(102 5 2 11 44 6))))
    (let ((result (union-with-check x y
				    :test #'(lambda (a b)
						    (<= (abs (- a b)) 1)))))
      (and
       (not (eqt result 'failed))
       (sort
	(sublis
	 '((2 . 1) (5 . 4) (11 . 10) (45 . 44) (102 . 101))
	 (copy-list result))
	#'<))))
  (1 4 6 10 44 101))

;;; Check that union uses eql, not equal or eq

(deftest union-26
  (let ((x 1000)
	(y 1000))
    (loop
     while (not (typep x 'bignum))
     do (progn
	  (setf x (* x x))
	  (setf y (* y y))))
    (not (not
	  (or
	   (eqt x y)  ;; if bignums are eq, the test is worthless
	   (eql (length
		 (union-with-check
		  (list x) (list x)))
		1)))))
  t)

(deftest union-27
  (union-with-check (list (copy-seq "aa"))
		    (list (copy-seq "aa")))
  ("aa" "aa"))

;; Check that union does not reverse the arguments to :test, :test-not

(deftest union-28
    (block fail
      (sort
       (union-with-check
	(list 1 2 3)
	(list 4 5 6)
	:test #'(lambda (x y)
		  (when (< y x) (return-from fail 'fail))
		  (eql x y)))
       #'<))
  (1 2 3 4 5 6))

(deftest union-29
    (block fail
      (sort
       (union-with-check-and-key
	(list 1 2 3)
	(list 4 5 6)
	#'identity
	:test #'(lambda (x y)
		  (when (< y x) (return-from fail 'fail))
		  (eql x y)))
       #'<))
  (1 2 3 4 5 6))

(deftest union-30
    (block fail
      (sort
       (union-with-check
	(list 1 2 3)
	(list 4 5 6)
	:test-not
	#'(lambda (x y)
	    (when (< y x) (return-from fail 'fail))
	    (not (eql x y))))
       #'<))
  (1 2 3 4 5 6))

(deftest union-31
    (block fail
      (sort
       (union-with-check-and-key
	(list 1 2 3)
	(list 4 5 6)
	#'identity
	:test-not #'(lambda (x y)
		      (when (< y x) (return-from fail 'fail))
		      (not (eql x y))))
       #'<))
  (1 2 3 4 5 6))

(deftest union-32
  (sort (union (list 7 9 1 5) (list 10 11 9 20 1 2) :bad t
	       :allow-other-keys "yes")
	#'<)
  (1 2 5 7 9 10 11 20))

(deftest union-33
  (sort (union (list 7 9 1 5) (list 10 11 9 20 1 2)
	       :allow-other-keys t :also-bad t)
	#'<)
  (1 2 5 7 9 10 11 20))

(deftest union-34
  (sort (union (list 1 2 3) (list 1 2 3)
	       :allow-other-keys t :also-bad t
	       :test #'(lambda (x y) (= x (+ y 100))))
	#'<)
  (1 1 2 2 3 3))


(deftest union.error.1
  (classify-error (union))
  program-error)

(deftest union.error.2
  (classify-error (union nil))
  program-error)

(deftest union.error.3
  (classify-error (union nil nil :bad t))
  program-error)

(deftest union.error.4
  (classify-error (union nil nil :key))
  program-error)

(deftest union.error.5
  (classify-error (union nil nil 1 2))
  program-error)

(deftest union.error.6
  (classify-error (union nil nil :bad t :allow-other-keys nil))
  program-error)