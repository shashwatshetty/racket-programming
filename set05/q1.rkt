;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "05" "q1.rkt")

(provide lit
         literal-value
         literal?
         op
         operation-name
         operation?
         var
         variable-name
         variable?
         call-operator
         call-operands
         call
         call?
         block
         block-var
         block-rhs
         block-body
         block?)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; An ArithmeticExpression is one of the following:
;;     -- a Literal
;;     -- a Variable
;;     -- an Operation
;;     -- a Call
;;     -- a Block

;; OBSERVER TEMPLATE:
;; arithmetic-expression-fn : ArithmeticExpression -> ??
#;
(define (arithmetic-expression-fn exp)
  (cond ((literal? exp) ...)
        ((variable? exp) ...)
        ((operation? exp) ...)
        ((call? exp) ...)
        ((block? exp) ...)))

;; A sequence of ArithmeticExpressions (ArithmeticExpressionList)
;;           is represented as a list of a ArithmeticExpressions.

;; CONSTRUCTOR TEMPLATES:
;; empty                           -- the empty sequence
;; (cons a aseq)
;;   WHERE:
;;    a    : ArithmeticExpression     is the first ArithmeticExpression
;;                                      in the sequence.
;;    aseq : ArithmeticExpressionList is the the rest of the sequence.

;; OBSERVER TEMPLATE:
;; ael-fn : ArithmeticExpressionList -> ??
#;
(define (ael-fn a)
  (cond
    [(empty? a) ...]
    [else (... (first a)
               (ael-fn (rest a)))]))

;; An OperationName is represented as one of the following strings:
;;     -- "+"      (indicating addition)
;;     -- "-"      (indicating subtraction)
;;     -- "*"      (indicating multiplication)
;;     -- "/"      (indicating division)
;;

;; OBSERVER TEMPLATE:
;; operation-name-fn : OperationName -> ??
#;
(define (operation-name-fn op)
  (cond ((string=? op "+") ...)
        ((string=? op "-") ...)
        ((string=? op "*") ...)
        ((string=? op "/") ...)))

;; An Operation is represented as a struct
;; (make-operation name)
;;  with the following fields:
;; INTERP:
;;    name : OperationName is the name of the operation.

