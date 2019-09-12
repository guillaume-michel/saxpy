(in-package :saxpy)

(defknown (%saxpy) ((unsigned-byte 32) ;; index
                    (simd-pack single-float) ;; scalar replicated in sse register
                    system-area-pointer ;; x vector
                    system-area-pointer) ;; y vector
  (values)
  (any)
  :overwrite-fndb-silently t)

(define-vop (%saxpy)
  (:translate %saxpy)
  (:policy :fast-safe)
  (:args (index :scs (unsigned-reg))
         (alpha :scs (single-sse-reg))
         (vectorx :scs (sap-reg))
         (vectory :scs (sap-reg)))
  (:arg-types unsigned-num
              simd-pack-single
              system-area-pointer
              system-area-pointer)
  (:results)
  (:temporary (:sc single-sse-reg) tmp)
  (:generator
   4
   (inst movaps
         tmp
         (make-ea :dword :base vectorx :disp 0 :index index))
   (inst mulps
         tmp
         alpha)
   (inst addps
         tmp
         (make-ea :dword :base vectory :disp 0 :index index))
   (inst movaps
         (make-ea :dword :base vectory :disp 0 :index index)
         tmp)))

(defun %saxpy (i alpha x y)
  (declare (type fixnum i)
           (type (simd-pack single-float) alpha)
           (type system-area-pointer x y)
           (optimize (speed 3) (debug 0) (safety 0)))
  (%saxpy i alpha x y))

;;-------------------------------------------------------
(deftype f4 ()
  '(simd-pack single-float))

;;-------------------------------------------------------
(defknown (%load-f4) ((unsigned-byte 64) ;; index
                      system-area-pointer) ;; array sap
    (simd-pack single-float)
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(define-vop (%load-f4)
  (:translate %load-f4)
  (:policy :fast-safe)
  (:args (index :scs (unsigned-reg))
         (vector :scs (sap-reg)))
  (:arg-types unsigned-num
              system-area-pointer)
  (:results (r :scs (single-sse-reg)))
  (:result-types simd-pack-single)
  (:generator
   1
   (inst movaps
         r
         (make-ea :dword :base vector :disp 0 :index index))))

(defun %load-f4 (i arr)
  (declare (type fixnum i)
           (type system-area-pointer arr)
           (optimize (speed 3) (debug 0) (safety 0)))
  (%load-f4 i arr))

;;-------------------------------------------------------
(defknown (%store-f4) ((unsigned-byte 64) ;; index
                       system-area-pointer ;; array sap
                       (simd-pack single-float)) ;; register to save
    (values)
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(define-vop (%store-f4)
  (:translate %store-f4)
  (:policy :fast-safe)
  (:args (index :scs (unsigned-reg))
         (vector :scs (sap-reg))
         (reg :scs (single-sse-reg)))
  (:arg-types unsigned-num
              system-area-pointer
              simd-pack-single)
  (:generator
   1
   (inst movaps
         (make-ea :dword :base vector :disp 0 :index index)
         reg)))

(defun %store-f4 (i arr reg)
  (declare (type fixnum i)
           (type system-area-pointer arr)
           (type (simd-pack single-float) reg)
           (optimize (speed 3) (debug 0) (safety 0)))
  (%store-f4 i arr reg))

;;-------------------------------------------------------
(defknown (f4+ f4*) ((simd-pack single-float) (simd-pack single-float))
    (simd-pack single-float)
    (movable flushable always-translatable)
  :overwrite-fndb-silently t)

(define-vop (f4+)
  (:translate f4+)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r) (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (single-sse-reg)))
  (:result-types simd-pack-single)
  (:generator 1
    (cond ((location= r y)
           (inst addps y x))
          (t
           (move r x)
           (inst addps r y)))))

(define-vop (f4*)
  (:translate f4*)
  (:policy :fast-safe)
  (:args (x :scs (single-sse-reg) :target r) (y :scs (single-sse-reg)))
  (:arg-types simd-pack-single simd-pack-single)
  (:results (r :scs (single-sse-reg)))
  (:result-types simd-pack-single)
  (:generator 1
    (cond ((location= r y)
           (inst mulps y x))
          (t
           (move r x)
           (inst mulps r y)))))

(macrolet ((define-stub (name)
             `(defun ,name (x y)
                (,name x y))))
  (define-stub f4+)
  (define-stub f4*))
