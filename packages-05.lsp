;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Apr 25 07:59:45 1998
;;;; Contains: Package test code, part 05

(in-package :cl-test)
(declaim (optimize (safety 3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; export

(deftest export-1
    (let ((return-value nil))
      (ignore-errors (delete-package "TEST1"))
      (let ((p (make-package "TEST1")))
	(let ((sym (intern "FOO" p)))
	  (setf return-value (export sym p))
	  (multiple-value-bind (sym2 status)
	      (find-symbol "FOO" p)
	    (prog1
		(and sym2
		     (eq (symbol-package sym2) p)
		     (string= (symbol-name sym2) "FOO")
		     (eq sym sym2)
		     (eq status :external))
	      (delete-package p)))))
      return-value)
  t)

(deftest export-2
    (progn (ignore-errors (delete-package "TEST1"))
	   (let ((p (make-package "TEST1")))
	     (let ((sym (intern "FOO" p)))
	       (export (list sym) p)
	       (multiple-value-bind (sym2 status)
		   (find-symbol "FOO" p)
		 (prog1
		     (and sym2
			  (eq (symbol-package sym2) p)
			  (string= (symbol-name sym2) "FOO")
			  (eq sym sym2)
			  (eq status :external))
		   (delete-package p))))))
  t)

(deftest export-3
    (handler-case
	(progn
	  (make-package "F")
	  (let ((sym (intern "FOO" "F")))
	    (export sym #\F)
	    (delete-package "F")
	    t))
      (error (c) (delete-package "F") c))
  t)

;;
;; When a symbol not in a package is exported, export
;; should signal a correctable package-error asking the
;; user whether the symbol should be imported.
;;
(deftest export-4
    (handler-case
	(export 'b::bar "A")
      (package-error () 'package-error)
      (error (c) c))
  package-error)

;;
;; Test that it catches an attempt to export a symbol
;; from a package that is used by another package that
;; is exporting a symbol with the same name.
;;
(deftest export-5
    (progn
      (make-package "TEST1")
      (make-package "TEST2" :use '("TEST1"))
      (export (intern "X" "TEST2") "TEST2")
      (prog1
	  (handler-case
	      (let ((sym (intern "X" "TEST1")))
		(handler-case
		    (export sym "TEST1")
		  (error (c)
		    (format t "Caught error in EXPORT-5: ~A~%" c)
		    'caught)))
	    (error (c) c))
	(delete-package "TEST2")
	(delete-package "TEST1")))
  caught)
