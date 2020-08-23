(asdf:defsystem #:class-options

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "Provides easy access to the defining class and its options during initialization."

  :depends-on ("closer-mop")

  :version "1.0"
  :serial cl:t
  :components ((:file "package")
               (:file "conditions")
               (:file "class")
               (:file "operation")
               (:file "options"))

  :in-order-to ((asdf:test-op (asdf:test-op #:class-options_tests))))
