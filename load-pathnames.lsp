;-*- Mode:     Lisp -*-
;;;; Author:   Paul Dietz
;;;; Created:  Sat Nov 29 04:33:05 2003
;;;; Contains: Load tests for pathnames and logical pathnames

(in-package :cl-test)

(compile-and-load "pathnames-aux.lsp")

(load "pathnames.lsp")
(load "pathname.lsp")
(load "make-pathname.lsp")
(load "pathname-host.lsp")
(load "pathname-device.lsp")
(load "pathname-directory.lsp")
(load "pathname-name.lsp")
(load "pathname-type.lsp")
(load "pathname-version.lsp")
