;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "02" "q1.rkt")

(provide
        make-lexer
        lexer-token
        lexer-input
        initial-lexer
        lexer-stuck?
        lexer-shift
        lexer-reset)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; OBSERVER TEMPLATE:
;; lexer-fn: Lexer -> ?
;; (define (lexer-fn lex)
;;    (... (lexer-token lex)
;;         (lexer-input lex))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONTRACT & PURPOSE STATEMENT:
;; initial-lexer : String -> Lexer
;; GIVEN:   an arbitrary string
;; RETURNS: a Lexer lex whose token string is empty
;;            and whose input string is the given string.

;; EXAMPLES:
;; (initial-lexer "hello") => (make-lexer "hello" "")
;; (initial-lexer "")      => (make-lexer "" "")

;; TESTS:
(begin-for-test
  (check-equal? (initial-lexer "world") (make-lexer "world" "")
      "(initial-lexer world)
           should return: (make-lexer world Empty-String)")
  (check-equal? (lexer-shift (make-lexer "" "")) (make-lexer "" "")
      "(initial-lexer Empty-String)
           should return: (make-lexer Empty-String Empty-String)"))

;; STRATEGY: Use Constructor template for Lexer.
(define (initial-lexer str)
    (make-lexer str ""))



;; CONTRACT & PURPOSE STATEMENT:
;; is-non-empty? : String -> Boolean
;; GIVEN:   a String
;; RETURNS: false if String has no characters;
;;            otherwise returns true.

;; EXAMPLES:
;; (is-non-empty? "abc")  => true
;; (is-non-empty? "")     => false

;; TESTS:
(begin-for-test
  (check-equal? (is-non-empty? "hello") #true
      "(is-non-empty? hello)
           should return: true")
  (check-equal? (is-non-empty? "") #false
      "(is-non-empty? Empty-String)
           should return: false"))

;; STRATEGY: Check if String length is greater than 0.
(define (is-non-empty? str)
  (> (string-length str) 0))



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
(begin-for-test
  (check-equal? (is-letter? #\a) #true
      "(is-letter? a)
           should return: true")
  (check-equal? (is-letter? #\C) #true
      "(is-letter? C)
           should return: true")
  (check-equal? (is-letter? #\2) #false
      "(is-digit? 2))
           should return: false"))


;; STRATEGY: Check if the character is within the range
;;             of lower and upper case alphabets.
(define (is-letter? char)
    (or (and (char>=? char #\a)
             (char<=? char #\z))
        (and (char>=? char #\A)
             (char<=? char #\Z))))



;; CONTRACT & PURPOSE STATEMENT:
;; is-digit? : Character -> Boolean
;; GIVEN:   a Character
;; RETURNS: true if it is a digit;
;;            otherwise returns false.

;; EXAMPLES:
;; (is-digit? #\1)     => true
;; (is-digit? #\a)     => false
;; (is-digit? #\space) => false

;; TESTS:
(begin-for-test
  (check-equal? (is-digit? #\0) #true
      "(is-digit? 0))
           should return: true")
  (check-equal? (is-digit? #\r) #false
      "(is-digit? r))
           should return: false"))

;; STRATEGY: Check if the character is within the range
;;             of digits from 0 to 9.
(define (is-digit? char)
    (and (char>=? char #\0)
         (char<=? char #\9)))



;; CONTRACT & PURPOSE STATEMENT:
;; lexer-stuck? : Lexer -> Boolean
;; GIVEN:   a lexer
;; RETURNS: false iff given Lexer's input string
;;            is non-empty and begins with an English letter
;;            or digit; otherwise returns true.

;; EXAMPLES:
;; (lexer-stuck? (make-lexer "abc" "1234"))  => false
;; (lexer-stuck? (make-lexer "abc" "+1234")) => true
;; (lexer-stuck? (make-lexer "abc" ""))      => true

;; TESTS:
(begin-for-test
  (check-equal? (lexer-stuck? (make-lexer "xyz" "1221")) #false
      "(lexer-stuck? (make-lexer xyz 1221))
           should return: false")
  (check-equal? (lexer-stuck? (make-lexer "kmn" "/221")) #true
      "(lexer-stuck? (make-lexer kmn /221))
           should return: true")
  (check-equal? (lexer-stuck? (make-lexer "PDP" "")) #true
      "(lexer-stuck? (make-lexer PDP Empty-String))
           should return: true"))

;; STRATEGY: Combine Simple Functions and
;;             use Observer Template for lexer-input.
(define (lexer-stuck? lex)
   (not (and (is-non-empty? (lexer-input lex))
        (or (is-letter? (string-ref (lexer-input lex) 0))
            (is-digit?  (string-ref (lexer-input lex) 0))))))



;; CONTRACT & STATEMENT PURPOSE:
;; append-to-token : String String -> String
;; GIVEN:   two Strings s1 and s2
;; RETURNS: a String with the first alphabet of s2
;;            added to the end of string s2.

;; EXAMPLES:
;; (append-to-token "abc" "1234") => "abc1"
;; (append-to-token "123" "xyz")  => "123x"

;; TESTS:
(begin-for-test
  (check-equal? (append-to-token "" "hi") "h"
      "(append-to-token Empty-String hi)
           should return: h")
  (check-equal? (append-to-token "hello" "world") "hellow"
      "(append-to-token hello world)
           should return: helloworld"))

;; STRATEGY: Extract first alphabet of token string
;;            using substring and append to input string.
(define (append-to-token token input)
  (string-append token (substring input 0 1)))



;; CONTRACT & PURPOSE STATEMENT:
;; delete-from-input : String -> String
;; GIVEN:   a String s1
;; RETURNS: a String like s1 without the first alphabet.

;; EXAMPLES:
;; (delete-from-input "abc") => "bc"
;; (delete-from-input "123") => "23"

(begin-for-test
  (check-equal? (delete-from-input "hello") "ello"
      "(delete-from-input hello)
           should return: ello")
  (check-equal? (delete-from-input "") ""
      "(delete-from-input Empty-String)
           should return: Empty-String"))

;; STRATEGY: Substring from the second alphabet to end of String;
;;             if empty return given string.
(define (delete-from-input input)
  (if (is-non-empty? input)
      (substring input 1)
      input))


;; CONTRACT & PURPOSE STATEMENT:
;; lexer-shift : Lexer -> Lexer
;; GIVEN:   a Lexer
;; RETURNS: If the given Lexer is stuck, returns the given Lexer.
;;          If the given Lexer is not stuck, then the token string
;;           of the result consists of the characters of the given
;;           Lexer's token string followed by the first character
;;           of that Lexer's input string, and the input string
;;           of the result consists of all but the first character
;;           of the given Lexer's input string.

;; EXAMPLES:
;; (lexer-shift (make-lexer "abc" ""))      =>  (make-lexer "abc" "")
;; (lexer-shift (make-lexer "abc" "+1234")) =>  (make-lexer "abc" "+1234")
;; (lexer-shift (make-lexer "abc" "1234"))  =>  (make-lexer "abc1" "234")

;;TESTS:
(begin-for-test
  (check-equal? (lexer-shift (make-lexer "4a5" "")) (make-lexer "4a5" "")
      "(lexer-shift (make-lexer 4a5 Empty-String))
           should return: (make-lexer 4a5 Empty-String)")
  (check-equal? (lexer-shift (make-lexer "qwer" "ty2")) (make-lexer "qwert" "y2")
      "(lexer-shift (make-lexer qwer ty2))
           should return: (make-lexer qwert y2)"))

;; STRATEGY: Combine Simple Functions,
;;            use Constructor template for Lexer and
;;            use Observer Templates for Lexer on lexer-input
;;                                            and lexer-token.
(define (lexer-shift lex)
  (if (lexer-stuck? lex)
        lex
        (make-lexer (append-to-token
                      (lexer-token lex) (lexer-input lex))
                    (delete-from-input (lexer-input lex)))))



;; CONTACT & PURPOSE STATEMENT:
;; lexer-reset : Lexer -> Lexer
;; GIVEN:   a Lexer
;; RETURNS: a Lexer whose token string is empty and whose
;;             input string is empty if the given Lexer's input string
;;             is empty and otherwise consists of all but the first
;;             character of the given Lexer's input string.

;; EXAMPLES:
;; (lexer-reset (make-lexer "abc" ""))      =>  (make-lexer "" "")
;; (lexer-reset (make-lexer "abc" "+1234")) =>  (make-lexer "" "1234")

;; TESTS:
(begin-for-test
  (check-equal? (lexer-reset (make-lexer "xy123" "")) (make-lexer "" "")
      "(lexer-reset (make-lexer xy123 Empty-String))
           should return: (make-lexer Empty-String Empty-String)")
  (check-equal? (lexer-reset (make-lexer "lmn" "*547")) (make-lexer "" "547")
      "(lexer-reset (make-lexer lmn 547))
           should return: (make-lexer Empty-String 547)"))

;; STRATEGY: Combine Simple Functions,
;;             Use Constructor Template for Lexer and
;;             Use Observer Template for Lexer on lexer-input.
(define (lexer-reset lex)
  (if (is-non-empty? (lexer-input lex))
          (make-lexer "" (delete-from-input (lexer-input lex)))
          (make-lexer "" "")))