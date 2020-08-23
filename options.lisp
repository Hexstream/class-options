(in-package #:class-options)

(defvar *%options* nil)

(defclass class-options:options-mixin (c2mop:standard-class)
  ())

(defgeneric class-options:canonicalize-options (class &rest options &key &allow-other-keys)
  (:method ((class cl:class) &rest options)
    options))

(defun %canonicalize (call-next-method class operation options)
  (let* ((canonicalized-options (let ((*%operation* operation))
                                  (apply #'class-options:canonicalize-options class options)))
         (*%options* canonicalized-options))
    (apply call-next-method class canonicalized-options)))

(defmethod initialize-instance :around ((class class-options:options-mixin) &rest options)
  (%canonicalize #'call-next-method class 'initialize-instance options))

(defmethod reinitialize-instance :around ((class class-options:options-mixin) &rest options)
  (%canonicalize #'call-next-method class 'reinitialize-instance options))

(defun class-options:options ()
  (or *%options*
      (error 'class-options:read-error
             :reader 'class-options:options
             :required-mixin 'class-options:options-mixin)))
