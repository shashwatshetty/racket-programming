;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

;; DATA DEFINITIONS:
;; A ProcFlops is represented as a PosInt measured as
;;    floating point operations per second.
;; A NumOps is represented as PosInt.


;; CONTRACT & PURPOSE STATEMENT.
;; flopy: ProcFlops -> NumOps
;; GIVEN: speed of a microprocessor in FLOPS,
;; RETURNS: number of operations performed in one 365-day year.


;; EXAMPLES:
;; (flopy 1) = 31536000
;; (flopy 3) = 94608000


;; TESTS:
(begin-for-test
  (check-equal? (flopy 10) 315360000
      "(flopy 10) should be equal to 315360000")
  (check-equal? (flopy 5) 157680000
      "(flopy 5) should be equal to 157680000"))


;; stores total seconds in a year
(define SECONDS-IN-A-YEAR (* 24 60 60 365))


;; STRATEGY: Transcribe Formula.
(define (flopy flops)
  (* flops SECONDS-IN-A-YEAR))