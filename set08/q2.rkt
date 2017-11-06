;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "08" "q2.rkt")

(provide tie
         defeated
         defeated?
         outranks
         outranked-by
         power-ranking)


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

;; A sequence of Strings (StringList)
;;           is represented as a list of a Strings.

;; CONSTRUCTOR TEMPLATES:
;; empty             -- the empty sequence
;; (cons s seq)
;;   WHERE:
;;    s    : String     is the first String in the sequence.
;;    seq  : StringList is the the rest of the sequence.

;; OBSERVER TEMPLATE:
;; stl-fn : StringList -> ??
#;
(define (stl-fn a)
  (cond
    [(empty? a) ...]
    [else (... (first a)
               (stl-fn (rest a)))]))


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

;; CONTRACT & PURPOSE STATEMENTS:
;; get-other-player : Competitor Tie -> String
;; GIVEN:   a competitor c and a tie
;; RETURNS: the name of the player other than c which has contested
;;            in a game that has resulted in a tie.

;; EXAMPLES:
;; (get-other-player "A" (tie "B" "A")) => "B"
;; (get-other-player "B" (tie "B" "D")) => "D"

;; STRATEGY: Cases on if c is which player in the tie result.
(define (get-other-player c outcome)
  (if (string=? c (tie-result-player1 outcome))
      (tie-result-player2 outcome)
      (tie-result-player1 outcome)))

;; CONTRACT & PURPOSE STATEMENTS:
;; add-to-list Competitor OutcomeList OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, 2 outcome lists
;;             red-list and og-list and a list of strings clist
;; WHERE:   c is the name of a competitor who has been outranked
;;            by some other competitor present in clist.
;;          red-list is a subset of og-list and 
;;          clist is the list of the names of competitors that
;;            have been checked for their outranks.
;; RETURNS: a list of the competitors outranked by the given
;;            competitor with repetitions in no order.

;; EXAMPLES:

;; STRATEGY: Combine Simpler Functions.
(define (add-to-list outranked olist ilist checked)
  (append (list outranked)
          (outranks-list outranked
                         olist
                         ilist
                         (list* outranked
                                checked))))

;; CONTRACT & PURPOSE STATEMENTS:
;; check-tie Competitor Tie OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, a tie t, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors outranked by the given
;;            competitor in the given tie along with those
;;            outranked by the other player in the given tie,
;;            with repetitions in no order.

;; EXAMPLES:
;; (check-tie "B" (tie "B" "C")
;;                (list (defeated "A" "B")
;;                      (tie "B" "C")
;;                      (tie "C" "D"))
;;                (list "A" "B"))             => (list "C" "B" "D" "C")
;; (check-tie "C" (tie "C" "D")
;;                (list (defeated "A" "B")
;;                      (defeated "B" "C")
;;                      (tie "C" "D"))
;;                (list "A" "B" "C"))         => (list "D" "C")

;; STRATEGY: Cases on if c is one of the players of the tie.
(define (check-tie c outcome ilist checked)
  (if (in-tie? c outcome)
      (if (member? (get-other-player c outcome)
                   checked)
          (list (get-other-player c outcome))
          (add-to-list (get-other-player c outcome)
                       ilist
                       ilist checked))
      empty))

;; CONTRACT & PURPOSE STATEMENTS:
;; check-defeat Competitor Defeat OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, a defeat d, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors outranked by the given
;;            competitor in the given defeat along with those
;;            outranked by the loser in the given defeat,
;;            with repetitions in no order.

;; EXAMPLES:
;; (check-defeat "A" (defeated "A" "B")
;;                (list (defeated "A" "B")
;;                      (tie "B" "C")
;;                      (tie "C" "D"))
;;                (list "A"))              => (list "B" "C" "B" "D" "C")
;; (check-defeat "C" (defeated "C" "D")
;;               (list (defeated "A" "B")
;;                     (defeated "B" "C")
;;                     (defeated "C" "D"))
;;               (list "A" "B" "C"))       => (list "D")

;; STRATEGY: Cases on if c is a winner.
(define (check-defeat c outcome ilist checked)
  (if (is-winner? c outcome)
      (if (member? (defeat-result-loser outcome)
                   checked)
          (list (defeat-result-loser outcome))
          (add-to-list (defeat-result-loser outcome)
                       ilist ilist checked))
      empty))

