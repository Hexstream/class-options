(cl:defpackage #:class-options_tests
  (:use #:cl #:parachute)
  (:shadowing-import-from #:enhanced-boolean #:boolean))

(cl:in-package #:class-options_tests)


(defun %retrieve (reader)
  (handler-case (funcall reader)
    (class-options:read-error ()
      nil)))

(defclass class-or-options-test (c2mop:standard-class)
  ())

(defmethod c2mop:validate-superclass ((class class-or-options-test) (superclass standard-class))
  (eq superclass (find-class 'c2mop:standard-object)))


(defclass class-test (class-options:class-mixin class-or-options-test)
  ())

(defclass class-direct-slot (c2mop:standard-direct-slot-definition)
  ((%class-that-was-passed :accessor class-that-was-passed)))

(defmethod c2mop:direct-slot-definition-class ((class class-test) &key &allow-other-keys)
  (find-class 'class-direct-slot))

(defmethod initialize-instance :before ((direct-slot class-direct-slot) &key)
  (setf (class-that-was-passed direct-slot)
        (%retrieve #'class-options:class)))


(defclass options-test (class-options:options-mixin class-or-options-test)
  ((%operation :initarg :operation
               :reader operation)))

(defclass options-direct-slot (c2mop:standard-direct-slot-definition)
  ((%options-that-were-passed :accessor options-that-were-passed)))

(defmethod c2mop:direct-slot-definition-class ((options options-test) &key &allow-other-keys)
  (find-class 'options-direct-slot))

(defmethod initialize-instance :before ((direct-slot options-direct-slot) &key)
  (setf (options-that-were-passed direct-slot)
        (%retrieve #'class-options:options)))

(defmethod class-options:canonicalize-options ((class options-test) &key)
  (list* :operation (%retrieve #'class-options:operation) (call-next-method)))


(defclass operation-test (class-options:operation-mixin class-or-options-test)
  ())

(defclass operation-direct-slot (c2mop:standard-direct-slot-definition)
  ((%operation-that-was-passed :accessor operation-that-was-passed)))

(defmethod c2mop:direct-slot-definition-class ((options operation-test) &key &allow-other-keys)
  (find-class 'operation-direct-slot))

(defmethod initialize-instance :before ((direct-slot operation-direct-slot) &key)
  (setf (operation-that-was-passed direct-slot)
        (%retrieve #'class-options:operation)))


(defclass class-options-test (class-test options-test)
  ())

(defclass class-options-direct-slot (class-direct-slot options-direct-slot)
  ())

(defmethod c2mop:direct-slot-definition-class ((class class-options-test) &key &allow-other-keys)
  (find-class 'class-options-direct-slot))


(defclass class-options-operation-test (class-test options-test operation-test)
  ())

(defclass class-options-operation-direct-slot (class-direct-slot options-direct-slot operation-direct-slot)
  ())

(defmethod c2mop:direct-slot-definition-class ((class class-options-operation-test) &key &allow-other-keys)
  (find-class 'class-options-operation-direct-slot))


(defclass my-class-test ()
  ((%my-slot))
  (:metaclass class-test))

(defclass my-options-test ()
  ((%my-slot))
  (:metaclass options-test))

(defclass my-operation-test ()
  ((%my-slot))
  (:metaclass operation-test))

(defclass my-class-options-test ()
  ((%my-slot))
  (:metaclass class-options-test))

(defclass my-class-options-operation-test ()
  ((%my-slot))
  (:metaclass class-options-operation-test))


(defun %check-operation (operation)
  (true (member operation '(initialize-instance reinitialize-instance))))


(define-test "main"
  (flet ((test-reader (reader required-mixin)
           (is equal (list reader required-mixin)
               (handler-case (funcall reader)
                 (class-options:read-error (condition)
                   (list (class-options:reader condition)
                         (class-options:required-mixin condition)))))))
    (test-reader 'class-options:class 'class-options:class-mixin)
    (test-reader 'class-options:options 'class-options:options-mixin)
    (test-reader 'class-options:operation 'class-options:operation-mixin))
  (flet ((run-class-tests (class-name)
           (let* ((class (find-class class-name))
                  (direct-slot (first (c2mop:class-direct-slots class))))
             (is eq t (boolean (eq (class-that-was-passed direct-slot)
                                   class)))))
         (run-options-tests (class-name)
           (let* ((class (find-class class-name))
                  (direct-slot (first (c2mop:class-direct-slots class))))
             (%check-operation (getf (options-that-were-passed direct-slot) :operation))
             (%check-operation (operation class))))
         (run-operation-tests (class-name)
           (let* ((class (find-class class-name))
                  (direct-slot (first (c2mop:class-direct-slots class))))
             (%check-operation (operation-that-was-passed direct-slot)))))
    (run-class-tests 'my-class-test)
    (run-options-tests 'my-options-test)
    (run-operation-tests 'my-operation-test)
    (run-class-tests 'my-class-options-test)
    (run-options-tests 'my-class-options-test)
    (run-class-tests 'my-class-options-operation-test)
    (run-options-tests 'my-class-options-operation-test)
    (run-operation-tests 'my-class-options-operation-test)))
