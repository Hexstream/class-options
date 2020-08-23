(asdf:defsystem #:class-options_tests

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "class-options unit tests."

  :depends-on ("class-options"
               "parachute"
               "closer-mop"
               "enhanced-boolean")

  :serial cl:t
  :components ((:file "tests"))

  :perform (asdf:test-op (op c) (uiop:symbol-call '#:parachute '#:test '#:class-options_tests)))