;; IMPLEMENTATION:
(define-struct operation (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-operation OperationName)

;; OBSERVER TEMPLATE:
;; operation-fn: Operation -> ?
;; (define (operation-fn op)
;;    (... (operation-name op))

;; A Variable is represented as a struct
;; (make-variable name)
;;  with the following fields:
;; INTERP:
;;    name : String (the string begins with a letter and contains
;;                     nothing but letters and digits)
;;               is the name of the variable.

;; IMPLEMENTATION:
(define-struct variable (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-variable String)

;; OBSERVER TEMPLATE:
;; variable-fn: Variable -> ?
;; (define (variable-fn v)
;;    (... (variable-name v))

;; A Literal is represented as a struct
;; (make-literal value)
;;  with the following fields:
;; INTERP:
;;    value : Real is the value of the literal.

;; IMPLEMENTATION:
(define-struct literal (value))

;; CONSTRUCTOR TEMPLATE:
;; (make-literal Real)

;; OBSERVER TEMPLATE:
;; literal-fn: Literal -> ?
;; (define (literal-fn l)
;;    (... (literal-value l))

;; A Call is represented as a struct
;; (make-call-exp operator operands)
;;  with the following fields:
;; INTERP:
;;    operator : ArithmeticExpression     is the operator
;;                                          expression of that call.
;;    operands : ArithmeticExpressionList is the operand
;;                                          expression of that call.

;; IMPLEMENTATION:
(define-struct call-exp (operator operands))

;; CONSTRUCTOR TEMPLATE:
;; (make-call-exp ArithmeticExpression ArithmeticExpressionList)

;; OBSERVER TEMPLATE:
;; call-fn: Call -> ?
;; (define (call-exp-fn c)
;;    (... (call-exp-operator c)
;;         (call-exp-operands c))

;; A Block is represented as a struct
;; (make-block-exp var rhs body)
;;  with the following fields:
;; INTERP:
;;   var  : Variable             is the variable defined by that block.
;;   rhs  : ArithmeticExpression is the expression whose value 
;;                                  will become the value of the variable
;;                                  defined by that block.
;;   body : ArithmeticExpression is the expression whose value will become
;;                                  the value of the block expression.

;; IMPLEMENTATION:
(define-struct block-exp (var rhs body))

;; CONSTRUCTOR TEMPLATE:
;; (make-block-exp Variable ArithmeticExpression ArithmeticExpression)

;; OBSERVER TEMPLATE:
;; block-fn: Block -> ?
;; (define (block-exp-fn b)
;;    (... (block-exp-operator b)
;;         (block-exp-operands b))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; lit : Real -> Literal
;; GIVEN:   a real number
;; RETURNS: a literal that represents that number.

;; EXAMPLE:
;; (lit 3)    => (make-literal 3)
;; (lit -2.5) => (make-literal -2.5)

;; TESTS:
(begin-for-test
  (check-equal? (lit 5) (make-literal 5)
     "(lit 5) should return: a Literal with value 5"))

;; STRATEGY: Use Constructor Template for Literal.
(define (lit num)
  (make-literal num))

;; CONTRACT & PURPOSE STATEMENTS:
;; var : String -> Variable
;; GIVEN:   a string
;; WHERE:   the string begins with a letter and contains
;;           nothing but letters and digits
;; RETURNS: a variable whose name is the given string

;; EXAMPLE:
;; (var "x15") => (make-variable `"x15")

;; TESTS:
(begin-for-test
  (check-equal? (var "y2") (make-variable "y2")
     "(var y2) should return: A Variable with name y2"))

;; STRATEGY: Use Constructor Template for Variable.
(define (var name)
  (make-variable name))

;; CONTRACT & PURPOSE STATEMENTS:
;; op : OperationName -> Operation
;; GIVEN:   the name of an operation
;; RETURNS: the operation with that name.

;; EXAMPLE:
;; (op "-") => (make-operation "-")
;; (op "*") => (make-operation "*")

;; TESTS:
(begin-for-test
  (check-equal? (op "+") (make-operation "+")
     "(op +) should return: an Operation with name +"))

;; STRATEGY: Use Constructor Template for Literal.
(define (op name)
  (make-operation name))

;; CONTRACT & PURPOSE STATEMENTS:
;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;; GIVEN:   an operator expression and a list of operand expressions
;; RETURNS: a call expression whose operator and operands are as
;;             given.

;; EXAMPLES:
;;(call (op "-") (list (lit 7) (lit 2.5)))
;;                       => (make-call-exp (op "-")
;;                                         (list (lit 7) (lit 2.5)))

;; TESTS:
(begin-for-test
  (check-equal? (call (op "-") (list (lit 7) (lit 2.5)))
                (make-call-exp (make-operation "-")
                               (list (make-literal 7)
                                     (make-literal 2.5)))
     "(call (op -) (list (lit 7) (lit 2.5)))
           should return: A Call with operator as -
                    and operands as a list with 7 and 2.5"))

;; STRATEGY: Use Constructor Template for Call.
(define (call operator operand)
  (make-call-exp operator operand))

;; CONTRACT & PURPOSE STATEMENTS:
;; call-operator : Call -> ArithmeticExpression
;; GIVEN:   a call
;; RETURNS: the operator expression of that call

;; EXAMPLE:
;; (call-operator (call (op "-")
;;                      (list (lit 7) (lit 2.5))))
;;         => (op "-")

;; TESTS:
(begin-for-test
  (check-equal? (call-operator (call (op "+")
                                     (list (lit 10)
                                           (lit 5.2))))
                (op "+")
     "(call-operator (call (op +)(list (lit 10) (lit 5.2))))
          should return: the Operation +"))

;; STRATEGY: Use Observer Template for Call
;;                        on exp.
(define (call-operator exp)
  (call-exp-operator exp))

;; CONTRACT & PURPOSE STATEMENTS:
;; call-operands : Call -> ArithmeticExpressionList
;; GIVEN:   a call
;; RETURNS: the operand expressions of that call

;; EXAMPLE:
;; (call-operands (call (op "-")
;;                      (list (lit 7) (lit 2.5))))
;;         => (list (lit 7) (lit 2.5))

;; TESTS:
(begin-for-test
  (check-equal? (call-operands (call (op "+")
                                     (list (lit 10)
                                           (lit 5.2))))
                (list (lit 10) (lit 5.2))
     "(call-operands (call (op +)(list (lit 10) (lit 5.2))))
          should return: the list of operands 10 and 5.2"))

;; STRATEGY: Use Observer Template for Call
;;                        on exp.
(define (call-operands exp)
  (call-exp-operands exp))

;; CONTRACT & PURPOSE STATEMENTS:
;; call? : ArithmeticExpression -> Boolean
;; GIVEN:   an arithmetic expression
;; RETURNS: true if and only the expression is a call.

;; EXAMPLE:
;; (call? (op "-"))                                 => #false
;; (call? (call (op "-") (list (lit 7) (lit 2.5)))) => #true

;; TESTS:
(begin-for-test
  (check-equal? (call? (op "/"))
                #false
     "(call? (op /)) should return: false")
  (check-equal? (call? (call (op "/")
                             (list (var "x1"))))
                #true
     "(call? (call (op /)(list (lit 10) (lit 2))))
          should return: true"))

;; STRATEGY: Use Predicates for Call
;;                        on exp.
(define (call? exp)
  (call-exp? exp))

;; CONTRACT & PURPOSE STATEMENTS:
;; block : Variable ArithmeticExpression ArithmeticExpression
;;             -> ArithmeticExpression
;; GIVEN:   a variable, an expression e0, and an expression e1
;; RETURNS: a block that defines the variable's value as the
;;          value of e0; the block's value will be the value of e1.

;; EXAMPLES:
;; (block (var "x5")
;;        (lit 5)
;;        (call (op "*")
;;              (list (var "x6") (var "x7")))))
;;                  => (make-block-exp (var "x5")
;;                                     (lit 5)
;;                                     (call (op "*")
;;                                           (list (var "x6")
;;                                                 (var "x7")))))

;; TESTS:
(begin-for-test
  (check-equal? (block (var "x")(lit 5)
                       (call (op "*")(list (var "10") (var "2"))))
                (make-block-exp (make-variable "x")
                                (make-literal 5)
                                (make-call-exp (make-operation "*")
                                               (list (make-variable "10")
                                                     (make-variable "2"))))
      "(block (var x)(lit 5)(call (op *)(list (var 10) (var 2))))
          should return: A Block with var as x, rhs as 5
                     and a body with call with 10 and 2 multiplied"))

;; STRATEGY: Use Constructor Template for Block.
(define (block var rhs body)
  (make-block-exp var rhs body))

;; CONTRACT & PURPOSE STATEMENTS:
;; block-var : Block -> Variable
;; GIVEN:   a block
;; RETURNS: the variable defined by that block.

;; EXAMPLE:
;; (block-var (block (var "x5")
;;                   (lit 5)
;;                   (call (op "*")
;;                         (list (var "x6") (var "x7")))))
;;         => (var "x5")

;; TESTS:
(begin-for-test
  (check-equal? (block-var (block (var "x")(lit 5)
                                  (call (op "*")
                                        (list (var "10")
                                              (var "2")))))
                (var "x")
      "(block (var x)(lit 5)(call (op *)(list (var 10) (var 2))))
          should return: A variable as x"))

;; STRATEGY: Use Observer Template for Block
;;                        on b.
(define (block-var b)
  (block-exp-var b))

;; CONTRACT & PURPOSE STATEMENTS:
;; block-rhs : Block -> ArithmeticExpression
;; GIVEN:   a block
;; RETURNS: the expression whose value will become the value of
;;          the variable defined by that block.

;; EXAMPLE:
;; (block-rhs (block (var "x5")
;;                   (lit 5)
;;                   (call (op "*")
;;                         (list (var "x6") (var "x7")))))
;;         => (lit 5)

;; TESTS:
(begin-for-test
  (check-equal? (block-rhs (block (var "x")(lit 5)
                                  (call (op "*")
                                        (list (var "10")
                                              (var "2")))))
                (lit 5)
      "(block (var x)(lit 5)(call (op *)(list (var 10) (var 2))))
          should return: RHS as 5"))

;; STRATEGY: Use Observer Template for Block
;;                        on b.
(define (block-rhs b)
  (block-exp-rhs b))

;; CONTRACT & PURPOSE STATEMENTS:
;; block-body : Block -> ArithmeticExpression
;; GIVEN:   a block
;; RETURNS: the expression whose value will become the value of
;;          the block expression.

;; EXAMPLE:
;; (block-rhs (block (var "x5")
;;                   (lit 5)
;;                   (call (op "*")
;;                         (list (var "x6") (var "x7")))))
;;         => (call (op "*") (list (var "x6") (var "x7")))

;; TESTS:
(begin-for-test
  (check-equal? (block-body (block (var "x")(lit 5)
                                   (call (op "*")
                                         (list (var "10")
                                               (var "2")))))
                (call (op "*")(list (var "10")(var "2")))
      "(block (var x)(lit 5)(call (op *)(list (var 10) (var 2))))
          should return: A body as call with 10 and 2 multiplied"))

;; STRATEGY: Use Observer Template for Block
;;                        on b.
(define (block-body b)
  (block-exp-body b))

;; CONTRACT & PURPOSE STATEMENTS:
;; block? : ArithmeticExpression -> Boolean
;; GIVEN:   an arithmetic expression
;; RETURNS: true if and only the expression is a block.

;; EXAMPLE:
;; (block? (op "-"))                 => #false
;; (call? (block (var "x")(lit 5)
;;               (call (op "*")
;;               (list (var "10")
;;                     (var "2"))))) => #true

;; TESTS:
(begin-for-test
  (check-equal? (block? (op "/"))
                #false
    "(block? (op /)) should return: false")
  (check-equal? (block? (block (var "x")(lit 5)
                              (call (op "*")
                                    (list (var "10")
                                          (var "2")))))
                #true
    "(call? (call? (block (var x)(lit 5)(call (op *)(list (var 10)(var 2))))))
          should return: true"))

;; STRATEGY: Use Predicates for Block
;;                        on exp.
(define (block? exp)
  (block-exp? exp))