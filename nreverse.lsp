;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Wed Aug 21 00:04:57 2002
;;;; Contains: Tests for NREVERSE

(in-package :cl-test)

(deftest nreverse-list.1
  (nreverse nil)
  nil)

(deftest nreverse-list.2
  (let ((x (copy-seq '(a b c))))
    (nreverse x))
  (c b a))

(deftest nreverse-vector.1
  (nreverse #())
  #())

(deftest nreverse-vector.2
  (let ((x (copy-seq #(a b c d e))))
    (nreverse x))
  #(e d c b a))

(deftest nreverse-nonsimple-vector.1
  (let ((x (make-array 0 :fill-pointer t :adjustable t)))
    (nreverse x))
  #())

(deftest nreverse-nonsimple-vector.2
  (let* ((x (make-array 5 :initial-contents '(1 2 3 4 5)
			:fill-pointer t :adjustable t))
	 (y (nreverse x)))
    (values y (equal (type-of x) (type-of y))))
  #(5 4 3 2 1)
  t)

(deftest nreverse-bitstring.1
  (nreverse #*)
  #*)

(deftest nreverse-bitstring.2
  (let ((x (copy-seq #*000110110110)))
    (nreverse x))
  #*011011011000)

(deftest nreverse-string.1
  (nreverse "")
  "")

(deftest nreverse-string.2
  (let ((x (copy-seq "000110110110")))
    (nreverse x))
  "011011011000")

(deftest nreverse-error.1
  (catch-type-error (nreverse 'a))
  type-error)

(deftest nreverse-error.2
  (catch-type-error (nreverse #\a))
  type-error)

(deftest nreverse-error.3
  (catch-type-error (nreverse 10))
  type-error)

(deftest nreverse-error.4
  (catch-type-error (nreverse 0.3))
  type-error)

(deftest nreverse-error.5
  (catch-type-error (nreverse 10/3))
  type-error)

	 





