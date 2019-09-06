(defpackage #:saxpy
  (:nicknames :saxpy)
  (:use #:cl #:sb-ext :sb-c)
  (:import-from :sb-sys
                :system-area-pointer)
  (:import-from :sb-assem
                :inst)
  (:import-from :sb-vm
                :unsigned-reg
                :sap-reg
                :unsigned-num
                :simd-pack-single
                :single-sse-reg)
  (:import-from :sb-x86-64-asm
                :movaps
                :make-ea
                :mulps
                :addps)
  (:import-from :sb-c
                :move)
  (:export
   #:saxpy
   ))
