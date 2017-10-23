;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "06" "q1.rkt")

(provide inner-product
         permutation-of?
         shortlex-less-than?
         permutations)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; A sequence of integers (IntList) is represented as a list of integers.

;; CONSTRUCTOR TEMPLATES:
;; empty                 -- the empty sequence
;; (cons n iseq)
;;   WHERE:
;;    n :    Integer     is the first integer in the sequence
;;    iseq : IntList     is the the rest of the sequence

;; OBSERVER TEMPLATE:
;; il-fn : IntList -> ??
#;
(define (il-fn s)
  (cond
    [(empty? s) ...]
    [else (... (first s)
               (il-fn (rest s)))]))

;; A sequence of a sequence of integers (IntListList) is represented
;;                    as a list of a list integers.

;; CONSTRUCTOR TEMPLATES:
;; empty                      -- the empty sequence
;; (cons n seq)
;;   WHERE:
;;    n   : IntList       is the first sequence of integers in the sequence
;;    seq : IntListList   is the the rest of the sequence

;; OBSERVER TEMPLATE:
;; Same as for IntList.


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; inner-product : RealList RealList -> Real
;; GIVEN: two lists of real numbers
;; WHERE: the two lists have the same length
;; RETURNS: the inner product of those lists.

;; EXAMPLES:
;; (inner-product (list 2.5) (list 3.0))          =>  7.5
;; (inner-product (list 1 2 3 4) (list 5 6 7 8))  =>  70
;; (inner-product (list) (list))                  =>  0

