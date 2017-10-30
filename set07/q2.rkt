;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "07" "q2.rkt")

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
         undefined-variables
         well-typed?)


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
;;           is represented as a list of ArithmeticExpressions.

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

;; A Type is represented as one of the following strings:
;;     -- "Int"      (indicating type Integer)
;;     -- "Op0"      (indicating operation to be "+" or "*")
;;     -- "Op1"      (indicating operation to be "-" or "/")
;;     -- "Error"    (indicating type error)

;; EXAMPLES:
(define INT "Int")
(define OP0 "Op0")
(define OP1 "Op1")
(define ERR "Error")

;; OBSERVER TEMPLATE:
;; type-fn : Type -> ??
#;
(define (type-fn t)
  (cond ((string=? t INT) ...)
        ((string=? t OP0) ...)
        ((string=? t OP1) ...)
        ((string=? t ERR) ...)))

;; An OperationName is represented as one of the following strings:
;;     -- "+"      (indicating addition)
;;     -- "-"      (indicating subtraction)
;;     -- "*"      (indicating multiplication)
;;     -- "/"      (indicating division)
;;

;; EXAMPLES:
(define ADD "+")
(define SUB "-")
(define MUL "*")
(define DIV "/")

;; OBSERVER TEMPLATE:
;; operation-name-fn : OperationName -> ??
#;
(define (operation-name-fn op)
  (cond ((string=? op ADD) ...)
        ((string=? op SUB) ...)
        ((string=? op MUL) ...)
        ((string=? op DIV) ...)))

;; An Operation is represented as a struct
;; (make-operation name type)
;;  with the following fields:
;; INTERP:
;;    name : OperationName is the name of the operation.
;;    type : Type          is the type of the operation.

;; IMPLEMENTATION:
(define-struct operation (name type))

;; CONSTRUCTOR TEMPLATE:
;; (make-operation OperationName Type)

