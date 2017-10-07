;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "04" "q1.rkt")

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

;; A SortedIntList is an IntList in which the numbers 
;; are sorted in ascending order.

;; A sorted sequence of integers (SortedIntList) is represented
;; as a list of integers. 

;; CONSTRUCTOR TEMPLATES:
;; empty                      -- the empty sequence
;; (cons n seq)
;;   WHERE:
;;    n   : Integer           is the first integer in the sequence
;;    seq : SortedIntList     is the the rest of the sequence
;;   AND:
;;    n is less than any number in seq.

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
(define (inner-product list1 list2)
  (cond
    [(and (empty? list1)
          (empty? list2))
     0]
    [else
     (+ (* (first list1)
           (first list2))
        (inner-product (rest list1)
                       (rest list2)))]))

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
;; insert : Integer SortedIntList -> SortedIntList
;; GIVEN:   An integer and a sorted sequence
;; RETURNS: A new SortedIntList just like the original, but with the
;;             new integer inserted.

;; EXAMPLES:
;; (insert 3 empty)           => (list 3)
;; (insert 3 (list 5 6))      => (list 3 5 6)
;; (insert 3 (list -1 1 5 6)) => (list -1 1 3 5 6)

;; TESTS:
(begin-for-test
  (check-equal? (insert 5 (list))
                (list 5)
    "(insert 5 (list)) should return: (list 5)")
  (check-equal? (insert 5 (list 1 7 9))
                (list 1 5 7 9)
    "(insert 5 (list 1 7 9)) should return: (list 1 5 7 9)"))

;; STRATEGY: Use Observer Template for SortedIntList
;;               on seq.
(define (insert n seq)
  (cond
    [(empty? seq) (cons n empty)]
    [(< n (first seq)) (cons n seq)]
    [else (cons (first seq)
                (insert n (rest seq)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; sort-list : IntList -> SortedIntList
;; GIVEN:   An integer sequence
;; RETURNS: The same sequence, only sorted by <= .

;; TESTS:
(begin-for-test
  (check-equal? (sort-list empty)
                empty
    "(sort-list empty) should return: empty")
  (check-equal? (sort-list (list 3))
                (list 3)
    "(sort-list (list 3)) should return: (list 3)")
  (check-equal? (sort-list (list 2 1 4))
                (list 1 2 4)
    "(sort-list (list 2 1 4))
            should return: (list 1 2 4)"))

;; EXAMPLES:
;; (sort-list empty) = empty
;; (sort-list (list 3)) = (list 3)
;; (sort-list (list 2 1 4)) = (list 1 2 4)
;; (sort-list (list 2 1 4 2)) = (list 1 2 2 4)

;; STRATEGY: Use observer template for IntList
(define (sort-list ints)
  (cond
    [(empty? ints) empty]
    [else (insert (first ints)
                  (sort-list (rest ints)))]))

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
(define (permutation-of? list1 list2)
  (cond
    [(and (empty? list1)
          (empty? list2))
     #true]
    [(not (equal-length? list1 list2))
     #false]
    [(not (= (first (sort list1 <))
             (first (sort list2 <))))
     #false]
    [else (permutation-of? (rest (sort list1 <))
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

;; TESTS:
(begin-for-test
  (check-equal? (shortlex-less-than? empty empty) #false
     "(shortlex-less-than? empty empty) should return: #false")
  (check-equal? (shortlex-less-than? (list 5) (list 5)) #false
     "(shortlex-less-than? (list 5) (list 5))
            should return: #false")
  (check-equal? (shortlex-less-than? (list 4 5 9) (list 4 5 9 12))
                #true
     "(shortlex-less-than? (list 4 5 9) (list 4 5 9 12))
            should return: #true")
  (check-equal? (shortlex-less-than? (list 4 5 8 9) (list 4 5 9 12))
                #true
     "(shortlex-less-than? (list 4 5 8 9) (list 4 5 9 12))
            should return: #true"))

;; EXAMPLES:
;; (shortlex-less-than? (list) (list))         => false
;; (shortlex-less-than? (list) (list 3))       => true
;; (shortlex-less-than? (list 3) (list))       => false
;; (shortlex-less-than? (list 3) (list 3))     => false
;; (shortlex-less-than? (list 3) (list 1 2))   => true
;; (shortlex-less-than? (list 3 0) (list 1 2)) => false
;; (shortlex-less-than? (list 0 3) (list 1 2)) => true

;; STRATEGY: Use Observer Template for IntList
;;              on list1 and list2.
(define (shortlex-less-than? list1 list2)
  (cond
    [(and (empty? list1)
          (empty? list2))
     #false]
    [(< (length list1) (length list2))
     #true]
    [(< (first list1) (first list2))
     #true]
    [else (shortlex-less-than? (rest list1)
                               (rest list2))]))


;; STRATEGY: Use Observer Template for IntList
;;              on list1 and list2.
(define (permutations lst)
  (+ 1 2))