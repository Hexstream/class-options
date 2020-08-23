(in-package #:class-options)

(defvar *%class* nil)

(defclass class-options:class-mixin (c2mop:standard-class)
  ())

(defmethod initialize-instance :around ((class class-options:class-mixin) &key)
  (let ((*%class* class))
    (call-next-method)))

(defmethod reinitialize-instance :around ((class class-options:class-mixin) &key)
  (let ((*%class* class))
    (call-next-method)))

(defun class-options:class ()
  (or *%class*
      (error 'class-options:read-error
             :reader 'class-options:class
             :required-mixin 'class-options:class-mixin)))
