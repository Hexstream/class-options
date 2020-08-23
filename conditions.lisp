(in-package #:class-options)

(define-condition class-options:read-error (error)
  ((%reader :initarg :reader
            :reader class-options:reader
            :type symbol
            :initform (error "~S must be supplied." :reader))
   (%required-mixin :initarg :required-mixin
                    :reader class-options:required-mixin
                    :type symbol
                    :initform (error "~S must be supplied." :required-mixin)))
  (:report (lambda (condition stream)
             (format stream "Tried to read ~S but no class is being (re)defined or ~S was not used for this class."
                     (class-options:reader condition)
                     (class-options:required-mixin condition)))))
