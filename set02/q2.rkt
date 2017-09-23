;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "02" "q2.rkt")

(provide
        initial-state
        next-state
        is-red?
        is-green?)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A CTColor is represented by one of the following Strings:
;;   -- "red"
;;   -- "green"
;;   -- "blank"
;; INTERP: self-evident

;; OBSERVER TEMPLATE:
;; ctcolor-fn : CTColor -> ?
#;
(define (ctcolor-fn)
   (cond
      [(= s "red") ...]
      [(= s "green") ...]
      [(= s "blank") ...]))

;; A Time is represented as PosInt measured in seconds. 

;; A ChineseTrafficSignal is represented as a struct
;; (make-ctsignal current-color time-given time-left)
;;  with the following fields:
;; INTERP:
;;    current-color : CTColor is the color of thesignal 
;;                     at current time.
;;    time-given    : Time is the time alloted for the
;;                      signal to be red or green/blank.
;;    time-left     : Time is the time left for the
;;                      signal to remain red or green/blank.

;; IMPLEMENTATION:
(define-struct ctsignal (current-color time-given time-left))

;; Above statement generates following functions:
;; make-ctsignal : CTColor Time Time -> ChineseTrafficSignal
;; GIVEN:   aCTColor c, and two periods of Time t1
;;            and t2,
;; RETURNS: a ChineseTrafficSignal with current color c
;;            alloted to be in that color for t1 seconds
;;            with time left for the color change as t2 seconds.

;; ctsignal-current-color : ChineseTrafficSignal -> CTColor
;; GIVEN:   a ChineseTrafficSignal,
;; RETURNS: its color at some time.

;; ctsignal-time-given : ChineseTrafficSignal -> Time
;; GIVEN:   a ChineseTrafficSignal,
;; RETURNS: the time allotted for signal to be
;;            red or green/blank.

;; ctsignal-time-left : ChineseTrafficSignal -> Time
;; GIVEN:   a ChineseTrafficSignal,
;; RETURNS: the time left for signal to be
;;            red or green/blank.

;; CONSTRUCTOR TEMPLATE:
;; (make-ctsignal CTColor Time Time)

;; OBSERVER TEMPLATE:
;; ctsignal-fn : ChineseTrafficSignal -> ?
;; (define (ctsignal-fn signal)
;;    (... (ctsignal-current-color signal)
;;         (ctsignal-time-given signal)
;;         (ctsignal-time-left signal))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONTRACT & PURPOSE STATEMENT:
;; initial-state : PosInt -> ChineseTrafficSignal
;; GIVEN:   an integer n greater than 3
;; RETURNS: a representation of a Chinese traffic signal
;;            at the beginning of its red state, which will last
;;            for n seconds.

;; EXAMPLE:
;; (is-red? (initial-state 4)) => true

;; TESTS:
(begin-for-test
  (check-equal? (initial-state 5) (make-ctsignal "red" 5 4)
      "(initial-state 5) should return (make-ctsignal red 5 4)"))

;; STRATEGY: Use Constructor template for ChineseTrafficSignal.
(define (initial-state num)
  (make-ctsignal "red" num (sub1 num)))



;; CONTRACT & PURPOSE STATEMENT:
;; is-red? : ChineseTrafficSignal -> Boolean
;; GIVEN:   a representation of a traffic signal in some state,
;; RETURNS: true if and only if the signal is red.

;; EXAMPLES:
;;     (is-red? (next-state (initial-state 4)))  => true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state (initial-state 4)))))      => true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state (initial-state 4))))))    => false
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state
;;          (next-state (initial-state 4)))))))  => false

