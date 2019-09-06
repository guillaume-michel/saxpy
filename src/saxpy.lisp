(in-package :saxpy)

(declaim (inline replicate-float))
(defun replicate-float (x)
  (%make-simd-pack-single x x x x))

(defun saxpy (a x y)
  "BLAS SAXPY function: Y = a*X + Y with single-float elements"
  (declare (optimize (speed 3)
                     (debug 0)
                     (safety 0)
                     (compilation-speed 0)))
  (let ((data-x (simple-array-vector x))
        (data-y (simple-array-vector y)))
    (declare (type (simple-array single-float (*)) data-x data-y))
    (sb-sys:with-pinned-objects (a data-x data-y)
      (let ((sse-a (replicate-float a))
            (sap-x (sb-sys:vector-sap data-x))
            (sap-y (sb-sys:vector-sap data-y))
            (n (array-dimension data-x 0)))
        (declare (type fixnum n)
                 (type system-area-pointer sap-x sap-y))
        (loop for i below n by 4 do
             (%saxpy (* 4 i) sse-a sap-x sap-y))))))

(defun test (N M)
  (let ((a 1.0f0)
        (x (make-array N :element-type 'single-float :initial-element 1.0f0))
        (y (make-array N :element-type 'single-float :initial-element 2.0f0)))
    (time (dotimes (j M)
            (saxpy a x y)))))
