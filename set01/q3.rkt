;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")


;; DATA DEFINITIONS:
;; A KelvinTemp is represented as a Real.
;; A FahrenTemp is represented as a Real.


;; CONTRACT & PURPOSE STATEMENTS:
;; kelvin-to-fahrenheit: KelvinTemp -> FahrenTemp
;; GIVEN: any temperature measured in kelvin,
;; RETURNS: the equivalent temperature in fahrenheit.


;; EXAMPLES:
;; (kelvin-to-farhenheit 273.15) = 32
;; (kelvin-to-farhenheit 0) = -459.67


;; TESTS:
(begin-for-test
  (check-equal? (kelvin-to-farhenheit 300) 80.33
       "(kelvin-to-farhenheit 300) should be equal to 80.33")
  (check-equal? (kelvin-to-farhenheit -1) -461.47
       "(kelvin-to-farhenheit -1) should be equal to -461.47")
  (check-equal? (kelvin-to-farhenheit 0.5) -458.77
       "(kelvin-to-farhenheit -1) should be equal to -461.47"))


;; STRATEGY: Transcribe Formula for Kelvin to Farhenheit.
(define (kelvin-to-farhenheit k)
  (+ (* 9/5 k) (* -273.15 9/5) 32))