;; TESTS:
(begin-for-test
  (check-equal? (is-red? (next-state (make-ctsignal "red" 4 3)))
                #true
    "(is-red? (next-state (make-ctsignal red 4 3)))
         should return: true")
  (check-equal? (is-red? (next-state (make-ctsignal "red" 4 0)))
                #false
    "(is-red? (next-state (make-ctsignal red 4 0)))
         should return: false")
  (check-equal? (is-red? (next-state (make-ctsignal "blank" 4 0)))
                #true
    "(is-red? (next-state (make-ctsignal blank 4 0)))
         should return: true"))

;; Strategy: Use Obsever Template for ChineseTrafficSignal
;;             on current-color.
(define (is-red? signal)
  (string=? (ctsignal-current-color signal)
                 "red"))



;; CONTRACT & PURPOSE STATEMENT:
;; is-green? : ChineseTrafficSignal -> Boolean
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: true if and only if the signal is green.

;; EXAMPLES:
;; (is-green?
;;  (next-state
;;   (next-state
;;    (next-state
;;     (next-state (initial-state 4))))))    =>  true
;; (is-green?
;;  (next-state
;;   (next-state
;;    (next-state
;;     (next-state
;;      (next-state (initial-state 4)))))))  =>  false

;; TESTS:
(begin-for-test
  (check-equal? (is-green? (next-state (make-ctsignal "green" 5 4)))
                #true
    "(is-green? (next-state (make-ctsignal green 5 4)))
         should return: true")
  (check-equal? (is-green? (next-state (make-ctsignal "red" 5 0)))
                #true
    "(is-green? (next-state (make-ctsignal red 5 0)))
         should return: true")
  (check-equal? (is-green? (next-state (make-ctsignal "green" 5 1)))
                #false
    "(is-green? (next-state (make-ctsignal green 5 0)))
         should return: false")
  (check-equal? (is-green? (initial-state 5))
                #false
    "(is-green? (initial-state 5)
         should return: false"))

;; Strategy: Use Obsever Template for ChineseTrafficSignal
;;             on current-color.
(define (is-green? signal)
  (string=? (ctsignal-current-color signal)
                 "green"))



;; CONTRACT & PURPOSE STATEMENT:
;; is-blank? : ChineseTrafficSignal -> Boolean
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: true if and only if the signal is blank.

;; EXAMPLES:
;; (is-blank?
;;  (next-state
;;   (next-state
;;    (next-state
;;     (next-state (initial-state 4))))))    =>  false
;; (is-blank?
;;  (next-state
;;   (next-state
;;    (next-state
;;     (next-state
;;      (next-state (initial-state 4)))))))  =>  true

;; TESTS:
(begin-for-test
  (check-equal? (is-blank? (next-state (make-ctsignal "green" 5 3)))
                #true
    "(is-blank? (next-state (make-ctsignal green 5 3)))
         should return: true")
  (check-equal? (is-blank? (next-state (make-ctsignal "red" 5 1)))
                #false
    "(is-blank? (next-state (make-ctsignal red 5 1)))
         should return: false")
  (check-equal? (is-blank? (initial-state 5))
                #false
    "(is-blank? (initial-state 5)
         should return: false"))

;; Strategy: Use Obsever Template for ChineseTrafficSignal
;;             on current-color.
(define (is-blank? signal)
  (string=? (ctsignal-current-color signal)
                 "blank"))



;; CONTRACT & PURPOSE STATEMENT:
;; is-end-of-time? : ChineseTrafficSignal -> Boolean
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: true if and only if there is only one second left
;;            in any state of the signal.

;; EXAMPLES:
;; (is-end-of-time (initial-state 7)) => false
;; (is-end-of-time (make-ctsignal "red" 5 0)) => true
;; (is-end-of-time (make-ctsignal "blank" 5 0)) => true

;; TESTS:
(begin-for-test
  (check-equal? (is-end-of-time? (initial-state 9)) #false
     "(is-end-of-time (initial-state 9))
           should return: false")
  (check-equal? (is-end-of-time? (make-ctsignal "green" 7 4)) #false
     "(is-end-of-time (make-ctsignal green 7 4))
           should return: false")
  (check-equal? (is-end-of-time? (make-ctsignal "blank" 7 0)) #true
     "(is-end-of-time (make-ctsignal green 7 0))
           should return: true"))

;; STRATEGY: Use Obsever Template for ChineseTrafficSignal
;;             on time-left.
(define (is-end-of-time? signal)
  (= (ctsignal-time-left signal) 0))



; CONTRACT & PURPOSE STATEMENT:
;; next-current-color : ChineseTrafficSignal -> CTColor
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: the color of the signal one second later.

;;EXAMPLES:
;; (next-current-color (make-ctsignal "red" 4 3)) => "red"
;; (next-current-color (make-ctsignal "green" 4 3)) => "blank"
;; (next-current-color (make-ctsignal "blank" 4 0)) => "red"
;; (next-current-color (make-ctsignal "red" 4 0)) => "green"
;; (next-current-color (make-ctsignal "blank" 4 2)) => "green"

;; TESTS:
(begin-for-test
  (check-equal? (next-current-color
                 (next-state (make-ctsignal "red" 5 0)))
                "green"
     "(next-state (make-ctsignal red 5 0))
           should return: green")
  (check-equal? (next-current-color
                 (next-state (initial-state 6)))
                "red"
     "(next-current-color (next-state (initial-state 6)))
           should return: red")
  (check-equal? (next-current-color
                 (next-state (make-ctsignal "blank" 5 2)))
                "blank"
     "(next-current-color (next-state (make-ctsignal blank 5 2)))
           should return: blank")
  (check-equal? (next-current-color
                 (next-state (make-ctsignal "blank" 5 0)))
                "red"
     "(next-current-color (next-state (make-ctsignal blank 5 0)))
           should return: red"))

;; STRATEGY: Cases on ctsignal-color wrt ctsignal-time-left.
(define (next-current-color signal)
  (cond
    [(is-red? signal)
        (if (is-end-of-time? signal)
              "green"
              "red")]
    [(is-blank? signal)
        (if (is-end-of-time? signal)
              "red"
              "green")]
    [(is-green? signal)
        (if (<= (ctsignal-time-left signal) 3)
              "blank"
              "green")]))



; CONTRACT & PURPOSE STATEMENT:
;; next-time-left : ChineseTrafficSignal -> Time
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: the time left one second later.

;;EXAMPLES:

;; TESTS:
(begin-for-test
  (check-equal? (next-time-left (initial-state 5)) 3
     "(next-time-left (initial-state 5))
          should return: 3")
  (check-equal? (next-time-left (make-ctsignal "red" 5 0)) 4
     "(next-time-left (make-ctsignal red 5 0))
          should return: 4")
  (check-equal? (next-time-left (next-state (make-ctsignal "green" 5 1))) 4
     "(next-time-left (next-state (make-ctsignal green 5 1)))
          should return: 4"))

;; STRATEGY: Combine Simple Functions,
;;            Use Observer Template for ChineseTrafficSignal
;;                            on ctsignal-time-given
;;                           and ctsignal-time-left.
(define (next-time-left signal)
  (if (is-end-of-time? signal)
      (sub1 (ctsignal-time-given signal))
      (sub1 (ctsignal-time-left signal))))



; CONTRACT & PURPOSE STATEMENT:
;; next-state : ChineseTrafficSignal -> ChineseTrafficSignal
;; GIVEN:   a representation of a traffic signal in some state
;; RETURNS: the state that traffic signal should have one
;;            second later.

;;EXAMPLES:

;; TESTS:
(begin-for-test
  (check-equal? (next-state (initial-state 4))
                (make-ctsignal "red" 4 2)
      "(next-state (initial-state 4))
             should return: (make-ctsignal red 4 2)")
  (check-equal? (next-state
                 (next-state
                  (next-state
                   (next-state (initial-state 4)))))
                (make-ctsignal "green" 4 3)
      "(next-state
        (next-state
         (next-state
          (next-state (initial-state 4)))))
             should return: (make-ctsignal green 4 3))")
  (check-equal? (next-state
                 (next-state
                  (next-state
                   (next-state (make-ctsignal "green" 4 3)))))
                (make-ctsignal "red" 4 3)
      "(next-state
        (next-state
         (next-state
          (next-state (make-ctsignal green 4 3)))))
             should return: (make-ctsignal red 4 3))")
  (check-equal? (next-state
                 (next-state
                  (next-state
                   (next-state (make-ctsignal "red" 5 1)))))
                (make-ctsignal "blank" 5 2)
      "(next-state
        (next-state
         (next-state
          (next-state (make-ctsignal green 5 1)))))
             should return: (make-ctsignal blank 5 2))"))

;; STRATEGY: Combine Simple Functions,
;;            Use Constructor Template for ChineseTrafficSignal,
;;            Use Observer Template for ChineseTrafficSignal
;;                            on ctsignal-time-given.
(define (next-state signal)
  (make-ctsignal
      (next-current-color signal)
      (ctsignal-time-given signal)
      (next-time-left signal)))