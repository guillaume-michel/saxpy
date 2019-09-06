(in-package #:saxpy)

(declaim (inline simple-array-vector))
(defun simple-array-vector (array)
  (declare (simple-array array))
  (if (sb-kernel:array-header-p array)
      (sb-kernel:%array-data array)
      array))
