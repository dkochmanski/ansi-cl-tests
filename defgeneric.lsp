;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat May 17 20:55:50 2003
;;;; Contains: Tests of DEFGENERIC

(in-package :cl-test)

;;; Various error cases

(defun defgeneric-testfn-01 (x) x)

(deftest defgeneric.error.1
  ;; Cannot make ordinary functions generic
  (let* ((name 'defgeneric-testfn-01)
	 (fn (symbol-function name)))
    (if (not (typep fn 'generic-function))
	(handler-case
	 (progn (eval `(defgeneric ,name ())) :bad)
	 (program-error () :good))
      :good))
  :good)

(defmacro defgeneric-testmacro-02 (x) x)

(deftest defgeneric.error.2
  ;; Cannot make macros generic
  (let* ((name 'defgeneric-testmacro-02))
    (handler-case
     (progn (eval `(defgeneric ,name ())) :bad)
     (program-error () :good)))
  :good)

(deftest defgeneric.error.3
  ;; Cannot make special operators generic
  (loop for name in *cl-special-operator-symbols*
	for result =
	(handler-case
	 (progn (eval `(defgeneric ,name ())) t)
	 (program-error () nil))
	when result collect name)
  nil)

(deftest defgeneric.error.4
  (classify-error (defgeneric defgeneric-error-fn.4 (x y)
		    (:argument-precedence-order x y x)))
  program-error)

(deftest defgeneric.error.5
  (classify-error (defgeneric defgeneric-error-fn.5 (x)
		    (:documentation "some documentation")
		    (:documentation "illegally repeated documentation")))
  program-error)

(deftest defgeneric.error.6
  (classify-error (defgeneric defgeneric-error-fn.6 (x)
		    (unknown-option nil)))
  program-error)

(deftest defgeneric.error.7
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.7 (x y)
	      (:method ((x t)) x)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.8
  (classify-error (defgeneric defgeneric-error-fn.8 (x y)
		    (:argument-precedence-order x)))
  program-error)


;;; Non-congruent methods cause defgeneric to signal an error

(deftest defgeneric.error.9
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.9 (x)
	      (:method ((x t)(y t)) t)))
     :bad)
   (error () :good))
  :good)


(deftest defgeneric.error.10
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.10 (x &optional y)
	      (:method ((x t)) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.11
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.11 (x &optional y)
	      (:method (x &optional y z) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.12
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.12 (x &rest y)
	      (:method (x) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.13
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.13 (x)
	      (:method (x &rest y) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.14
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.14 (x &key)
	      (:method (x) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.15
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.15 (x &key y)
	      (:method (x) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.16
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.16 (x)
	      (:method (x &key) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.17
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.17 (x)
	      (:method (x &key foo) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.18
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.18 (x &key foo)
	      (:method (x &key) t)))
     :bad)
   (error () :good))
  :good)

(deftest defgeneric.error.19
  (handler-case
   (progn
     (eval '(defgeneric defgeneric-error-fn.19 (x &key foo)
	      (:method (x &key bar) t)))
     :bad)
   (error () :good))
  :good)

;;; Non error cases

(deftest defgeneric.1
  (let ((fn (eval '(defgeneric defgeneric.fun.1 (x y z)
		     (:method ((x t) (y t) (z t)) (list x y z))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (funcall fn 'a 'b 'c)
     (apply fn 1 2 3 nil)
     (apply fn (list 4 5 6))
     (mapcar fn '(1 2) '(3 4) '(5 6))
     (defgeneric.fun.1 'd 'e 'f)))
  t t (a b c) (1 2 3) (4 5 6) ((1 3 5) (2 4 6)) (d e f))

(deftest defgeneric.2
  (let ((fn (eval '(defgeneric defgeneric.fun.2 (x y z)
		     (:documentation "boo!")
		     (:method ((x t) (y t) (z t)) (vector x y z))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (funcall fn 'a 'b 'c)
     (defgeneric.fun.2 'd 'e 'f)
     (let ((doc (documentation fn t)))
       (or (not doc)
	   (and (stringp doc) (string=t doc "boo!"))))
     (let ((doc (documentation fn 'function)))
       (or (not doc)
	   (and (stringp doc) (string=t doc "boo!"))))))
     
  t t #(a b c) #(d e f) t t)

(deftest defgeneric.3
  (let ((fn (eval '(defgeneric defgeneric.fun.3 (x y)
		     (:method ((x t) (y symbol)) (list x y))
		     (:method ((x symbol) (y t)) (list y x))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (funcall fn 1 'a)
     (funcall fn 'b 2)
     (funcall fn 'a 'b)))
  t t
  (1 a)
  (2 b)
  (b a))

(deftest defgeneric.4
  (let ((fn (eval '(defgeneric defgeneric.fun.4 (x y)
		     (:argument-precedence-order y x)
		     (:method ((x t) (y symbol)) (list x y))
		     (:method ((x symbol) (y t)) (list y x))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (funcall fn 1 'a)
     (funcall fn 'b 2)
     (funcall fn 'a 'b)))
  t t
  (1 a)
  (2 b)
  (a b))

(deftest defgeneric.5
  (let ((fn (eval '(defgeneric defgeneric.fun.5 ()
		     (:method () (values))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (multiple-value-list (funcall fn))
     (multiple-value-list (defgeneric.fun.5))
     (multiple-value-list (apply fn nil))))
  t t nil nil nil)

(deftest defgeneric.6
  (let ((fn (eval '(defgeneric defgeneric.fun.6 ()
		     (:method () (values 'a 'b 'c))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (multiple-value-list (funcall fn))
     (multiple-value-list (defgeneric.fun.6))
     (multiple-value-list (apply fn nil))))
  t t (a b c) (a b c) (a b c))

(deftest defgeneric.7
  (let ((fn (eval '(defgeneric defgeneric.fun.7 ()
		     (:method () (return-from defgeneric.fun.7 'a) 'b)))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (multiple-value-list (funcall fn))
     (multiple-value-list (defgeneric.fun.7))
     (multiple-value-list (apply fn nil))))
  t t (a) (a) (a))

(deftest defgeneric.8
  (let ((fn (eval '(defgeneric defgeneric.fun.8 (x &optional y z)
		     (:method ((x number) &optional y z)
			      (list x y z))
		     (:method ((p symbol) &optional q r)
			      (list r q p))))))
    (values
     (typep* fn 'generic-function)
     (typep* fn 'standard-generic-function)
     (multiple-value-list (funcall fn 1))
     (multiple-value-list (funcall fn 1 2))
     (multiple-value-list (funcall fn 1 2 3))
     (multiple-value-list (defgeneric.fun.8 'a))
     (multiple-value-list (defgeneric.fun.8 'a 'b))
     (multiple-value-list (defgeneric.fun.8 'a 'b 'c))
     (multiple-value-list (apply fn '(x y z)))))
  t t
  ((1 nil nil))
  ((1 2 nil))
  ((1 2 3))
  ((nil nil a))
  ((nil b a))
  ((c b a))
  ((z y x)))

(deftest defgeneric.9
  (let ((fn (eval '(defgeneric defgeneric.fun.9 (x &optional y z)
		     (:method ((x number) &optional (y 10) (z 20))
			      (list x y z))
		     (:method ((p symbol) &optional (q 's) (r 't))
			      (list r q p))))))
    (values
     (funcall fn 1)
     (funcall fn 1 2)
     (funcall fn 1 2 3)
     (funcall fn 'a)
     (funcall fn 'a 'b)
     (funcall fn 'a 'b 'c)))
  (1 10 20)
  (1 2 20)
  (1 2 3)
  (t s a)
  (t b a)
  (c b a))

 (deftest defgeneric.10
   (let ((fn (eval '(defgeneric defgeneric.fun.10 (x &rest y)
		      (:method ((x number) &key foo) (list x foo))))))
     (values
      (funcall fn 1)
      (funcall fn 1 :foo 'a)
      (defgeneric.fun.10 5/3 :foo 'x :foo 'y)
      (defgeneric.fun.10 10 :bar t :allow-other-keys t)
      (defgeneric.fun.10 20 :allow-other-keys nil :foo 'x)))
   (1 nil)
   (1 a)
   (5/3 x)
   (10 nil)
   (20 x))

 (deftest defgeneric.11
   (let ((fn (eval '(defgeneric defgeneric.fun.11 (x &key)
		      (:method ((x number) &key foo) (list x foo))))))
     (values
      (funcall fn 1)
      (funcall fn 1 :foo 'a)
      (defgeneric.fun.11 5/3 :foo 'x :foo 'y)
      (defgeneric.fun.11 11 :bar t :allow-other-keys t)
      (defgeneric.fun.11 20 :allow-other-keys nil :foo 'x)))
   (1 nil)
   (1 a)
   (5/3 x)
   (11 nil)
   (20 x))

 (deftest defgeneric.12
   (let ((fn (eval '(defgeneric defgeneric.fun.12 (x &key foo bar baz)
		      (:method ((x number) &rest y) (list x y))))))
     (values
      (funcall fn 1)
      (funcall fn 1 :foo 'a)
      (defgeneric.fun.12 5/3 :foo 'x :foo 'y :bar 'z)
      (defgeneric.fun.12 11 :zzz t :allow-other-keys t)
      (defgeneric.fun.12 20 :allow-other-keys nil :foo 'x)))
   (1 nil)
   (1 (:foo a))
   (5/3 (:foo x :foo y :bar z))
   (11 (:zzz t :allow-other-keys t))
   (20 (:allow-other-keys nil :foo x)))

 (deftest defgeneric.13
   (let ((fn (eval '(defgeneric defgeneric.fun.13 (x &key)
		      (:method ((x number) &key foo) (list x foo))
		      (:method ((x symbol) &key bar) (list x bar))))))
     (values
      (funcall fn 1)
      (funcall fn 'a)
      (funcall fn 1 :foo 2)
      (funcall fn 1 :foo 2 :bar 3)
      (funcall fn 1 :bar 4)
      (funcall fn 'a :foo 'b)
      (funcall fn 'a :bar 'b)
      (funcall fn 'a :foo 'c :bar 'b)))
   (1 nil)
   (a nil)
   (1 2)
   (1 2)
   (1 nil)
   (a nil)
   (a b)
   (a b))

 (deftest defgeneric.14
   (let ((fn (eval '(defgeneric defgeneric.fun.14 (x &key &allow-other-keys)
		      (:method ((x number) &key foo) (list x foo))
		      (:method ((x symbol) &key bar) (list x bar))))))
     (values
      (funcall fn 1)
      (funcall fn 'a)
      (funcall fn 1 :foo 2)
      (funcall fn 1 :foo 2 :bar 3)
      (funcall fn 1 :bar 4)
      (funcall fn 'a :foo 'b)
      (funcall fn 'a :bar 'b)
      (funcall fn 'a :foo 'c :bar 'b)
      (funcall fn 1 :baz 10)
      (funcall fn 'a :baz 10)
      (funcall fn 1 :allow-other-keys nil :baz 'a)
      (funcall fn 'a :allow-other-keys nil :baz 'b)
      ))
   (1 nil)
   (a nil)
   (1 2)
   (1 2)
   (1 nil)
   (a nil)
   (a b)
   (a b)
   (1 nil)
   (a nil)
   (1 nil)
   (a nil))


