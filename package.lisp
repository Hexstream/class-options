(cl:defpackage #:class-options
  (:use #:cl)
  (:shadow #:class)
  (:export #:read-error
           #:reader
           #:required-mixin

           #:class-mixin
           #:class

           #:options-mixin
           #:options
           #:canonicalize-options

           #:operation-mixin
           #:operation))