;; OBSERVER TEMPLATE:
;; operation-fn: Operation -> ?
;; (define (operation-fn op)
;;    (... (operation-name op)
;;         (operation-type op))

;; A Variable is represented as a struct
;; (make-variable name type)
;;  with the following fields:
;; INTERP:
;;    name : String (the string begins with a letter and contains
;;                     nothing but letters and digits)
;;                is the name of the variable.
;;    type : Type is the type of the variable.
;;                (initially defined as "Error")

;; IMPLEMENTATION:
(define-struct variable (name type))

;; CONSTRUCTOR TEMPLATE:
;; (make-variable String Type)

;; OBSERVER TEMPLATE:
;; variable-fn: Variable -> ?
;; (define (variable-fn v)
;;    (... (variable-name v)
;;         (variable-type v))

;; A sequence of Variables (VariableList)
;;           is represented as a list of a Variables.

;; CONSTRUCTOR TEMPLATES:
;; empty                           -- the empty sequence
;; (cons v vseq)
;;   WHERE:
;;    v    : Variable     is the first Variable
;;                               in the sequence.
;;    vseq : VariableList is the the rest of the sequence.

;; OBSERVER TEMPLATE:
;; vl-fn : VariableList -> ??
#;
(define (vl-fn a)
  (cond
    [(empty? a) ...]
    [else (... (first a)
               (vl-fn (rest a)))]))

;; A Literal is represented as a struct
;; (make-literal value type)
;;  with the following fields:
;; INTERP:
;;    value : Real is the value of the literal.
;;    type  : Type is the type of the literal.
;;                 (Always "Int")

;; IMPLEMENTATION:
(define-struct literal (value type))

;; CONSTRUCTOR TEMPLATE:
;; (make-literal Real Type)

;; OBSERVER TEMPLATE:
;; literal-fn: Literal -> ?
;; (define (literal-fn l)
;;    (... (literal-value l)
;;         (literal-type l))

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
;;    (... (block-exp-var b)
;;         (block-exp-rhs b)
;;         (block-exp-body b))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; lit : Real -> Literal
;; GIVEN:   a real number
;; RETURNS: a literal that represents that number.

;; EXAMPLE:
;; (lit 3)    => (make-literal 3 "Int")
;; (lit -2.5) => (make-literal -2.5 "Int")

;; TESTS:
(begin-for-test
  (check-equal? (lit 5) (make-literal 5 "Int")
     "(lit 5) should return: a Literal with value 5"))

;; STRATEGY: Use Constructor Template for Literal.
(define (lit num)
  (make-literal num INT))

;; CONTRACT & PURPOSE STATEMENTS:
;; var : String -> Variable
;; GIVEN:   a string
;; WHERE:   the string begins with a letter and contains
;;           nothing but letters and digits
;; RETURNS: a variable whose name is the given string

;; EXAMPLE:
;; (var "x15") => (make-variable `"x15" "Error")

;; TESTS:
(begin-for-test
  (check-equal? (var "y2") (make-variable "y2" "Error")
     "(var y2) should return: A Variable with name y2"))

;; STRATEGY: Use Constructor Template for Variable.
(define (var name)
  (make-variable name ERR))

;; CONTRACT & PURPOSE STATEMENTS:
;; op : OperationName -> Operation
;; GIVEN:   the name of an operation
;; RETURNS: the operation with that name.

;; EXAMPLE:
;; (op "-") => (make-operation "-" "Op1")
;; (op "*") => (make-operation "*" "Op0")

;; TESTS:
(begin-for-test
  (check-equal? (op "+") (make-operation "+" "Op0")
     "(op +) should return: an Operation with name +"))

;; STRATEGY: Use Observer Template for OperationName
;;                then use Constructor Template for Operation.
(define (op name)
  (cond
    [(string=? name ADD) (make-operation name OP0)]
    [(string=? name MUL) (make-operation name OP0)]
    [(string=? name SUB) (make-operation name OP1)]
    [(string=? name DIV) (make-operation name OP1)]))

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
                (make-call-exp (make-operation "-" "Op1")
                               (list (make-literal 7 "Int")
                                     (make-literal 2.5 "Int")))
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
;; RETURNS: true iff the expression is a call.

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
;;             -> Block
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
                (make-block-exp (make-variable "x" "Error")
                                (make-literal 5 "Int")
                                (make-call-exp
                                 (make-operation "*" "Op0")
                                 (list (make-variable "10" "Error")
                                       (make-variable "2" "Error"))))
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
;; (block-body (block (var "x5")
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
;; (block? (block (var "x")(lit 5)
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
    "(call? (call? (block (var x)(lit 5)(call (op *)
                                              (list (var 10)(var 2))))))
          should return: true"))

;; STRATEGY: Use Predicates for Block
;;                        on exp.
(define (block? exp)
  (block-exp? exp))

;; CONTRACT & PURPOSE STATEMENTS:
;; var-in-operands? : ArithmeticExpressionList Variable -> Boolean
;; GIVEN:   an ArithmeticExpressionList alist and a variable v
;; WHERE:   alist is part of some block b
;;          v is the variable defined by the block b.
;; RETURNS: true iff the variable v is used somewhere in alist.

;;STRATEGY: Use HOF ormap on op-list.
(define (var-in-operands? op-list v)
  (ormap
   ;; ArithmeticExpression -> Boolean
   ;; GIVEN:   an ArithmeticExpression.
   ;; RETURNS: true iff the variable is v is used somewhere in.
   ;;          the expression exp.
   (lambda (exp)
     (var-in-sub-exp? exp v))
   op-list))

;; CONTRACT & PURPOSE STATEMENTS:
;; var-in-sub-exp? : ArithmeticExpression Variable -> Boolean
;; GIVEN:   an ArithmeticExpression r and a variable v
;; WHERE:   r is part of some block b
;;          v is the variable defined by the block b.
;; RETURNS: true iff the variable v is used somewhere in the
;;           expression r.

;; EXAMPLES:
;; (var-in-sub-exp? (block (var "x")
;;                         (block (var "e")
;;                                (lit 2)
;;                                (var "x1"))
;;                         (var "x"))
;;                  (var "x"))            => #true
;; (var-in-sub-exp? (block (var "x")
;;                         (block (var "e")
;;                                (lit 2)
;;                                (var "z"))
;;                         (var "d"))
;;                  (var "y"))            => #false

;; STRATEGY:  Use Observer Template for ArithmeticExpression
;;                                on r.
(define (var-in-sub-exp? r v)
  (cond
    [(variable? r)
     (string=? (variable-name v) (variable-name r))]
    [(call? r)
     (or (var-in-sub-exp? (call-operator r) v)
         (var-in-operands? (call-operands r) v))]
    [(block? r)
     (or (var-in-sub-exp? (block-var r) v)
         (var-in-sub-exp? (block-rhs r) v)
         (var-in-sub-exp? (block-body r) v))]
    [else
     #false]))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-var-defined? : Block Variable -> Boolean
;; GIVEN:   a Block b and a variable v
;; WHERE:   v is the variable defined by the block b.
;; RETURNS: true iff the variable is said to be defined.
;;          that is, v is used somewhere in the body of b
;;           and not anywhere in the rhs of b.

;; EXAMPLES:
;; (is-var-defined? (block (var "x")
;;                         (block (var "x")
;;                                (lit 2)
;;                                (var "x"))
;;                         (var "x"))
;;                  (var "x"))               => #false
;; (is-var-defined? (block (var "x")
;;                         (block (var "y")
;;                                (lit 2)
;;                                (var "z"))
;;                         (var "x"))
;;                  (var "x"))               => #true

;; STRATEGY: Combine Simpler Functions.
(define (is-var-defined? b v)
  (and (not (var-in-sub-exp? (block-rhs b) (block-var b)))
       (var-in-sub-exp? (block-body b) (block-var b))))

;; CONTRACT & PURPOSE STATEMENTS:
;; undefined-variables-in-block : Block VariableList -> StringList
;; GIVEN:   a Block b and list of variables vlist
;; WHERE:   vlist is the set of variables that are said to be defined upto
;;          the occurence of b.
;; RETURNS: a list of the names of all undefined variables 
;;           that occur within the block b, in any order.

;; EXAMPLES:
;; (undefined-variables-in-block (block (var "a")
;;                                         (var "z")
;;                                         (call (op "+")
;;                                               (list (var "a")
;;                                                     (var "x"))))
;;                                 (list (var "x")))
;;                                              =>     (list "z")

;; STRATEGY: Cases on if variable defined by the block
;;             is said to be defined.
(define (undefined-variables-in-block b def-list)
  (if (is-var-defined? b (block-var b))
      (append (undefined-variables-list (block-rhs b) def-list)
              (undefined-variables-list (block-body b)
                                        (list* (block-var b)
                                               def-list)))
      (append (list (variable-name (block-var b)))
              (undefined-variables-list (block-rhs b) def-list)
              (undefined-variables-list (block-body b) def-list))))

;; CONTRACT & PURPOSE STATEMENTS:
;; undefined-variables-in-operands : ArithmeticExpressionList VariableList
;;                                                   -> StringList
;; GIVEN:   a list of  arithmetic expressions alist and
;;             list of variables vlist
;; WHERE:   vlist is the set of variables that are said to be defined before
;;          the occurence of alist.
;; RETURNS: a list of the names of all undefined variables 
;;           that occur within the alist, in any order.

;; EXAMPLES:
;; (undefined-variables-in-operands (list (var "x")
;;                                        (var "y"))
;;                                  (list (var "y")))
;;                                       => (list "x")

;; STRATEGY: Use Observer Template for ArithmeticExpressionList
;;                                   on alist.
(define (undefined-variables-in-operands alist def-list)
  (cond
    [(empty? alist) empty]
    [else
     (append (undefined-variables-list (first alist) def-list)
             (undefined-variables-in-operands (rest alist) def-list))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; undefined-variables-list : ArithmeticExpression VariableList
;;                                           -> StringList
;; GIVEN:   an arbitrary arithmetic expression aexp and
;;             list of variables vlist
;; WHERE:   aexp is a part of some other larger Arithmetic Expression ae
;; AND:     vlist is the set of variables that are said to be defined before
;;          the occurence of aexp.
;; RETURNS: a list of the names of all undefined variables 
;;           for the expression aexp, in any order.

;; EXAMPLES:
;; (undefined-variables-list (block (var "x")
;;                                  (var "x")
;;                                  (block (var "x")
;;                                         (var "z")
;;                                         (call (op "+")
;;                                               (list (var "a")
;;                                                     (var "x")))))
;;                           (list (var "a")))
;;                                       =>   (list "x" "x" "z")

;; STRATEGY: Use Observer Template for ArithmeticExpression
;;                                on aexp.
(define (undefined-variables-list aexp def-list)
  (cond
    [(variable? aexp)
     (if (member? aexp def-list)
         empty
         (list (variable-name aexp)))]
    [(call? aexp)
     (append (undefined-variables-list (call-operator aexp)
                                       def-list)
             (undefined-variables-in-operands (call-operands aexp)
                                              def-list))]
    [(block? aexp)
     (undefined-variables-in-block aexp def-list)]
    [else empty]))

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
;; undefined-variables : ArithmeticExpression -> StringList
;; GIVEN:   an arbitrary arithmetic expression
;; RETURNS: a list of the names of all undefined variables
;;           for the expression, without repetitions, in any order

;; EXAMPLE:
;;     (undefined-variables
;;      (call (var "f")
;;            (list (block (var "x")
;;                         (var "x")
;;                         (var "x"))
;;                  (block (var "y")
;;                         (lit 7)
;;                         (var "y"))
;;                  (var "z"))))
;;  => some permutation of (list "f" "x" "z")

;; TESTS:
(begin-for-test
  (check-equal? (undefined-variables
                 (block (var "x")
                        (block (var "y")
                               (lit 2)
                               (var "y"))
                        (block (var "a")
                               (block (var "k")
                                      (var "l")
                                      (var "m"))
                               (block (var "z")
                                      (lit 5)
                                      (call (op "*")
                                            (list (var "x")
                                                  (var "z")))))))
                (list "a" "k" "l" "m")
                "There are 7 unique variables in the expression where
             3 are defined and 4 undefined")
  (check-equal? (undefined-variables (block (var "x")
                              (block (var "x")
                                     (lit 2)
                                     (var "x"))
                              (var "x")))
                (list "x")
      "There are 2 instances of variables x
          out of which 1 is undefined"))

;; STRATEGY: Initialise the invariant for undefined-variables-list.
(define (undefined-variables ae)
  (remove-duplicates (undefined-variables-list ae empty)))

;; CONTRACT & PURPOSE STATEMENTS:
;; contains? : Variable VariableList -> Boolean
;; GIVEN:   a Variable v and a VariableList vlist
;; WHERE:   vlist is the set of variables that have been defined
;;            before the occurence of v.
;; RETURNS: true iff there is a variable in vlist with same name as v.

;; EXAMPLES:
;; (contains? (var "x") (list (var "y")
;;                            (make-variable "x" INT)))  => #true
;; (contains? (var "x") (list (var "y")
;;                            (make-variable "z" INT)))  => #false

;; STRATEGY: Use HOF ormap on def-list.
(define (contains? var def-list)
  (ormap
   ;; Variable -> Boolean
   ;; GIVEN:   a Variable v.
   ;; RETURNS: true iff v same name as var.
   (lambda (v)(string=? (variable-name var)
                        (variable-name v)))
   def-list))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-type-in-list : Variable VariableList -> Type
;; GIVEN:   a Variable v and a VariableList vlist
;; WHERE:   there exists a variable in vlist with the same name as v
;;          vlist is the set of variables that have been defined
;;            before the occurence of v.
;; RETURNS: the type of the variable with name same as v.

;; EXAMPLES:
;; (get-type-in-list (var "x") (list (var "y")
;;                                   (var "z")
;;                                   (make-variable "x" OP1))) => "Op1"
;; (get-type-in-list (var "x") (list (var "y")
;;                                   (var "z")
;;                                   (var "x"))                => "Error"

;; TESTS:
(begin-for-test
  (check-equal? (get-type-in-list (var "x")
                                  (list (var "y")
                                        (make-variable "x" OP1)))
                OP1
      "If variable x of type OP1 has been defined earlier
          before the occurence of the use of variable x
             then the type returned should be: OP1"))

;; STRATEGY: Use Observer Template for VariableList on def-list.
(define (get-type-in-list var def-list)
  (cond
    [(string=? (variable-name var)
               (variable-name (first def-list)))
     (variable-type (first def-list))]
    [else (get-type-in-list var (rest def-list))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; remove-var-in-list : Variable VariableList -> VariableList
;; GIVEN:   a Variable v and a VariableList vlist
;; WHERE:   there exists a variable in vlist with the same name as v
;;          vlist is the set of variables that have been defined
;;            before the occurence of v.
;; RETURNS: the same list as given, without the variable with same name as v.

;; EXAMPLES:
;; (remove-var-in-list (var "x") (list (var "z")
;;                                     (make-variable "x" OP1)
;;                                     (var "p")))
;;                         =>    (list (var "z")
;;                                     (var "p"))

;; STRATEGY: Use HOF filter on def-list.
(define (remove-var-in-list var def-list)
  (filter
   ;; Variable -> Boolean
   ;; GIVEN:   a Variable v.
   ;; RETURNS: true iff v does not have same name as var.
   (lambda (n)
     (not (string=? (variable-name var)
                    (variable-name n))))
   def-list))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-list : Variable ArithmeticExpresion VariableList -> VariableList
;; GIVEN:   a Variable v, expression aex and a VariableList vlist
;; WHERE:   v is defined by some block b,
;;          aex is the rhs of block b,
;;          vlist is the set of variables that have been defined
;;            before the occurence of block b.
;; RETURNS: an updated list with either a new variable added or the type of
;;             variable with same name as var changed to the type of aex.

;; EXAMPLES:
;; (update-list (var "x") (block (var "y")
;;                               (op "-")
;;                               (var "y"))
;;              (list (var "y") (make-variable "x" INT)))
;;                      => (list (make-variable "x" OP1) (var "y"))

;; STRATEGY: Cases on if def-list has a variable with same name as var.
(define (update-list var rhs def-list)
  (if (contains? var def-list)
      (list* (make-variable (variable-name var)
                            (get-type rhs def-list))
             (remove-var-in-list var def-list))
      (list* (make-variable (variable-name var)
                            (get-type rhs def-list))
             def-list)))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-block-type : Block VariableList -> Type
;; GIVEN:   a Block b and a VariableList vlist
;; WHERE:   b is part of some expression aex and,
;;          vlist is the set of variables that have been defined
;;            before the occurence of block b.
;; RETURNS: the type of the block b.

;; EXAMPLES:
;; (get-type (block (var "x")(lit 2)(lit 3)) EMPTY)    => "Int"
;; (get-type (block (var "x")(op "+")(var "x")) EMPTY) => "Op0"

;; STRATEGY: Cases on the type of the rhs of block b.
(define (get-block-type b def-list)
  (if (string=? (get-type (block-rhs b) def-list) ERR)
         ERR
         (get-type (block-body b)
                   (update-list (block-var b)
                                (block-rhs b)
                                def-list))))

;; CONTRACT & PURPOSE STATEMENTS:
;; all-operands-int? : ArithmeticExpressionList VariableList -> Boolean
;; GIVEN:   an ArithmeticExpressionList alist
;;             and a VariableList vlist
;; WHERE:   alist is part of some larger expression ae
;;          vlist is the set of variables that might be used within
;;            the scope of alist.
;; RETURNS: true iff every expresion in alist is of type "Int".

;; EXAMPLES:
;; (all-operands-int? (list (lit 2)
;;                          (lit 4)
;;                          (var "x")) empty) =>  #false
;; (all-operands-int? (list (lit 2)
;;                          (lit 4)) empty)   =>  #true
 
;;STRATEGY: Use HOF andmap on op-list.
(define (all-operands-int? op-list def-list)
  (andmap
   ;; ArithmeticExpression -> Boolean
   ;; GIVEN:   an ArithmeticExpression exp.
   ;; RETURNS: true iff exp is of type "Int".
   (lambda (exp)
     (string=? INT
               (get-type exp def-list)))
   op-list))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-call-type : Call VariableList -> Type
;; GIVEN:   a Call c and a VariableList vlist
;; WHERE:   c is part of some expression aex and,
;;          vlist is the set of variables that have been defined
;;            before the occurence of call c.
;; RETURNS: the type of the call c.

;; EXAMPLES:
;; (get-call-type (call (block (var "x")
;;                              (lit 2)
;;                              (var "x"))
;;                       (list (var "x"))) EMPTY)   => "Error"
;; (get-call-type (call (op "-")
;;                       (list (lit 2))) EMPTY)     => "Int"

;; STRATEGY: Cases on the type of the operator of call c.
(define (get-call-type c def-list)
  (cond
    [(string=? OP0 (get-type (call-operator c) def-list))
     (if (all-operands-int? (call-operands c) def-list)
         INT
         ERR)]
    [(string=? OP1 (get-type (call-operator c) def-list))
     (if (and (all-operands-int? (call-operands c) def-list)
              (not (empty? (call-operands c))))
         INT
         ERR)]
    [else ERR]))

;; CONTRACT & PURPOSE STATEMENTS:
;; get-type : ArithmeticExpression VariableList -> Type
;; GIVEN:   a ArithmeticExpression aexp and a VariableList vlist
;; WHERE:   aexp is part of some expression aex and,
;;          vlist is the set of variables that have been defined
;;            before the occurence of expression aexp.
;; RETURNS: the type of the expression aexp.

;; EXAMPLES:
;; (get-type (block (var "x")
;;                   (var "y")
;;                   (var "x"))
;;            (list (var "z")
;;                  (make-variable "y" INT)))  => "Int"
;; (get-type (var "x") (list (var "x")))       => "Error"

;; STRATEGY: Use Observer Template for ArithmeticExpression on aexp.
(define (get-type aexp def-list)
  (cond
    [(literal? aexp)
     (literal-type aexp)]
    [(operation? aexp)
     (operation-type aexp)]
    [(variable? aexp)
     (if (contains? aexp def-list)
         (get-type-in-list aexp def-list)
         ERR)]
    [(block? aexp)
     (get-block-type aexp def-list)]
    [(call? aexp)
     (get-call-type aexp def-list)]))

;; well-typed? : ArithmeticExpression -> Boolean
;; GIVEN: an arbitrary arithmetic expression
;; RETURNS: true if and only if the expression is well-typed
;; EXAMPLES:
;; (well-typed? (lit 17))                   =>  true
;; (well-typed? (var "x"))                  =>  false
;;
;; (well-typed?
;;  (block (var "f")
;;         (op "+")
;;         (block (var "x")
;;                (call (var "f") (list))
;;                (call (op "*")
;;                      (list (var "x"))))) => true
;; (well-typed?
;;  (block (var "f")
;;         (op "+")
;;         (block (var "f")
;;                (call (var "f") (list))
;;                (call (op "*")
;;                      (list (var "f"))))) => true
;;
;; (well-typed?
;;  (block (var "f")
;;         (op "+")
;;         (block (var "x")
;;                (call (var "f") (list))
;;                (call (op "*")
;;                      (list (var "f"))))) => false

;; TESTS:
(begin-for-test
  (check-equal? (well-typed? (block (var "x")
                                    (call (op "*")
                                          (list (lit 3)))
                                    (block (var "z")
                                           (call (block (var "a")
                                                        (lit 2)
                                                        (lit 4))
                                                 (list (lit 6)))
                                           (call (op "-")
                                                 (list (var "x")
                                                       (var "z"))))))
                #false
      "Expression where two blocks define 2 variables, one of type Int
          and other of type Error, both of which are used in the body
            of the inner block should return: false")
  (check-equal? (well-typed? (block (var "x")
                                    (call (op "*")
                                          (list (lit 3)))
                                    (block (var "x")
                                           (call (block (var "a")
                                                        (lit 2)
                                                        (lit 4))
                                                 (list (lit 6)))
                                           (call (op "-")
                                                 (list)))))
                #false
      "Expression where the inner block has a call
          with operator of type Op1 and an empty list of operands
                    should return: false")
  (check-equal? (well-typed? (call (op "*")
                                   (list (block (var "a")
                                                (lit 12)
                                                (var "s")))))
                #false
      "Expression with a call having a block with a body of
           type Error in list of operands should return: false")
  (check-equal? (well-typed? (call (op "/")
                                   empty))
                #false
      "Expression with a call having an Op1 operator
           and empty list of operands should return: false")
  (check-equal? (well-typed? (call (block (var "a")
                                                (lit 12)
                                                (op "/"))
                                   (list (block (var "a")
                                                (lit 12)
                                                (block (var "x")
                                                       (var "a")
                                                       (var "x"))))))
                #true
      "Expression with a call having a block with a body of
           type Op1 as operator and list of operands has
              a block with inner most body of type Int
                  should return: true")
  (check-equal? (well-typed? (block (var "x")
                                    (op "+")
                                    (block (var "x")
                                           (call (var "x")
                                                 (list))
                                           (call (op "/")
                                                 (list (var "x"))))))
                #true
      "Expression with a block defining a variable of different types
          at each level and at the end being used in the list of
            operands with type Int should return: true"))

;; STRATEGY: Initialise the invariant for get-type.
(define (well-typed? aexp)
  (not (string=? ERR
                 (get-type aexp empty))))