;; CONTRACT & PURPOSE STATEMENTS:
;; outrank-in-outcome : Competitor Outcome OutcomeList StringList
;;                                      -> StringList
;; GIVEN:   the name of a competitor c, an outcome o, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors outranked by the given
;;            competitor in the given outcome along with those
;;            outranked by the other competitor in the given outcome
;;            with repetitions in no order.
;; EXAMPLES:
;; (outrank-in-outcome "A" (defeated "A" "B")
;;                     (list (defeated "A" "B")
;;                          (tie "B" "C")
;;                          (tie "C" "D"))
;;                     (list "A"))            => (list "B" "C" "B" "D" "C")
;; (outrank-in-outcome "C" (tie "C" "D")
;;                     (list (defeated "A" "B")
;;                           (tie "B" "C")
;;                           (tie "C" "D"))
;;                     (list "A" "B" "C"))    => (list "D" "C")

;; STRATEGY: Use Observer Template for Outcome on outcome.
(define (outrank-in-outcome c outcome ilist checked)
  (cond
    [(defeat-result? outcome)
     (check-defeat c outcome ilist checked)]
    [(tie-result? outcome)
     (check-tie c outcome ilist checked)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; outranks-list : Competitor OutcomeList OutComeList StringList
;;                                 -> StringList
;; GIVEN:   the name of a competitor c, 2 outcome lists
;;             red-list and og-list and a list of strings clist
;; WHERE:   red-list is a subset of og-list and 
;;          clist is the list of the names of competitors that
;;            have been checked for their outranks.
;; RETURNS: a list of the competitors outranked by the given
;;            competitor with repetitions in no order.
;;                  
;; EXAMPLES:
;; (outranks-list "A" (list (defeated "A" "B")
;;                          (tie "C" "D"))
;;                (list (defeated "A" "B")
;;                      (tie "C" "D"))
;;                (list "A"))                  => (list "B")
;; (outranks-list "A" (list (defeated "A" "B")
;;                          (tie "B" "C")
;;                          (tie "C" "D"))
;;                (list (defeated "A" "B")
;;                      (tie "B" "C")
;;                      (tie "C" "D"))
;;                (list "A"))                  => (list "B" "C" "B" "D" "C")

;; STRATEGY: Use Observer Template for OutcomeList on olist.
(define (outranks-list c olist ilist checked)
  (cond
    [(empty? olist)
     empty]
    [else (append (outrank-in-outcome c (first olist) ilist checked)
                  (outranks-list c (rest olist) ilist checked))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; remove-duplicates : StringList -> StringList
;; GIVEN:   a StringList
;; RETURNS: the same StringList without any duplicate elements.

;; EXAMPLES:
;; (remove-duplicates (list "x" "x" "y")) => (list "x" "y")

;; STRATEGY: Use Observer Template for StringList on alist.
(define (remove-duplicates alist)
  (cond
    [(empty? alist)
     empty]
    [(member? (first alist) (rest alist))
     (remove-duplicates (rest alist))]
    [else
     (list* (first alist) (remove-duplicates (rest alist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; outranks : Competitor OutcomeList -> CompetitorList
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: a list of the competitors outranked by the given
;;            competitor, in alphabetical order.
;; NOTE: it is possible for a competitor to outrank itself.

;; EXAMPLES:
;; (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
;;                          => (list "B" "C")
;; (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
;;                          => (list "A" "B")
;; (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
;;                          => (list "B" "C")

;; STRATEGY: Combine Simpler Functions.
(define (outranks c olist)
  (sort (remove-duplicates (outranks-list c olist olist (list c)))
        string<?))

;; TESTS:
(begin-for-test
  (check-equal? (outranks "A" (list (defeated "A" "B")
                                    (tie "D" "E")
                                    (defeated "B" "C")
                                    (tie "D" "C")))
                (list "B" "C" "D" "E")
                "A outranks 4 competitors from B to E")
  (check-equal? (outranks "D" (list (defeated "A" "B")
                                    (defeated "B" "C")
                                    (defeated "C" "D")
                                    (defeated "D" "A")))
                (list "A" "B" "C" "D")
                "D outranks 4 competitors from A to D"))

;; CONTRACT & PURPOSE STATEMENTS:
;; add-to-list-by Competitor OutcomeList OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, 2 outcome lists
;;             red-list and og-list and a list of strings clist
;; WHERE:   c is the name of a competitor who outranks
;;            some other competitor present in clist.
;;          red-list is a subset of og-list and 
;;          clist is the list of the names of competitors that
;;            have been checked for their outranked by.
;; RETURNS: a list of the competitors that outrank the given
;;            competitor with repetitions in no order.

;; EXAMPLES:
;; (add-to-list-by "A" (list (defeated "A" "B")
;;                           (defeated "B" "C")
;;                           (tie "C" "D"))
;;                 (list (defeated "A" "B")
;;                       (defeated "B" "C")
;;                       (tie "C" "D"))
;;                 (list "B"))               => (list "A")
;; (add-to-list-by "C" (list (defeated "A" "B")
;;                           (defeated "B" "C")
;;                           (tie "C" "D"))
;;                 (list (defeated "A" "B")
;;                       (defeated "B" "C")
;;                       (tie "C" "D"))
;;                 (list "D"))               => (list "C" "B" "A" "D")

;; STRATEGY: Combine Simpler Functions.
(define (add-to-list-by outranks olist ilist checked)
  (append (list outranks)
          (outranked-by-list outranks
                             olist
                             ilist
                             (list* outranks
                                    checked))))

;; CONTRACT & PURPOSE STATEMENTS:
;; check-tie-by Competitor Tie OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, a tie t, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors that outrank the given
;;            competitor in the given tie along with those
;;            that outrank the other player in the given tie,
;;            with repetitions in no order.

;; EXAMPLES:
;; (check-tie-by "C" (tie "B" "C")
;;                (list (defeated "A" "B")
;;                      (tie "B" "C")
;;                      (tie "C" "D"))
;;                (list "C"))             => (list "B" "A" "C")
;; (check-tie-by "C" (tie "C" "D")
;;                (list (defeated "A" "B")
;;                      (defeated "B" "C")
;;                      (tie "C" "D"))
;;                (list "C"))         => (list "D" "C")

;; STRATEGY: Cases on if c is one of the players of the tie.
(define (check-tie-by c outcome ilist checked)
  (if (in-tie? c outcome)
      (if (member? (get-other-player c outcome)
                   checked)
          (list (get-other-player c outcome))
          (add-to-list-by (get-other-player c outcome)
                          ilist
                          ilist checked))
      empty))

;; CONTRACT & PURPOSE STATEMENTS:
;; check-defeat-by Competitor Defeat OutcomeList StringList
;;                                     -> StringList
;; GIVEN:   the name of a competitor c, a defeat d, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors that outrank the given
;;            competitor in the given defeat along with those
;;            that outrank the winner in the given defeat,
;;            with repetitions in no order.

;; EXAMPLES:
;; (check-defeat-by "A" (defeated "A" "B")
;;                (list (defeated "A" "B")
;;                      (tie "B" "C")
;;                      (tie "C" "D"))
;;                (list "A"))              => (list)
;; (check-defeat-by "D" (defeated "C" "D")
;;                   (list (defeated "A" "B")
;;                         (defeated "B" "C")
;;                         (defeated "C" "D"))
;;                   (list "D"))       => (list "C" "B" "A")

;; STRATEGY: Cases on if c is a loser.
(define (check-defeat-by c outcome ilist checked)
  (if (is-loser? c outcome)
      (if (member? (defeat-result-winner outcome)
                   checked)
          (list (defeat-result-winner outcome))
          (add-to-list-by (defeat-result-winner outcome)
                          ilist ilist checked))
      empty))

;; CONTRACT & PURPOSE STATEMENTS:
;; outranked-by-in-outcome : Competitor Outcome OutcomeList StringList
;;                                      -> StringList
;; GIVEN:   the name of a competitor c, an outcome o, outcome list og-list
;;              and a list of strings clist
;; RETURNS: the list of the competitors that outrank the given
;;            competitor in the given outcome along with those
;;            that  outranks the other competitor in the given outcome 
;;            with repetitions in no order.
;; EXAMPLES:
;; (outranked-by-in-outcome "A" (defeated "A" "B")
;;                          (list (defeated "A" "B")
;;                                (tie "B" "C")
;;                                (tie "C" "D"))
;;                          (list "A"))            => (list)
;; (outranked-by-in-outcome "B" (defeated "A" "B")
;;                           (list (defeated "A" "B")
;;                                 (defeated "C" "A")
;;                                 (tie "C" "D"))
;;                           (list "B"))    => (list "A" "C" "D" "C")

;; STRATEGY: Use Observer Template for Outcome on outcome.
(define (outranked-by-in-outcome c outcome ilist checked)
  (cond
    [(defeat-result? outcome)
     (check-defeat-by c outcome ilist checked)]
    [(tie-result? outcome)
     (check-tie-by c outcome ilist checked)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; outranked-by-list : Competitor OutcomeList OutComeList StringList
;;                                 -> StringList
;; GIVEN:   the name of a competitor c, 2 outcome lists
;;             red-list and og-list and a list of strings clist
;; WHERE:   red-list is a subset of og-list and 
;;          clist is the list of the names of competitors that
;;            have been checked for their outranked-by.
;; RETURNS: a list of the competitors that outranks the given
;;            competitor, with repetitions in no order.
;;                  
;; EXAMPLES:
;; (outranked-by-list "A" (list (defeated "A" "B")
;;                              (tie "C" "D"))
;;                    (list (defeated "A" "B")
;;                          (tie "C" "D"))
;;                    (list "A"))            => (list)
;; (outranked-by-list "C" (list (defeated "A" "B")
;;                              (tie "B" "C")
;;                              (tie "C" "D"))
;;                    (list (defeated "A" "B")
;;                          (tie "B" "C")
;;                          (tie "C" "D"))
;;                    (list "A"))            => (list "B" "A" "C" "D" "C")

;; STRATEGY: Use Observer Template for OutcomeList on ilist.
(define (outranked-by-list c olist ilist checked)
  (cond
    [(empty? olist)
     empty]
    [else (append (outranked-by-in-outcome c (first olist) ilist checked)
                  (outranked-by-list c (rest olist) ilist checked))]))

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

;; STRATEGY: Combine Simpler Functions.
(define (outranked-by c olist)
  (sort (remove-duplicates (outranked-by-list c olist olist (list c)))
        string<?))

;; TESTS:
(begin-for-test
  (check-equal? (outranked-by "E" (list (defeated "E" "A")
                                        (defeated "A" "B")
                                        (defeated "B" "D")
                                        (tie "D" "E")))
                (list "A" "B" "D" "E")
      "E outranks everyone but is outranked by D
         who is outranked by everyone in turn
      should return all the competitors from A to E"))

;; CONTRACT & PURPOSE STATEMENTS:
;; count-in-outcome : Competitor Outcome -> NonNegInt
;; GIVEN:   the name of a competitor and an outcome
;; RETURNS: 1 if the given competitor has won or tied in the
;;             given outcome otherwise 0.

;; EXAMPLES:
;; (count-in-outcome "A" (defeated "A" "D")) => 1
;; (count-in-outcome "A" (tie "S" "F"))      => 0
;; (count-in-outcome "C" (defeated "C" "D")) => 1

;; STRATEGY: Use Observer Template for Outcome on outcome.
(define (count-in-outcome c outcome)
  (cond
    [(defeat-result? outcome)
     (if (is-winner? c outcome)
         1
         0)]
    [(tie-result? outcome)
     (if (in-tie? c outcome)
         1
         0)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-victory-count : Competitor OutcomeList -> NonNegInt
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: the number of outcomes the given competitor has
;;             won or tied with another competitor.

;; EXAMPLES:
;; (get-victory-count "A" (list (defeated "A" "D")
;;                              (defeated "A" "E")
;;                              (defeated "C" "B")
;;                              (defeated "C" "F")
;;                              (tie "D" "B")
;;                              (defeated "F" "E"))) => 2
;; (get-victory-count "D" (list (defeated "A" "D")
;;                              (defeated "A" "E")
;;                              (defeated "C" "B")
;;                              (defeated "C" "F")
;;                              (tie "D" "B")
;;                              (defeated "F" "E"))) => 1

;; STRATEGY: Use Observer Template for OutcomeList on olist.
(define (get-victory-count c olist)
  (cond
    [(empty? olist) 0]
    [else (+ (count-in-outcome c (first olist))
             (get-victory-count c (rest olist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; total-count-in-outcome : Competitor Outcome -> NonNegInt
;; GIVEN:   the name of a competitor and an outcome
;; RETURNS: 1 if the given competitor has participated in the
;;             given outcome otherwise 0.

;; EXAMPLES:
;; (total-count-in-outcome "A" (defeated "A" "D")) => 1
;; (total-count-in-outcome "A" (tie "S" "A"))      => 1
;; (total-count-in-outcome "A" (defeated "C" "D")) => 0

;; STRATEGY: Use Observer Template for Outcome on outcome.
(define (total-count-in-outcome c outcome)
  (cond
    [(defeat-result? outcome)
     (if (or (is-winner? c outcome)
             (is-loser? c outcome))
         1
         0)]
    [(tie-result? outcome)
     (if (in-tie? c outcome)
         1
         0)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-total-count : Competitor OutcomeList -> NonNegInt
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: the number of outcomes the given competitor has
;;             participated.

;; EXAMPLES:
;; (get-total-count "A" (list (defeated "A" "D")
;;                             (defeated "A" "E")
;;                             (defeated "C" "B")
;;                             (defeated "C" "F")
;;                             (tie "D" "B")
;;                             (defeated "F" "E"))) => 2
;; (get-total-count "A" (list (defeated "A" "D")
;;                             (defeated "C" "B")
;;                             (defeated "C" "F")
;;                             (tie "D" "B")
;;                             (defeated "F" "E"))) => 1

;; STRATEGY: Use Observer Template for OutcomeList on olist.
(define (get-total-count c olist)
  (cond
    [(empty? olist) 0]
    [else (+ (total-count-in-outcome c (first olist))
             (get-total-count c (rest olist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-non-losing-percent : Competitor OutcomeList -> NonNegInt
;; GIVEN:   the name of a competitor and a list of outcomes
;; RETURNS: the non-losing percentage of that competitor.

;; EXAMPLES:
;; (get-non-losing-percent "A" (list (defeated "A" "D")
;;                                    (defeated "A" "E")
;;                                    (defeated "C" "B")
;;                                    (defeated "C" "F")
;;                                    (tie "D" "B")
;;                                    (defeated "F" "E"))) => 100
;; (get-non-losing-percent "E" (list (defeated "A" "D")
;;                                    (defeated "A" "E")
;;                                    (defeated "C" "B")
;;                                    (defeated "C" "F")
;;                                    (tie "D" "B")
;;                                    (defeated "F" "E"))) => 0

;; STRATEGY: Transcribe Formula.
(define (get-non-losing-percent c olist)
  (* (/ (get-victory-count c olist)
        (get-total-count c olist))
     100))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-competitor-in-outcome : Outcome -> StringList
;; GIVEN:   an outcome
;; RETURNS: the list of the names of the competitors
;;            involved in that outcome.

;; EXAMPLES:
;; (get-competitor-in-outcome (defeated "A" "B")) => (list "A" "B")
;; (get-competitor-in-outcome (tie "D" "R"))      => (list "D" "R")

;; STRATEGY: Use Observer Template for Outcome on outcome.
(define (get-competitor-in-outcome outcome)
  (cond
    [(defeat-result? outcome)
     (list (defeat-result-winner outcome)
           (defeat-result-loser outcome))]
    [(tie-result? outcome)
     (list (tie-result-player1 outcome)
           (tie-result-player2 outcome))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-all-competitors : OutcomeList -> StringList
;; GIVEN:   a list of outcomes
;; RETURNS: the list of the names of all competitors that participate
;;            in at least one of the outcomes in the given list
;;            without any repetitions.

;; EXAMPLES:
;; (get-all-competitors (list (defeated "A" "D")
;;                             (defeated "A" "E")
;;                             (defeated "C" "B")
;;                             (defeated "C" "F")
;;                             (tie "D" "B")
;;                             (defeated "F" "E")))
;;                               => (list "A" "B" "C" "D" "F" "E")

;; STRATEGY: Use observer Template for OutcomeList on olist.
(define (get-all-competitors olist)
  (cond
    [(empty? olist) empty]
    [else (remove-duplicates (append (get-competitor-in-outcome (first olist))
                                     (get-all-competitors (rest olist))))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; power-rank-sort : Competitor Competitor OutcomeList -> Boolean
;; GIVEN:   the names of two competitors c1 and c2, list of
;;             outcomes olist
;; RETURNS: true iff c1 has a higher power ranking than c2.

;; EXAMPLES:
;; (power-rank-sort "A" "F" (list (defeated "A" "D")
;;                                 (defeated "A" "E")
;;                                 (defeated "C" "B")
;;                                 (defeated "C" "F")
;;                                 (tie "D" "B")
;;                                 (defeated "F" "E")))  => #true
;; (power-rank-sort "A" "F" (list (defeated "A" "D")
;;                                 (defeated "A" "E")
;;                                 (defeated "C" "B")
;;                                 (defeated "C" "F")
;;                                 (tie "D" "B")
;;                                 (defeated "F" "E")))  => #false

;; STRATEGY: Cases on the number of competitors outranked, outranked by,
;;              and non-losing percentage for c1 and c2
(define (power-rank-sort c1 c2 olist)
  (cond
    [(< (length (outranked-by c1 olist))
        (length (outranked-by c2 olist)))
     #true]
    [(> (length (outranked-by c1 olist))
        (length (outranked-by c2 olist)))
     #false]
    [(> (length (outranks c1 olist))
        (length (outranks c2 olist)))
     #true]
    [(< (length (outranks c1 olist))
        (length (outranks c2 olist)))
     #false]
    [(> (get-non-losing-percent c1 olist)
        (get-non-losing-percent c2 olist))
     #true]
    [(< (get-non-losing-percent c1 olist)
        (get-non-losing-percent c2 olist))
     #false]
    [else
     (string<? c1 c2)]))

;; TESTS:
(begin-for-test
  (check-equal? (power-rank-sort "Z" "W" (list (tie "Z" "X")
                                               (defeated "Z" "W")))
                #true
    "X   ; outranked by 2, outranks 3, 100%, X string<? Z
     Z   ; outranked by 2, outranks 3, 100%
     W   ; outranked by 2, outranks 0"))

;; power-ranking : OutcomeList -> CompetitorList
;; GIVEN:   a list of outcomes
;; RETURNS: a list of all competitors mentioned by one or more
;;           of the outcomes, without repetitions, with competitor A
;;           coming before competitor B in the list if and only if
;;           the power-ranking of A is higher than the power ranking
;;           of B.

;; EXAMPLE:
;; (power-ranking
;;  (list (defeated "A" "D")
;;        (defeated "A" "E")
;;        (defeated "C" "B")
;;        (defeated "C" "F")
;;        (tie "D" "B")
;;        (defeated "F" "E")))
;;             => (list "C"   ; outranked by 0, outranks 4
;;                      "A"   ; outranked by 0, outranks 3
;;                      "F"   ; outranked by 1
;;                      "E"   ; outranked by 3
;;                      "B"   ; outranked by 4, outranks 12, 50%
;;                      "D")  ; outranked by 4, outranks 12, 50%

;; STRATEGY: Use HOF sort on the result obtained from
;;              get-all-competitors.
(define (power-ranking olist)
  (sort (get-all-competitors olist)
        ;; Competitor Competitor -> Boolean
        ;; GIVEN:   two competitors c1 and c2.
        ;; RETURNS: true iff c1 has a higher power ranking than c2.
        (lambda (m n)
          (power-rank-sort m n olist))))

;; TESTS:
(begin-for-test
  (check-equal? (power-ranking (list (defeated "Z" "A")
                                     (defeated "A" "B")
                                     (defeated "B" "Z")
                                     (tie "Z" "C")
                                     (tie "C" "D")
                                     (defeated "E" "Z")
                                     (defeated "E" "D")))
                (list "E" "C" "A" "B" "D" "Z")
    "E   ; outranked by 0, outranks 5
     C   ; outranked by 6, outranks 5, 100%
     A   ; outranked by 6, outranks 5, 50%, A string<? B
     B   ; outranked by 6, outranks 5, 50%, B string<? D
     D   ; outranked by 6, outranks 5, 50%, D string<? Z
     Z   ; outranked by 6, outranks 5, 50%")
  (check-equal? (power-ranking (list (tie "Z" "X")
                                     (defeated "Z" "W")))
                (list "X" "Z" "W")
    "X   ; outranked by 2, outranks 3, 100%, X string<? Z
     Z   ; outranked by 2, outranks 3, 100%
     W   ; outranked by 2, outranks 0"))