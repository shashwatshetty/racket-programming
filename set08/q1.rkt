;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "08" "q1.rkt")

(provide tie
         defeated
         defeated?
         outranks
         outranked-by)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; A Competitor is represented as a String (any string will do).

;; An Outcome is one of
;;     -- a Tie
;;     -- a Defeat

;; OBSERVER TEMPLATE:
;; outcome-fn : Outcome -> ??
#;
(define (outcome-fn o)
  (cond ((tie? o) ...)
        ((defeat? o) ...)))

;; A Tie is represented as a struct
;; (make-tie-result player1 player2)
;; with the following fields:
;; INTERP:
;;     player1 : Competitor   is the name of one of the competitors
;;                                of the tie result.
;;     player2 : Competitor   is the name of one of the competitors
;;                                of the tie result.

;; IMPLEMENTATION:
(define-struct tie-result (player1 player2))

;; CONSTRUCTOR TEMPLATE:
;; (make-tie-result Competitor Competitor)

;; OBSERVER TEMPLATE:
;; tie-result-fn: Tie -> ?
;; (define (tie-result-fn t)
;;    (... (tie-result-player1 t)
;;         (tie-result-player2 t))

;; A Defeat is represented as a struct
;; (make-defeat-result winner loser)
;; with the following fields:
;; INTERP:
;;     winner : Competitor   is the name of the competitor
;;                                that won the game.
;;     loser  : Competitor   is the name of the competitor
;;                                that lost the game.

;; IMPLEMENTATION:
(define-struct defeat-result (winner loser))

;; CONSTRUCTOR TEMPLATE:
;; (make-defeat-result Competitor Competitor)

;; OBSERVER TEMPLATE:
;; defeat-result-fn: Tie -> ?
;; (define (defeat-result-fn d)
;;    (... (defeat-result-winner d)
;;         (defeat-result-loser d))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;



;; tie : Competitor Competitor -> Tie
;; GIVEN:   the names of two competitors
;; RETURNS: an indication that the two competitors have
;;            engaged in a contest, and the outcome was a tie

;; EXAMPLE:

(define (tie comp1 comp2)
  (make-tie-result comp1 comp2))

;; defeated : Competitor Competitor -> Defeat
;; GIVEN:   the names of two competitors
;; RETURNS: an indication that the two competitors have
;;           engaged in a contest, with the first competitor
;;           defeating the second

;; EXAMPLE:

(define (defeated win lose)
  (make-defeat-result win lose))

;; defeated? : Competitor Competitor OutcomeList -> Boolean
;; GIVEN:   the names of two competitors and a list of outcomes
;; RETURNS: true if and only if one or more of the outcomes indicates
;;             the first competitor has defeated or tied the second

;; EXAMPLES:
;; (defeated? "A" "B" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => true
;; (defeated? "A" "C" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => false
;; (defeated? "B" "A" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => false
;; (defeated? "B" "C" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => true
;; (defeated? "C" "B" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => true

(define (defeated? c1 c2 olist)
  (empty))

;; outranks : Competitor OutcomeList -> CompetitorList
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: a list of the competitors outranked by the given
;;            competitor, in alphabetical order
;; NOTE: it is possible for a competitor to outrank itself

;; EXAMPLES:
;; (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
;;                          => (list "B" "C")
;; (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
;;                          => (list "A" "B")
;; (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
;;                          => (list "B" "C")

(define (outranks c olist)
  (empty))

;; outranked-by : Competitor OutcomeList -> CompetitorList
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: a list of the competitors that outrank the given
;;            competitor, in alphabetical order
;; NOTE: it is possible for a competitor to outrank itself

;; EXAMPLES:
;; (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => (list)
;; (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
;;                                            => (list "A" "B")
;; (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
;;                                            => (list "A" "B" "C")
(define (outranked-by c olist)
  (empty))