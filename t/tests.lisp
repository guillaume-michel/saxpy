;;;; (asdf:test-system 'saxpy)

(in-package :saxpy-tests)

(fiveam:def-suite all-tests
    :description "saxpy test suite.")

(fiveam:in-suite all-tests)

(fiveam:test dummy
  (fiveam:is (equalp t t)))

(defun run-tests ()
  (fiveam:run! 'all-tests))
