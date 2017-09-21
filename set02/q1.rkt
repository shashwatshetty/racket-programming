;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

;; DATA DEFINITIONS:

;; A Lexer is represented as a struct
;; (make-lexer token input)
;;  with the following fields:
;; INTERP:
;;    token : String (any string will do)
;;                is the token string of the lexer.
;;    input : String (any string will do)
;;                is the input string of the lexer.

;; IMPLEMENTATION:
(define-struct lexer (token input))


;; Above statement generates following functions:
;; make-lexer : String String -> Lexer
;; GIVEN:   two Strings s1 and s2,
;; RETURNS: a Lexer whose token string is s1
;;            and whose input string is s2.

;; lexer-token : Lexer -> String
;; GIVEN:   a Lexer,
;; RETURNS: its token string.

;; lexer-input : Lexer -> String
;; GIVEN:   a Lexer,
;; RETURNS: its input string.

;; CONSTRUCTOR TEMPLATE:
;; (make-lexer String String)

;; OBSERVOR TEMPLATE:
;; lexer-fn: Lexer -> ?
;; (define (lexer-fn lex)
;;    (... (lexer-token lex)
;;         (lexer-input lex))

;; EXAMPLES:


;; CONTRACT & PURPOSE STATEMENT:

;; initial-lexer : String -> Lexer
;; GIVEN:   an arbitrary string
;; RETURNS: a Lexer lex whose token string is empty
;;            and whose input string is the given string.

;; EXAMPLES:
;; (initial-lexer "hello") => (make-lexer "hello" "")
;; (initial-lexer "")      => (make-lexer "" "")

;; TESTS:

;; STRATEGY: Use Constructor template for Lexer.
(define (initial-lexer str)
    (make-lexer str ""))


;; CONTRACT & PURPOSE STATEMENT:

;; is-non-empty? : String -> Boolean
;; GIVEN:   a String
;; RETURNS: false if String has no charaters;
;;            otherwise returns true.

;; EXAMPLES:
;; (is-non-empty? "abc")  => true
;; (is-non-empty? "")     => false

;; TESTS:

;; STRATEGY: Check if String length is greater than 0.
(define (is-non-empty? str)
  (if (> (string-length str) 0)
      #true
      #false))


;; CONTRACT & PURPOSE STATEMENT:

;; is-letter? : Character -> Boolean
;; GIVEN:   a Character
;; RETURNS: true if it is an English alphabet;
;;            otherwise returns false.

;; EXAMPLES:
;; (is-letter? #\a)     => true
;; (is-letter? #\1)     => false
;; (is-letter? #\space) => false

;; TESTS:

;; STRATEGY: Check if the character is within the range
;;             of lower and upper case alphabets.
(define (is-letter? char)
    (if (or (and (char>=? char #\a)
                 (char<=? char #\z))
            (and (char>=? char #\A)
                 (char<=? char #\Z)))
        #true
        #false))

;; is-digit? : Character -> Boolean
;; GIVEN:   a Character
;; RETURNS: true if it is a digit;
;;            otherwise returns false.

;; EXAMPLES:
;; (is-letter? #\1)     => true
;; (is-letter? #\a)     => false
;; (is-letter? #\space) => false

;; TESTS:

;; STRATEGY: Check if the character is within the range
;;             of digits from 0 to 9.
(define (is-digit? char)
    (if (and (char>=? char #\0)
             (char<=? char #\9))
        #true
        #false))

;; lexer-stuck? : Lexer -> Boolean
;; GIVEN:   a lexer
;; RETURNS: false iff given Lexer's input string
;;            is non-empty and begins with an English letter
;;            or digit; otherwise returns true.

;; EXAMPLES:
;; (lexer-stuck? (make-lexer "abc" "1234"))  => false
;; (lexer-stuck? (make-lexer "abc" "+1234")) => true
;; (lexer-stuck? (make-lexer "abc" ""))      => true

;; STRATEGY: Combine Simple Functions
(define (lexer-stuck? lex)
   (if (is-non-empty? (lexer-input lex))
       (if (or (is-letter? (string-ref (lexer-input lex) 0))
               (is-digit?  (string-ref (lexer-input lex) 0)))
           #false
           #true)
       #true))






