(in-package #:class-options)

(defvar *%operation* nil)

(defclass class-options:operation-mixin (c2mop:standard-class)
  ())

(defmethod initialize-instance :around ((class class-options:operation-mixin) &key)
  (let ((*%operation* 'initialize-instance))
    (call-next-method)))

(defmethod reinitialize-instance :around ((class class-options:operation-mixin) &key)
  (let ((*%operation* 'reinitialize-instance))
    (call-next-method)))

(defun class-options:operation ()
  (or *%operation*
      (error 'class-options:read-error
             :reader 'class-options:operation
             :required-mixin 'class-options:operation-mixin)))

;; "and we are not within the dynamic extent of ~S." 'class-options:canonicalize-options
