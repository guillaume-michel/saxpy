(defsystem "saxpy-tests"
  :description "saxpy unit tests"
  :author "Guillaume MICHEL"
  :mailto "contact@orilla.fr"
  :license "MIT license (see COPYING)"
  :depends-on ("saxpy"
               "fiveam")
  :perform (test-op (o s) (uiop:symbol-call :saxpy-tests :run-tests))
  :components ((:module "t"
                :serial t
                :components ((:file "package")
                             (:file "tests")))))
