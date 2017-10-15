;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "05" "q2.rkt")

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
         block?
         constant-expression?
         variables-used-by
         variables-defined-by)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; An ArithmeticExpression is one of
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

;; A sequence of ArithmeticExpressions (ArithmeticExpressionsList)
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

;; CONTRACT & PURPOSE STATEMENTS:
;; operation-expression? : ArithmeticExpression -> Boolean
;; GIVEN:   an arithmetic expression
;; RETURNS: true if and only the expression is an operation expression.

;; EXAMPLES:
;; (operation-expression? (block (var "z")(var "x")(op "+"))) => #true
;; (operation-expression? (op "+"))                           => #true
;; (operation-expression? (block (var "z")(var "x")
;;                               (call (op "+")
;;                                     (list (lit 7.2)
;;                                           (var "x")))))    => #false

;; TESTS:
(begin-for-test
  (check-equal? (operation-expression? (op "*"))
                #true
    "(operation-expression? (op *)) should return: true")
  (check-equal? (operation-expression? (block (var "z")(var "x")
                                              (block (var "y")
                                                     (lit 7.2)
                                                     (lit 10))))
                #false
    "(operation-expression? A Block having a body as A Block
             having a body as literal 10 should return: true"))

;; STRATEGY: Use Observer Template for ArithmeticExpression
;;                                   on aexp.
(define (operation-expression? aexp)
  (cond
    [(operation? aexp)
     #true]
    [(block? aexp)
     (operation-expression? (block-body aexp))]
    [else #false]))

;; CONTRACT & PURPOSE STATEMENTS:
;; operands-constant-expression? : ArithmeticExpressionList -> Boolean
;; GIVEN:   a sequence of arithmetic expressions
;; RETURNS: true if and only all the operands are constant expressions.

;; EXAMPLES:
;; (operands-constant-expression? (list (lit "5") (lit "10"))   => #true
;; (operands-constant-expression? (list (lit "5")
;;                                      (block (var "x")
;;                                             (lit "2")
;;                                             (lit "7"))       => #true
;; (operands-constant-expression? (list (lit "5")
;;                                      (call (op "/")
;;                                            (list (var "y2")
;;                                                  (lit "7"))) => #false
;; (operands-constant-expression? (list (lit "10")
;;                                      (var "x")))             => #false

;; STRATEGY: Use Observer Template for ArithmeticExpressionList
;;                                   on alist.
(define (operands-constant-expression? alist)
  (cond
    [(empty? alist)
     #true]
    [else
     (and (constant-expression? (first alist))
          (operands-constant-expression? (rest alist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; constant-expression? : ArithmeticExpression -> Boolean
;; GIVEN:   an arithmetic expression
;; RETURNS: true if and only the expression is a constant expression.

;; EXAMPLES:
;; (constant-expression? (lit "5")) => #true
;; (constant-expression? (op "+"))                           => #true
;; (constant-expression? (block (var "z")(var "x")
;;                               (call (op "+")
;;                                     (list (lit 7.2)
;;                                           (var "x")))))    => #false

;; TESTS:
(begin-for-test
  (check-equal? (constant-expression? (lit "5"))
                #true
    "(constant-expression? (lit 5)) should return: true")
  (check-equal? (constant-expression? (block (var "x")
                                             (lit "5")
                                             (var "x")))
                #false
    "(constant-expression? Block with body as Variable)
              should return: false")
  (check-equal? (constant-expression? (call (op "*")
                                            (list (block (var "x")
                                                         (lit "5")
                                                         (lit "6")))))
                #true
    "(constant-expression? Call with operator * and list of operand
            having a Block with body as Literal 6)
              should return: true"))

;; STRATEGY: Use Observer Template for ArithmeticExpression
;;                                   on aexp.
(define (constant-expression? aexp)
  (cond
    [(literal? aexp)
     #true]
    [(call? aexp)
     (and (operation-expression? (call-operator aexp))
          (operands-constant-expression? (call-operands aexp)))]
    [(block? aexp)
     (constant-expression? (block-body aexp))]
    [else #false]))

;; CONTRACT & PURPOSE STATEMENTS:
;; variables-defined-by-operands : ArithmeticExpressionList -> StringList
;; GIVEN:   a sequence of arithmetic expressions
;; RETURNS: a list of the names of all variables defined by
;;            all blocks that occur within the expression list, without
;;            repetitions, in any order.

;; EXAMPLES:

;; TESTS:

;; STRATEGY: Use Observer Template for ArithmeticExpressionList
;;                                   on alist.
(define (variables-defined-by-operands alist)
  (cond
    [(empty? alist) empty]
    [else
     (append (variables-defined-by (first alist))
             (variables-defined-by-operands (rest alist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; variables-list-defined-by : ArithmeticExpression -> StringList
;; GIVEN:   an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;            all blocks that occur within the expression, with
;;            repetitions, in any order.

;; EXAMPLES:
;; (variables-list-defined-by
;;               (block (var "x")
;;                      (var "y")
;;                      (call (block (var "z")
;;                                   (var "x")
;;                                   (op "+"))
;;                            (list (block (var "x")
;;                                         (lit 5)
;;                                         (var "x"))
;;                                  (var "x")))))
;;                  => (list "x" "z" "x")

;; TESTS:

;; STRATEGY: Use Observer Template for ArithmeticExpression
;;                                on aexp.
(define (variables-list-defined-by aexp)
  (cond
    [(call? aexp)
     (append (variables-list-defined-by (call-operator aexp))
             (variables-defined-by-operands (call-operands aexp)))]
    [(block? aexp)
     (append (list (variable-name (block-var aexp)))
             (variables-list-defined-by (block-rhs aexp))
             (variables-list-defined-by (block-body aexp)))]
    [else empty]))

;; CONTRACT & PURPOSE STATEMENTS:
;; remove-duplicates : StringList -> StringList
;; GIVEN:   a StringList
;; RETURNS: the same StringList without any duplicate elements.

;; EXAMPLES:

;; TESTS:

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
;; variables-defined-by : ArithmeticExpression -> StringList
;; GIVEN:   an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;            all blocks that occur within the expression, without
;;            repetitions, in any order.

;; EXAMPLES:
;; (variables-defined-by (block (var "x")
;;                              (var "y")
;;                              (call (block (var "z")
;;                                           (var "x")
;;                                           (op "+"))
;;                                    (list (block (var "x")
;;                                                 (lit 5)
;;                                                 (var "x"))
;;                                          (var "x")))))
;;                                   => (list "x" "z") or (list "z" "x")

;; TESTS:
(begin-for-test
  (check-equal?
   (variables-defined-by (call (block (var "a")
                                      (lit "2")
                                      (block (var "a")
                                             (lit "3")
                                             (block (var "a")
                                                    (lit "4")
                                                    (op "*"))))
                                      (list (var "x")
                                            (call (block (var "z")
                                                         (var "x")
                                                         (op "+"))
                                                  (list (lit "1")))
                                            (block (var "x")
                                                   (var "y")
                                                   (lit "5")))))
   (list "a" "z" "x")
   "(variables-defined-by ArithmeticExpression with 5 Blocks
       where 3 Variables defined are a and 2 are x and z
              should return: (list a z x)"))

;; STRATEGY: Use Simpler Functions.
(define (variables-defined-by aexp)
  (remove-duplicates (variables-list-defined-by aexp)))

;; CONTRACT & PURPOSE STATEMENTS:
;; variables-used-by-operands : ArithmeticExpressionList -> StringList
;; GIVEN:   a sequence of arithmetic expressions
;; RETURNS: a list of the names of all variables used by
;;           expressions that occur within the expression list
;;           not including the ones defined in a block unless they are used.

;; EXAMPLES:
;; 

;; TESTS:

;; STRATEGY: Use Observer Template for ArithmeticExpressionList
;;                                   on alist.
(define (variables-used-by-operands alist)
  (cond
    [(empty? alist) empty]
    [else
     (append (variables-used-by (first alist))
             (variables-used-by-operands (rest alist)))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; variables-used-by : ArithmeticExpression -> StringList
;; GIVEN:   an arithmetic expression
;; RETURNS: a list of the names of all variables used in
;;           the expression, including variables used in a block
;;           on the right hand side of its definition or in its body,
;;           but not including variables defined by a block unless
;;           they are also used.

;; EXAMPLES:
;; (variables-used-by
;;    (block (var "x")
;;           (var "y")
;;           (call (block (var "z")
;;                        (var "x")
;;                        (op "+"))
;;                 (list (block (var "x")
;;                              (lit 5)
;;                              (var "x"))
;;                       (var "x")))))
;;              => (list "x" "x" "x" "y") or (list "y" "x" "x" "x"))

;; TESTS:
(begin-for-test
  (check-equal?
   (variables-used-by (call (block (var "a")
                                   (lit "2")
                                   (block (var "a")
                                          (lit "3")
                                          (block (var "a")
                                                 (lit "4")
                                                 (op "*"))))
                                   (list (var "x")
                                         (call (block (var "z")
                                                      (var "x")
                                                      (op "+"))
                                               (list (lit "1")))
                                         (block (var "x")
                                                (var "y")
                                                (lit "5")))))
   (list "x" "x" "y")
   "(variables-defined-by ArithmeticExpression with 5 Blocks
       where there are 5 variables defined and 3 used
              should return: (list x x y)"))

;; STRATEGY: Use Observer Template for ArithmeticExpression
;;                                on aexp.
(define (variables-used-by aexp)
  (cond
    [(variable? aexp)
     (list (variable-name aexp))]
    [(call? aexp)
     (append (variables-used-by (call-operator aexp))
             (variables-used-by-operands (call-operands aexp)))]
    [(block? aexp)
     (append (variables-used-by (block-rhs aexp))
             (variables-used-by (block-body aexp)))]
    [else empty]))