(defsystem "saxpy"
  :description "saxpy playground"
  :version "0.0.1"
  :author "Guillaume MICHEL"
  :mailto "contact@orilla.fr"
  :homepage "http://orilla.fr"
  :license "MIT license (see COPYING)"
  ;; :depends-on ("alexandria"
  ;;              "nibbles")
  :in-order-to ((test-op (test-op "saxpy-tests")))
  :components ((:static-file "COPYING")
               (:static-file "README.md")
               (:module "src"
                        :serial t
                        :components ((:file "package")
                                     (:file "array-utils")
                                     (:file "vops")
                                     (:file "saxpy")))))
