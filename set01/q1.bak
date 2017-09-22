;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

;; DATA DEFINITIONS:
;; A Side is represented as PosReal measured in meters.
;; A Height is represented as PosReal measured in meters.
;; A Volume is represented as PosReal measured in cubic meters.


;; CONTRACT & PURPOSE STATEMENT:
;; pyramid-volume: Side Height -> Volume
;; GIVEN: side of the square bottom x and height h of a pyramid.
;; RETURNS: volume of the pyramid in cubic meters.


;; EXAMPLES:
;; (pyramid-volume 4 30) = 160
;; (pyramid-volume 6 10) = 120


;; TESTS:
(begin-for-test
  (check-equal? (pyramid-volume 5 10) (+ 83 1/3))
      "(pyramid-volume 5 10) should be equal to 83.33")
  (check-equal? (pyramid-volume 9 5) 135
      "(pyramid-volume 9 5) should be equal to 135"))

;; STRATEGY: Transcribe Formula for Volume of Pyramid
(define (pyramid-volume x h)
  (* (/ 1 3) (sqr x) h))