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

;; A sequence of Outcomes (OutcomeList)
;;           is represented as a list of a Outcomes.

;; CONSTRUCTOR TEMPLATES:
;; empty                           -- the empty sequence
;; (cons o oseq)
;;   WHERE:
;;    o    : Outcome     is the first Outcome
;;                               in the sequence.
;;    oseq : OutcomeList is the the rest of the sequence.

;; OBSERVER TEMPLATE:
;; ol-fn : OutcomeList -> ??
#;
(define (ol-fn a)
  (cond
    [(empty? a) ...]
    [else (... (first a)
               (ol-fn (rest a)))]))

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


;; CONTRACT & PURPOSE STATEMENTS:
;; tie : Competitor Competitor -> Tie
;; GIVEN:   the names of two competitors
;; RETURNS: an indication that the two competitors have
;;            engaged in a contest, and the outcome was a tie

;; EXAMPLE:
;; (tie "A" "B") => (make-tie-result "A" "B")

;; TESTS:
(begin-for-test
  (check-equal? (tie "C" "E")
                (make-tie-result "C" "E")
     "(tie C E) should return:
             (make-tie-result C E)"))

(define (tie comp1 comp2)
  (make-tie-result comp1 comp2))

;; CONTRACT & PURPOSE STATEMENTS:
;; defeated : Competitor Competitor -> Defeat
;; GIVEN:   the names of two competitors
;; RETURNS: an indication that the two competitors have
;;           engaged in a contest, with the first competitor
;;           defeating the second

;; EXAMPLE:
;; (defeated "A" "B") => (make-defeat-result "A" "B")

;; TESTS:
(begin-for-test
  (check-equal? (defeated "C" "E")
                (make-defeat-result "C" "E")
     "(defeated C E) should return:
             (make-defeat-result C E)"))

(define (defeated win lose)
  (make-defeat-result win lose))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-winner? : Competitor Defeat -> Boolean
;; GIVEN:   the name of a competitor and a defeat result
;; RETUNRS: true iff the competitor is a winner in the given defeat result.

;; EXAMPLES:
;; (is-winner? "A" (defeat "A" "B")  => #true
;; (is-winner? "B" (defeat "A" "B")  => #false

;; STRATEGY: Use observer Template for Defeat on def-res.
(define (is-winner? comp def-res)
  (string=? comp (defeat-result-winner def-res)))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-loser? : Competitor Defeat -> Boolean
;; GIVEN:   the name of a competitor and a defeat result
;; RETUNRS: true iff the competitor is a loser in the given defeat result.

;; EXAMPLES:
;; (is-loser? "A" (defeat "A" "B")  => #false
;; (is-loser? "B" (defeat "A" "B")  => #true

;; STRATEGY: Use observer Template for Defeat on def-res.
(define (is-loser? comp def-res)
  (string=? comp (defeat-result-loser def-res)))

;; CONTRACT & PURPOSE STATEMENTS:
;; in-tie? : Competitor Tie -> Boolean
;; GIVEN:   the name of a competitor and a tie result
;; RETURNS: true iff the competitor is part of the tie result.

;; EXAMPLES:

;;STRATEGY: Use Observer Template for Tie on tie-res.
(define (in-tie? c tie-res)
  (or (string=? c (tie-result-player1 tie-res))
      (string=? c (tie-result-player2 tie-res))))

;; CONTRACT & PURPOSE STATEMENTS:
;; check-outcome : Competitor Competitor Outcome -> Boolean
;; GIVEN:   the names of two competitors and an outcome
;; RETURNS: true if and only if the given outcome indicates
;;             the first competitor has defeated or tied the second.

;; EXAMPLES:


;; STRATEGY: Use Observer Template for Outcome.
(define (check-outcome c1 c2 outcome)
  (cond
    [(defeat-result? outcome)
     (and (is-winner? c1 outcome)
          (is-loser? c2 outcome))]
    [(tie-result? outcome)
     (are-tied? c1 c2 outcome)]))


;; CONTRACT & PURPOSE STATEMENTS:
;; are-tied? : Competitor Competitor Tie -> Boolean
;; GIVEN:   the names of two competitors and a tie result
;; RETURNS: true iff both the competitors have engaged in a contest 
;;              which has resulted in a tie.

;; EXAMPLES:

;; STRATEGY: Combine Simpler Functions.
(define (are-tied? c1 c2 tie-res)
  (and (in-tie? c1 tie-res)
       (in-tie? c2 tie-res)))

;; CONTRACT & PURPOSE STATEMENTS:
;; defeated? : Competitor Competitor OutcomeList -> Boolean
;; GIVEN:   the names of two competitors and a list of outcomes
;; RETURNS: true if and only if one or more of the outcomes indicates
;;             the first competitor has defeated or tied the second
;; HALTING MEASURE: length of OutComeList.

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

;; TESTS:
(begin-for-test
  (check-equal? (defeated? "A" "D" (list (defeated "A" "B")
                                         (defeated "B" "D")
                                         (defeated "A" "D")
                                         (tie "A" "C")))
                #true
       "Example with outcome list having an outcome of A
           defeating D should return: true")
  (check-equal? (defeated? "A" "D" (list (defeated "A" "B")
                                         (tie "B" "D")
                                         (defeated "A" "E")
                                         (tie "A" "C")))
                #false
       "Example with outcome list having an outcome of A
           defeating B, and B tieing with D
                should return: false")
  (check-equal? (defeated? "D" "E" (list (defeated "A" "B")
                                         (tie "B" "D")
                                         (defeated "A" "E")
                                         (tie "A" "C")))
                #false
       "Example with outcome list having no outcome of D
           defeating E should return: false"))

;; STRATEGY: Use HOF ormap on olist.
(define (defeated? c1 c2 olist)
  (ormap
   ;; Outcome -> Boolean
   ;; GIVEN:   an Outcome.
   ;; RETURNS: true if and only if the given outcome indicates
   ;;           the first competitor has defeated or tied the second.
   (lambda (o)
     (check-outcome c1 c2 o))
   olist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (outrank-in-outcome c outcome ilist checked)
  (cond
    [(defeat-result? outcome)
     (if (is-winner? c outcome)
         (append (list (defeat-result-loser outcome))
                 (outranks-list (defeat-result-loser outcome)
                               ilist ilist (list* (defeat-result-loser outcome)
                                                  checked)))
         empty)]
    [(tie-result? outcome)
     (if (in-tie? c outcome)
         (append (get-other-player c outcome)
                 ))]))

(define (outranks-list c olist ilist checked)
  (cond
    [(empty? olist)
     empty]
    [else (append (outrank-in-outcome c (first olist) ilist checked)
                  (outranks-list c (rest olist) ilist checked))]))

;; CONTRACT & PURPOSE STATEMENTS:
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

;; CONTRACT & PURPOSE STATEMENTS:
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