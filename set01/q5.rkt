;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")


;; DATA DEFINITIONS:
;; A ProcFlops is represented as a PosReal measured as
;;    floating point operations per second.
;; A NumYears is represented as a PosReal.


;; CONTRACT & PURPOSE STATEMENT.
;; years-to-test: ProcFlops -> NumYears
;; GIVEN: speed of a microprocessor in FLOPS,
;; RETURNS: number of 365-day years to test
;;    double precision addition.


;; EXAMPLES:
;; (years-to-test 1000000) = 10790283070806014188970529.154
;; (years-to-test 5000000000) = 2158056614161202837794.105


;; TESTS:
(begin-for-test
  (check-= (years-to-test 7000000000) 1541469010115144884138.647 1/1000
    "(years-to-test 7000000000) should be equal to
          1541469010115144884138.647")
  (check-= (years-to-test 10000000000) 1079028307080601418897.052 1/1000
    "(years-to-test 10000000000) should be equal to
          1079028307080601418897.052"))



;; stores number of double precision addition operations.
(define NUM-OF-OPERATIONS (expt 2 128))

;; stores total seconds in a year
(define SECONDS-IN-A-YEAR (* 24 60 60 365))


;; STRATEGY: Transcribe Formula.
(define (years-to-test flops)
  (/ (/ NUM-OF-OPERATIONS flops) SECONDS-IN-A-YEAR))