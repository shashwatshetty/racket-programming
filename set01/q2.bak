;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

;; DATA DEFINITIONS:
;; A FurlongLength is represented as a PosReal.
;; A BarleycornLength is represented as a PosReal.


;; CONTRACT & PURPOSE STATEMENT:
;; furlons-to-barleycorns: FurlongLength -> BarleycornLength
;; GIVEN: a length measured in furlongs,
;; RETURNS: the equivalent length in barleycorns.

;; EXAMPLES:
;; (furlongs-to-bareycorns 10)= 237600
;; (furlongs-to-barleycorns 1.5) = 35640

;; TESTS:
(begin-for-test
  (check-equal? (furlongs-to-barleycorns 2) 47520
     "(furlongs-to-barleycorns 2) should be equal to 47520")
  (check-equal? (furlongs-to-barleycorns 0.1) 2376
     "(furlongs-to-barleycorns 0.1) should be equal to 2376"))

;; STRATEGY: Transcribe Formula for Furlongs to Barleycorns
(define (furlongs-to-barleycorns f)
  (* 23760 f))