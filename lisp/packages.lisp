(in-package :cl-user)

(defpackage :com.sample.pathnames
  (:use :common-lisp)
  (:export
   :list-directory
   :file-exists-p
   :directory-pathname-p
   :file-pathname-p
   :pathname-as-directory
   :pathname-as-file
   :walk-directory
   :directory-p
   :file-p))

(defpackage :com.sample.spam
  (:use :common-lisp :com.sample.pathnames))