;; TESTS:
(begin-for-test
  (check-equal? (inner-product empty empty)
                0
                "(inner-product (list) (list))
         should return: 0")
  (check-equal? (inner-product (list 5 5 5 5) (list 1 2 3 4))
                50
                "(inner-product (list 5 5 5 5) (list 1 2 3 4))
         should return: 50"))

;; STRATEGY: Use Observer Template for IntList
;;              on list1 and list2.
;(define (inner-product list1 list2)
;  (cond
;    [(and (empty? list1)
;          (empty? list2))
;     0]
;    [else
;     (+ (* (first list1)
;           (first list2))
;        (inner-product (rest list1)
;                       (rest list2)))]))

;; STRATEGY: Use HOF foldr and map on list1 and list2.
(define (inner-product list1 list2)
  (foldr + 0 (map * list1 list2)))

;; CONTRACT & PURPOSE STATEMENTS:
;; equal-length? : IntList IntList -> Boolean
;; GIVEN:   two lists of integers
;; RETURNS: true iff both the lists are of equal length.

;; EXAMPLES:
;; (equal-length? (list) (list 1)            => #false
;; (equal-length? (list 1 8 5) (list 7 2 6)) => #true

;; TESTS:
(begin-for-test
  (check-equal? (equal-length? empty (list 5)) #false
                "(equal-length? (equal-length? empty (list 5))
            should return: false")
  (check-equal? (equal-length? empty empty) #true
                "(equal-length? empty empty) should return: true")
  (check-equal? (equal-length? (list 1 4) (list 5 9 7))
                #false
                "(equal-length? (list 1 4) (list 5 9 7))
           should return: false"))

;; STRATEGY: Compare length of the two lists.
(define (equal-length? list1 list2)
  (= (length list1)
             (length list2)))

;; CONTRACT & PURPOSE STATEMENTS:
;; permutation-of? : IntList IntList -> Boolean
;; GIVEN:   two lists of integers
;; WHERE:   neither list contains duplicate elements
;; RETURNS: true if and only if one of the lists
;;            is a permutation of the other.

;; EXAMPLES:
;; (permutation-of? (list 1 2 3) (list 1 2 3)) => true
;; (permutation-of? (list 3 1 2) (list 1 2 3)) => true
;; (permutation-of? (list 3 1 2) (list 1 2 4)) => false
;; (permutation-of? (list 1 2 3) (list 1 2))   => false
;; (permutation-of? (list) (list))             => true

;; TESTS:
(begin-for-test
  (check-equal? (permutation-of? (list 4 5 9) (list 4 5 9))
                #true
                "(permutation-of? (list 4 5 9) (list 4 5 9))
            should return: true")
  (check-equal? (permutation-of? empty empty)
                #true
                "(permutation-of? empty empty) should return: true")
  (check-equal? (permutation-of? (list 4 5 9) (list 4 5 6))
                #false
                "(permutation-of? (list 4 5 9) (list 4 5 6))
            should return: false")
  (check-equal? (permutation-of? (list 4 5 9) (list 4 5))
                #false
                "(permutation-of? (list 4 5 9) (list 4 5))
            should return: false"))

;; STRATEGY: Use Observer Template for IntList
;;              on list1 and list2.
;(define (permutation-of? list1 list2)
;  (cond
;    [(and (empty? list1)
;          (empty? list2))
;     #true]
;    [(not (equal-length? list1 list2))
;     #false]
;    [(not (= (first (sort list1 <))
;             (first (sort list2 <))))
;     #false]
;    [else (permutation-of? (rest (sort list1 <))
;                           (rest (sort list2 <)))]))

;; STRATEGY: Use HOF andmap on list1 and list2.
(define (permutation-of? list1 list2)
  (cond
    [(and (empty? list1)
          (empty? list2))
     #true]
    [(not (equal-length? list1 list2))
     #false]
    [else (andmap =
                  (rest (sort list1 <))
                  (rest (sort list2 <)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; shortlex-less-than? : IntList IntList -> Boolean
;; GIVEN:   two lists of integers
;; RETURNS: true if and only either
;;            the first list is shorter than the second
;;          or both are non-empty, have the same length, and either
;;            the first element of the first list is less than
;;            the first element of the second list
;;          or the first elements are equal, and the rest of
;;            the first list is less than the rest of the
;;            second list according to shortlex-less-than?

;; EXAMPLES:
;; (shortlex-less-than? (list) (list))         => false
;; (shortlex-less-than? (list) (list 3))       => true
;; (shortlex-less-than? (list 3) (list))       => false
;; (shortlex-less-than? (list 3) (list 3))     => false
;; (shortlex-less-than? (list 3) (list 1 2))   => true
;; (shortlex-less-than? (list 3 0) (list 1 2)) => false
;; (shortlex-less-than? (list 0 3) (list 1 2)) => true

;; TESTS:
(begin-for-test
  (check-equal? (shortlex-less-than? empty empty) #false
     "(shortlex-less-than? empty empty) should return: #false")
  (check-equal? (shortlex-less-than? (list 5) (list 4)) #false
     "(shortlex-less-than? (list 5) (list 4))
            should return: #false")
  (check-equal? (shortlex-less-than? (list 4 5 9) (list 4 5 9 12))
                #true
     "(shortlex-less-than? (list 4 5 9) (list 4 5 9 12))
            should return: #true")
  (check-equal? (shortlex-less-than? (list 4 5 8 9) (list 4 5))
                #false
     "(shortlex-less-than? (list 4 5 8 9) (list 4 5))
            should return: #false")
  (check-equal? (shortlex-less-than? (list 4 5 8 9) (list 4 5 9 11))
                #true
     "(shortlex-less-than? (list 4 5 8 9) (list 4 5 9 11))
            should return: #true"))

;; STRATEGY: Cases on the states of the given lists.
(define (shortlex-less-than? list1 list2)
  (cond
    [(and (empty? list1)
          (empty? list2))
     #false]
    [(< (length list1) (length list2))
     #true]
    [(> (length list1) (length list2))
     #false]
    [(< (first list1) (first list2))
     #true]
    [(> (first list1) (first list2))
     #false]
    [(= (first list1) (first list2))
     (shortlex-less-than? (rest list1)
                          (rest list2))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; new-start : IntList PosInt -> IntList
;; GIVEN:   a list of integers and the index
;; RETURNS: a list with the integer at given index at
;;            the start of the list.
;(define (new-start og-list indx)
;  (cons (list-ref og-list indx)
;        (remove (list-ref og-list indx) og-list)))

;; CONTRACT & PURPOSE STATEMENTS:
;; swap : IntList Int Int -> IntList
;; GIVEN:   a list of integers and two elements in that list
;; RETURNS: a list with the two elements swapped with each other.
;(define (swap ilist e1 e2)
;  (cond
;    [(empty? ilist)
;     empty]
;    [(= (first ilist) e1)
;     (list* e2 (swap (rest ilist) e1 e2))]
;    [(= (first ilist) e2)
;     (list* e1 (swap (rest ilist) e1 e2))]
;    [else
;     (list* (first ilist) (swap (rest ilist) e1 e2))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; permute : IntList IntList Int Int -> IntListList
;; GIVEN:   two lists of integers and two index references
;; RETURNS: a list with the permutations of the first list
;;             with the start element changed.
;(define (permute og-list new-list ref1 ref2)
;  (cond
;    [(= (list-ref og-list (- (length og-list) 1))
;        (list-ref new-list ref1))
;     (list* new-list (permute-last-two og-list
;                                       (new-start og-list ref1)
;                                       (- ref1 1) (- ref2 1)))]
;    [else
;     (list* new-list (permute-last-two og-list
;                                       (new-start og-list ref1)
;                                       ref1 (- ref2 1)))]))


;; (permute-last-two (list 1 2) (list 1 2) 0 1)
;; (permute-last-two (list 1 2 3) (list 1 2 3) 1 2)

;; CONTRACT & PURPOSE STATEMENTS:
;; permute-last-two : IntList IntList Int Int -> IntListList
;; GIVEN:   two lists of integers and two index references
;; RETURNS: a list with the permutations of the first list
;;              with only the last two digits considered.

;; STRATEY: 
;(define (permute-last-two og-list new-list ref1 ref2)
;  (cond
;    [(< ref1 0)
;     empty]
;    [(= (length new-list) ref2)
;     (permute og-list new-list ref1 ref2)]
;    [else
;     (list* new-list (permute-last-two og-list
;                                       (swap og-list
;                                             (list-ref new-list ref2)
;                                             (list-ref new-list (- ref2 1)))
;                                       ref1 (+ 1 ref2)))]))

;; STRATEGY: Use HOF foldr on lst.
(define (permute-last-two lst)
  (foldr append
         empty
         (map
          ;; Integer -> IntListList
          ;; GIVEN:   an Integer.
          ;; RETURNS: list of IntList of all permutations with
          ;;            given integer at the beginning of the all lists.
          (lambda (i)
                (map
                    ;; IntList -> IntList
                    ;; GIVEN:   an integer list.
                    ;; RETURNS: the same IntList with i as the integer
                    ;;           at the beginning of the all list.
                 (lambda (j)
                       (list* i j))
                     (permutations (remove i lst))))
              lst)))

;; CONTRACT & PURPOSE STATEMENTS:
;; permutations : IntList IntList Int Int -> IntListList
;; GIVEN:   two lists of integers and two index references
;; RETURNS: a list with the permutations of the first list

;; EXAMPLES:
;; (permutations (list))       => (list (list))
;; (permutations (list 9))     => (list (list 9))
;; (permutations (list 3 1 2)) => (list (list 1 2 3)
;;                                      (list 1 3 2)
;;                                      (list 2 1 3)
;;                                      (list 2 3 1)
;;                                      (list 3 1 2)
;;                                      (list 3 2 1))

;; TESTS:
(begin-for-test
  (check-equal? (permutations (list))
                (list (list))
     "(permutations (list))
         should return: (list (list))")
  (check-equal? (permutations (list 9))
                (list (list 9))
     "(permutations (list 9))
         should return: (list (list 9))")
  (check-equal? (permutations (list 1 2 3))
                (list (list 1 2 3)
                      (list 1 3 2)
                      (list 2 1 3)
                      (list 2 3 1)
                      (list 3 1 2)
                      (list 3 2 1))
     "(permutations (permutations (list 1 2 3))
         should return: (list (list 1 2 3)
                              (list 1 3 2)
                              (list 2 1 3)
                              (list 3 2 1))"))

;; STRATEGY: Cases on length of list.
;(define (permutations lst)
;  (cond
;    [(or (empty? lst)
;         (= (length lst) 1))
;     (list lst)]
;    [else
;     (permute-last-two lst lst
;                       (- (length lst) 2)
;                       (- (length lst) 1))]))

;; STRATEGY: Combine Simpler Functions.
(define (permutations lst)
  (cond
    [(<= (length lst) 1)
     (list lst)]
    [else (sort (permute-last-two lst) shortlex-less-than?)]))