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
