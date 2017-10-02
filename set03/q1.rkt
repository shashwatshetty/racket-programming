;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require 2htdp/image)
(require 2htdp/universe)
(check-location "03" "q1.rkt")

(provide simulation
         initial-world
         world-ready-to-serve?
         world-after-tick
         world-after-key-event
         world-ball
         world-racket
         ball-x
         ball-y
         ball-vx
         ball-vy
         racket-x
         racket-y
         racket-vx
         racket-vy)

;; SquashPractise1
;; Simulates squash practise. Simulation starts when the space button
;; is pressed. Simulation contains a squash racket and a squash ball as
;; objects interacting with each other and the simulation environment.


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; image of the squash ball
(define BALL (circle 3 "solid" "black"))

;; image of the squash racket
(define RACKET (rectangle 47 7 "solid" "green"))

;; half the length of squash racket image
(define RACKET-MID-LENGTH (/ (image-width RACKET) 2))

;; dimensions of the court
(define COURT-X-CORD 425)
(define COURT-Y-CORD 649)
(define EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD))
(define PAUSED-EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD "yellow"))

;; co-ordinates of the serving state
(define SERVE-X-CORD 330)
(define SERVE-Y-CORD 384)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; A Ball is represented as a struct
;; (make-ball x y vx vy)
;;  with the following fields:
;; INTERP:
;;    x  : PosReal is the x-co-ordinate of the
;;            pixel at the center of the ball.
;;    y  : PosReal is the y-co-ordinate of the
;;            pixel at the center of the ball.
;;    vx : Real is the x-component of the velocity
;;            of the ball measured as pixel per tick.
;;    vy : Real is the y-component of the velocity
;;            of the ball measured as pixel per tick.

;; IMPLEMENTATION:
(define-struct ball (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-ball PosReal PosReal Real Real)

;; OBSERVER TEMPLATE:
;; ball-fn: Ball -> ?
;; (define (ball-fn ball)
;;    (... (ball-x ball)
;;         (ball-y ball)
;;         (ball-vx ball)
;;         (ball-vy ball))

;; A Racket is represented as a struct
;; (make-racket x y vx vy)
;;  with the following fields:
;; INTERP:
;;    x  : PosReal is the x-co-ordinate of the
;;                  pixel at the center of the racket.
;;    y  : PosReal is the y-co-ordinate of the
;;                  pixel at the center of the racket.
;;    vx : Real    is the x-component of the velocity
;;                  of the racket measured as pixel per tick.
;;    vy : Real    is the y-component of the velocity
;;                  of the racket measured as pixel per tick.

;; IMPLEMENTATION:
(define-struct racket (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-racket PosReal PosReal Real Real)

;; OBSERVER TEMPLATE:
;; racket-fn: Racket -> ?
;; (define (racket-fn racket)
;;    (... (racket-x racket)
;;         (racket-y racket)
;;         (racket-vx racket)
;;         (racket-vy racket))

;; A World is represented as a struct
;; (make-world ball racket ready-to-serve? in-rally? speed ticks-passed)
;;  with the following fields:
;;     ball            : Ball       is the ball in the world.
;;     racket          : Racket     is the Racket in the world.
;;     ready-to-serve? : Boolean    represents if the world is in a
;;                                   ready to serve state.
;;     in-rally?       : Boolean    represents if the world is in a
;;                                   rally state.
;;     speed           : NonNegReal is the speed of the simulation
;;                                   given by the user.
;;     ticks-passed    : PosInt     is the number of ticks that have passed
;;                                   in a non-paused or paused state.

;; IMPLEMENTATION:
(define-struct world
  (ball racket ready-to-serve? in-rally? speed ticks-passed))

;; CONSTRUCTOR TEMPLATE:
;; (make-world Ball Racket Boolean Boolean NonNegReal PosInt)

;; OBSERVER TEMPLATE:
;; world-fn: World -> ?
;; (define (world-ball world)
;;    (... (world-racket world)
;;         (world-ready-to-serve? world)
;;         (world-in-rally? world)
;;         (world-speed world)
;;         (world-ticks-passed world))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; initial-world : PosReal -> World
;; GIVEN:   the speed of the simulation, in seconds per tick
;;            (so larger numbers run slower)
;; RETURNS: the ready-to-serve state of the world.

;; EXAMPLES:
;; (initial-world 1) => (make-world (make-ball 330 384 0 0)
;;                                 (make-racket 330 384 0 0)
;;                                 #true
;;                                 #false
;;                                 1
;;                                 0)

;; TESTS:
(begin-for-test
  (check-equal? (initial-world 1)
                (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 0 0)
                            (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
                            #true
                            #false
                            1
                            0)
     "(initial-world 1) should return: world at initial position
             in a ready to serve state."))

;; STRATEGY: Use Constructor Template for World.
(define (initial-world sim-speed)
  (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 0 0)
              (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
              #true
              #false
              sim-speed
              0))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-serve-ready : World -> Boolean
;; GIVEN:   a world
;; RETURNS: true iff the world is not in its ready-to-serve state.

;; EXAMPLES:
;; (update-serve-ready (make-world (make-ball 330 384 0 0)
;;                                 (make-racket 330 384 0 0)
;;                                 #true
;;                                 #false
;;                                 1
;;                                 0))
;;                                         => #false

;; TESTS:
(begin-for-test
  (check-equal? (update-serve-ready
                 (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 0 0)
                             (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
                             #true
                             #false
                             1
                             0))
                #false
     "(update-serve-ready (World with world-ready-to-serve? = true))
         should return: false"))

;; STRATEGY: Use Observer Template for World
;;             on world-ready-to-serve?.
(define (update-serve-ready w)
  (not (world-ready-to-serve? w)))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-in-rally : World -> Boolean
;; GIVEN:   a world
;; RETURNS: true iff the world is not in a rally state.

;; EXAMPLES:
;; (update-in-rally (make-world (make-ball 330 384 0 0)
;;                                 (make-racket 330 384 0 0)
;;                                 #true
;;                                 #false
;;                                 1
;;                                 0))
;;                                         => #true

;; TESTS:
(begin-for-test
  (check-equal? (update-in-rally
                 (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 0 0)
                             (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
                             #true
                             #false
                             1
                             0))
                #true
     "(update-serve-ready (World with world-in-rally? = false))
         should return: true"))

;; STRATEGY: Use Observer Template for World
;;             on world-in-rally?.
(define (update-in-rally w)
  (not (world-in-rally? w)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS MANIPULATING STATES OF THE BALL:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; ball-hitting-left-wall? : Ball -> Boolean
;; GIVEN:   a ball
;; RETURNS: true iff the ball is colliding with the
;;            left wall in the next tick.

;; EXAMPLES:
;; (ball-hitting-left-wall? (make-ball 2 50 -3 9)) => #true
;; (ball-hitting-left-wall? (make-ball 10 50 -3 9)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (ball-hitting-left-wall? (make-ball 2 50 -3 9))
                #true
    "(ball-hitting-left-wall? (make-ball 2 50 -3 9))
          should return: true"))

;; STRATEGY: Use Observer Template for Ball
;;             on ball-x
;;                ball-vx.
(define (ball-hitting-left-wall? ball)
  (<= (+ (ball-x ball) (ball-vx ball)) 0))

;; CONTRACT & PURPOSE STATEMENTS:
;; ball-hitting-right-wall? : Ball -> Boolean
;; GIVEN:   a ball
;; RETURNS: true iff the ball is colliding with the
;;            right wall in the next tick.

;; EXAMPLES:
;; (ball-hitting-right-wall? (make-ball 423 50 3 9)) => #true
;; (ball-hitting-right-wall? (make-ball 400 50 3 -9)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (ball-hitting-right-wall? (make-ball 400 50 3 -9))
                #false
    "(ball-hitting-right-wall? (make-ball 400 50 3 -9))
          should return: false"))

;; STRATEGY: Use Observer Template for Ball
;;             on ball-x
;;                ball-vx.
(define (ball-hitting-right-wall? ball)
  (>= (+ (ball-x ball) (ball-vx ball)) COURT-X-CORD))

;; CONTRACT & PURPOSE STATEMENTS:
;; ball-hitting-top-wall? : Ball -> Boolean
;; GIVEN:   a ball
;; RETURNS: true iff the ball is colliding with the
;;            top wall in the next tick.

;; EXAMPLES:
;; (ball-hitting-top-wall? (make-ball 20 8 3 -9)) => #true
;; (ball-hitting-top-wall? (make-ball 400 50 3 9)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (ball-hitting-top-wall? (make-ball 20 8 3 -9))
                #true
    "(ball-hitting-top-wall? (make-ball 20 8 3 -9))
          should return: true"))

;; STRATEGY: Use Observer Template for Ball
;;             on ball-y
;;                ball-vy.
(define (ball-hitting-top-wall? ball)
  (<= (+ (ball-y ball) (ball-vy ball)) 0))

;; CONTRACT & PURPOSE STATEMENTS:
;; ball-hitting-bottom-wall? : Ball -> Boolean
;; GIVEN:   a ball
;; RETURNS: true iff the ball is colliding with the
;;            bottom wall in the next tick.

;; EXAMPLES:
;; (ball-hitting-bottom-wall? (make-ball 20 645 3 9)) => #true
;; (ball-hitting-bottom-wall? (make-ball 150 350 3 -9)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (ball-hitting-bottom-wall? (make-ball 150 350 3 -9))
                #false
    "(ball-hitting-bottom-wall? (make-ball 150 350 3 -9))
          should return: false"))

;; STRATEGY: Use Observer Template for Ball
;;             on ball-y
;;                ball-vy.
(define (ball-hitting-bottom-wall? ball)
  (>= (+ (ball-y ball) (ball-vy ball)) COURT-Y-CORD))

;; CONTRACT & PURPOSE STATEMENTS:
;; ball-hitting-racket? : Ball Racket -> Boolean
;; GIVEN:   a ball
;; RETURNS: true iff the ball is colliding with the
;;            racket in the next tick.

;; EXAMPLES:
;; (ball-hitting-racket? (make-ball 100 293 3 9)
;;                       (make-racket 120 300 0 0)) => #true
;; (ball-hitting-racket? (make-ball 150 350 3 -9))
;;                       (make-racket 20 645 3 9)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (ball-hitting-racket? (make-ball 100 293 3 9)
                                      (make-racket 120 300 0 0))
                #true
    "(ball-hitting-racket? (make-ball 100 293 3 9)
                           (make-racket 120 300 0 0))
          should return: true")
  (check-equal? (ball-hitting-racket? (make-ball 150 350 3 -9)
                                      (make-racket 20 645 3 9))
                #false
    "(ball-hitting-racket? (make-ball 100 293 3 9)
                           (make-racket 120 300 0 0))
          should return: false"))

;; STRATEGY: Use Observer Template for Ball & Racket
;;             on ball-x ball-vx ball-y ball-vy
;;                racket-x racket-vx racket-y racket-vy.
(define (ball-hitting-racket? ball racket)
  (and (>= (+ (ball-y ball) (ball-vy ball))
          (+ (racket-y racket) (racket-vy racket)))
       (> (racket-y racket) (ball-y ball))
       (<= (+ (ball-x ball) (ball-vx ball))
           (+ (racket-x racket) (racket-vx racket) RACKET-MID-LENGTH))
       (>= (+ (ball-x ball) (ball-vx ball))
           (- (+ (racket-x racket) (racket-vx racket))
              RACKET-MID-LENGTH))))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-ball-x : Ball -> PosReal
;; GIVEN:   a ball
;; RETURNS: the x-cordinate of the pixel at the center
;;             of the ball in the next tick.

;; EXAMPLES:
;; (update-ball-x (make-ball 100 293 3 9)) => 103
;; (update-ball-x (make-ball 423 50 3 9))  => 424
;; (update-ball-x (make-ball 2 50 -3 9))   => 1

;; TESTS:
(begin-for-test
  (check-equal? (update-ball-x (make-ball 100 293 3 9))
                103
    "(update-ball-x (make-ball 100 293 3 9))
          should return: 103")
  (check-equal? (update-ball-x (make-ball 423 50 3 9))
                424
    "(update-ball-x (make-ball 100 293 3 9))
          should return: 123")
  (check-equal? (update-ball-x (make-ball 2 50 -3 9))
                1
    "(update-ball-x (make-ball 100 293 3 9))
          should return: 123"))

;; STRATEGY: Cases on if ball hits walls along the x-axis.
(define (update-ball-x ball)
  (cond
    [(ball-hitting-left-wall? ball)
         (* (+ (ball-x ball) (ball-vx ball)) -1)]
    [(ball-hitting-right-wall? ball)
         (- (* 2 COURT-X-CORD) (+ (ball-x ball) (ball-vx ball)))]
    [else (+ (ball-x ball) (ball-vx ball))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-ball-y : Ball -> PosReal
;; GIVEN:   a ball
;; RETURNS: the y-cordinate of the pixel at the center
;;             of the ball in the next tick.

;; EXAMPLES:
;; (update-ball-y (make-ball 100 293 3 9)) => 302
;; (update-ball-y (make-ball 20 5 3 -9))   => 4

;; TESTS:
(begin-for-test
  (check-equal? (update-ball-y (make-ball 100 293 3 9))
                302
    "(update-ball-y (make-ball 100 293 3 9))
          should return: 302")
  (check-equal? (update-ball-y (make-ball 20 5 3 -9))
                4
    "(update-ball-y (make-ball 20 5 3 -9))
          should return: 4"))

;; STRATEGY: Cases on if ball hits walls along the y-axis.
(define (update-ball-y ball)
  (cond
    [(ball-hitting-top-wall? ball)
     (* (+ (ball-y ball) (ball-vy ball)) -1)]
    [else (+ (ball-y ball) (ball-vy ball))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-ball-vx : Ball -> Real
;; GIVEN:   a ball
;; RETURNS: the x-component of the velocity
;;            of the ball in the next tick.

;; EXAMPLES:
;; (update-ball-vx (make-ball 100 293 3 9)) => 3
;; (update-ball-vx (make-ball 423 50 3 9))  => -3
;; (update-ball-vx (make-ball 2 50 -3 9))   => 3

;; TESTS:
(begin-for-test
  (check-equal? (update-ball-vx (make-ball 100 293 3 9))
                3
    "(update-ball-vx (make-ball 100 293 3 9))
          should return: 3")
  (check-equal? (update-ball-vx (make-ball 423 50 3 9))
                -3
    "(update-ball-vx (make-ball 423 50 3 9))
          should return: -3")
  (check-equal? (update-ball-vx (make-ball 2 50 -3 9))
                3
    "(update-ball-vx (make-ball 2 50 -3 9))
          should return: 3"))

;; STRATEGY: Cases on if ball hits walls along the x-axis
;;             and Use Observer Template for Ball
;;                          on ball-vx.
(define (update-ball-vx ball)
  (if (or (ball-hitting-left-wall? ball)
          (ball-hitting-right-wall? ball))
      (* -1 (ball-vx ball))
      (ball-vx ball)))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-ball-vy : Ball -> Real
;; GIVEN:   a ball
;; RETURNS: the y-component of the velocity
;;            of the ball in the next tick.

;; EXAMPLES:
;; (update-ball-vy (make-ball 100 293 3 -9)) => -9
;; (update-ball-vy (make-ball 20 5 3 -9))   => 9

;; TESTS:
(begin-for-test
  (check-equal? (update-ball-vy (make-ball 100 293 3 -9))
                -9
    "(update-ball-y (make-ball 100 293 3 -9))
          should return: -9")
  (check-equal? (update-ball-vy (make-ball 20 5 3 -9))
                9
    "(update-ball-vy (make-ball 20 5 3 -9))
          should return: 9"))

;; STRATEGY: Cases on if ball hits the top wall
;;             and Use Observer Template for Ball
;;                          on ball-vy.
(define (update-ball-vy ball)
  (cond
    [(ball-hitting-top-wall? ball)
     (* -1 (ball-vy ball))]
    [else (ball-vy ball)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; move-ball : Ball Racket -> Ball
;; GIVEN:   a ball and racket
;; RETURNS: the same ball in the next tick.

;; EXAMPLES:
;; (move-ball (make-ball 100 293 3 9)
;;            (make-racket 120 300 0 0)) => (make-ball 103 298 3 -9)
;; (move-ball (make-ball 150 350 3 -9))
;;            (make-racket 20 645 3 9))  => (make-ball 153 341 3 -9)

;; TESTS:
(begin-for-test
  (check-equal? (move-ball (make-ball 100 293 3 9)
                           (make-racket 120 300 0 0))
                (make-ball 103 298 3 -9)
    "(ball-hitting-racket? (make-ball 100 293 3 9)
                           (make-racket 120 300 0 0))
          should return: (make-ball 103 298 3 -9)")
  (check-equal? (move-ball (make-ball 150 350 3 -9)
                           (make-racket 20 645 3 9))
                (make-ball 153 341 3 -9)
    "(ball-hitting-racket? (make-ball 100 293 3 9)
                           (make-racket 120 300 0 0))
          should return: (make-ball 153 341 3 -9)"))

;; STRATEGY: Cases on if ball hits the racket
;;             and Use Constructor Template for Ball.
(define (move-ball ball racket)
  (if (ball-hitting-racket? ball racket)
      (make-ball (update-ball-x ball)
                 (- (* 2 (+ (racket-y racket) (racket-vy racket)))
                    (+ (ball-y ball) (ball-vy ball)))
                 (update-ball-vx ball)
                 (- (racket-vy racket) (ball-vy ball)))
      (make-ball (update-ball-x ball)
                 (update-ball-y ball)
                 (update-ball-vx ball)
                 (update-ball-vy ball))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS MANIPULATING STATES OF THE RACKET:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; racket-hitting-left-wall? : Racket -> Boolean
;; GIVEN:   a racket
;; RETURNS: true iff the racket is colliding with the
;;            left wall in the next tick.

;; EXAMPLES:
;; (racket-hitting-left-wall? (make-racket 25 40 -3 1)) => #true
;; (racket-hitting-left-wall? (make-racket 65 40 3 1)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (racket-hitting-left-wall? (make-racket 25 40 -3 1))
                #true
     "(racket-hitting-left-wall? (make-racket 25 40 -3 1))
            should return: true"))

;; STRATEGY: Use Observer Template for Racket
;;             on racket-x
;;                racket-vx.
(define (racket-hitting-left-wall? racket)
  (<= (- (+ (racket-x racket)
            (racket-vx racket))
         RACKET-MID-LENGTH)
      0))

;; CONTRACT & PURPOSE STATEMENTS:
;; racket-hitting-right-wall? : Racket -> Boolean
;; GIVEN:   a racket
;; RETURNS: true iff the racket is colliding with the
;;            right wall in the next tick.

;; EXAMPLES:
;; (racket-hitting-right-wall? (make-racket 400 40 3 1)) => #true
;; (racket-hitting-right-wall? (make-racket 65 40 3 1)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (racket-hitting-right-wall? (make-racket 400 40 3 1))
                #true
     "(racket-hitting-right-wall? (make-racket 400 40 3 1))
            should return: true"))

;; STRATEGY: Use Observer Template for Racket
;;             on racket-x
;;                racket-vx.
(define (racket-hitting-right-wall? racket)
  (>= (+ (racket-x racket)
         (racket-vx racket)
         RACKET-MID-LENGTH)
      COURT-X-CORD))

;; CONTRACT & PURPOSE STATEMENTS:
;; racket-hitting-top-wall? : Racket -> Boolean
;; GIVEN:   a racket
;; RETURNS: true iff the racket is colliding with the
;;            top wall in the next tick.

;; EXAMPLES:
;; (racket-hitting-top-wall? (make-racket 120 2 0 -3)) => #true
;; (racket-hitting-top-wall? (make-racket 65 40 3 1)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (racket-hitting-top-wall? (make-racket 65 40 3 1))
                #false
     "(racket-hitting-top-wall? (make-racket 65 40 3 1))
            should return: false"))

;; STRATEGY: Use Observer Template for Racket
;;             on racket-y
;;                racket-vy.
(define (racket-hitting-top-wall? racket)
  (<= (+ (racket-y racket) (racket-vy racket)) 0))

;; CONTRACT & PURPOSE STATEMENTS:
;; racket-hitting-bottom-wall? : Racket -> Boolean
;; GIVEN:   a racket
;; RETURNS: true iff the racket is colliding with the
;;            bottom wall in the next tick.

;; EXAMPLES:
;; (racket-hitting-bottom-wall? (make-racket 120 647 0 5)) => #true
;; (racket-hitting-bottom-wall? (make-racket 65 40 3 1)) => #false

;; TESTS:
(begin-for-test
  (check-equal? (racket-hitting-bottom-wall? (make-racket 120 647 0 5))
                #true
     "(racket-hitting-bottom-wall? (make-racket 120 647 0 5))
            should return: true"))

;; STRATEGY: Use Observer Template for Racket
;;             on racket-y
;;                racket-vy.
(define (racket-hitting-bottom-wall? racket)
  (>= (+ (racket-y racket) (racket-vy racket)) COURT-Y-CORD))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-x : Racket -> PosReal
;; GIVEN:   a racket
;; RETURNS: the x-cordinate of the pixel at the center
;;             of the racket in the next tick.

;; EXAMPLES:
;; (update-racket-x (make-racket 25 40 -3 1)) => 23.5
;; (update-racket-x (make-racket 400 40 3 1)) => 401.5
;; (update-racket-x (make-racket 65 40 3 1))  => 68

;; TESTS:
(begin-for-test
  (check-equal? (update-racket-x (make-racket 25 40 -3 1))
                23.5
      "(update-racket-x (make-racket 25 40 -3 1))
              should return: 23.5")
  (check-equal? (update-racket-x (make-racket 400 40 3 1))
                401.5
      "(update-racket-x (make-racket 400 40 3 1))
              should return: 401.5")
  (check-equal? (update-racket-x (make-racket 65 40 3 1))
                68
      "(update-racket-x (make-racket 65 40 3 1))
              should return: 68"))


;; STRATEGY: Cases on if ball hits walls along the x-axis.
(define (update-racket-x racket)
  (cond
    [(racket-hitting-left-wall? racket)
         RACKET-MID-LENGTH]
    [(racket-hitting-right-wall? racket)
         (- COURT-X-CORD RACKET-MID-LENGTH)]
    [else (+ (racket-x racket) (racket-vx racket))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-y : Racket -> PosReal
;; GIVEN:   a racket
;; RETURNS: the y-cordinate of the pixel at the center
;;             of the racket in the next tick.

;; EXAMPLES:
;; (update-racket-y (make-racket 120 647 0 5)) => 649
;; (update-racket-y (make-racket 65 40 3 1))   => 41

;; TESTS:
(begin-for-test
  (check-equal? (update-racket-y (make-racket 120 647 0 5))
                649
      "(update-racket-y (make-racket 120 647 0 5))
              should return: 649")
  (check-equal? (update-racket-y (make-racket 65 40 3 1))
                41
      "(update-racket-y (make-racket 65 40 3 1))
              should return: 41"))

;; STRATEGY: Cases on if ball hits walls along the y-axis.
(define (update-racket-y racket)
  (cond
    [(racket-hitting-bottom-wall? racket)
         COURT-Y-CORD]
    [else (+ (racket-y racket) (racket-vy racket))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-vx : Racket KeyEvent -> Real
;; GIVEN:   a racket and a KeyEvent
;; RETURNS: the x-component of the velocity
;;             of the racket in the next tick.

;; EXAMPLES:
(define ANY-OTHER-KEY "q")
;; (update-racket-vx (make-racket 330 384 0 0) LEFT-ARROW-KEY)  => -1
;; (update-racket-vx (make-racket 330 384 2 0) RIGHT-ARROW-KEY) => 3
;; (update-racket-vx (make-racket 330 384 2 0) ANY-OTHER-KEY) => 2

;; TESTS:
(begin-for-test
  (check-equal? (update-racket-vx
                 (make-racket 330 384 0 0) LEFT-ARROW-KEY)
                -1
    "(update-racket-vx (make-racket 330 384 0 0) LEFT-ARROW-KEY)
        should return: -1")
  (check-equal? (update-racket-vx
                 (make-racket 330 384 2 0) RIGHT-ARROW-KEY)
                3
    "(update-racket-vx (make-racket 330 384 2 0) RIGHT-ARROW-KEY)
        should return: 3")
  (check-equal? (update-racket-vx
                 (make-racket 330 384 2 0) ANY-OTHER-KEY)
                2
    "(update-racket-vx (make-racket 330 384 2 0) ANY-OTHER-KEY)
        should return: 2"))

;; STRATEGY: Cases on the KeyEvent passed.
(define (update-racket-vx racket ke)
  (cond
    [(is-left-arrow-key-event? ke) (sub1 (racket-vx racket))]
    [(is-right-arrow-key-event? ke) (add1 (racket-vx racket))]
    [else (racket-vx racket)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-vy : Racket KeyEvent -> Real
;; GIVEN:   a racket and a KeyEvent
;; RETURNS: the y-component of the velocity
;;             of the racket in the next tick.

;; EXAMPLES:
;; (update-racket-vy (make-racket 330 384 0 0) UP-ARROW-KEY)  => -1
;; (update-racket-vy (make-racket 330 384 2 3) DOWN-ARROW-KEY) => 4
;; (update-racket-vy (make-racket 330 384 0 2) ANY-OTHER-KEY) => 2

;; TESTS:
(begin-for-test
  (check-equal? (update-racket-vy
                 (make-racket 330 384 0 0) UP-ARROW-KEY)
                -1
    "(update-racket-vy (make-racket 330 384 0 0) UP-ARROW-KEY)
        should return: -1")
  (check-equal? (update-racket-vy
                 (make-racket 330 384 2 3) DOWN-ARROW-KEY)
                4
    "(update-racket-vy (make-racket 330 384 2 3) DOWN-ARROW-KEY)
        should return: 4")
  (check-equal? (update-racket-vy
                 (make-racket 330 384 0 2) ANY-OTHER-KEY)
                2
    "(update-racket-vy (make-racket 330 384 0 2) ANY-OTHER-KEY)
        should return: 2"))

;; STRATEGY: Cases on the KeyEvent passed.
(define (update-racket-vy racket ke)
  (cond
    [(is-up-arrow-key-event? ke) (sub1 (racket-vy racket))]
    [(is-down-arrow-key-event? ke) (add1 (racket-vy racket))]
    [else (racket-vy racket)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-speed : Racket KeyEvent -> Racket
;; GIVEN:   a racket and a KeyEvent
;; RETURNS: the racket in the next tick with updated velocities.

;; EXAMPLES:
;; (update-racket-speed (make-racket 330 384 0 0) LEFT-ARROW-KEY)
;;                               => (make-racket 330 384 -1 0)
;; (update-racket-speed (make-racket 330 384 2 0) RIGHT-ARROW-KEY)
;;                               => (make-racket 330 384 3 0)
;; (update-racket-speed (make-racket 330 384 0 0) UP-ARROW-KEY)
;;                               => (make-racket 330 384 0 -1)
;; (update-racket-speed (make-racket 330 384 2 3) DOWN-ARROW-KEY)
;;                               => (make-racket 330 384 2 4)
;; (update-racket-speed (make-racket 330 384 0 2) ANY-OTHER-KEY)
;;                               => (make-racket 330 384 0 2)

;; TESTS:
(begin-for-test
  (check-equal? (update-racket-speed
                 (make-racket 330 384 2 0) UP-ARROW-KEY)
                (make-racket 330 384 2 -1)
    "(update-racket-vy (make-racket 330 384 2 0) UP-ARROW-KEY)
        should return: (make-racket 330 384 2 -1)"))

;; STRATEGY: Divide into Simple Functions
;;             and Use Constructor Template for Racket.
(define (update-racket-speed racket kev)
  (make-racket (racket-x racket)
               (racket-y racket)
               (update-racket-vx racket kev)
               (update-racket-vy racket kev)))

;; CONTRACT & PURPOSE STATEMENTS:
;; move-racket : Ball Racket -> Racket
;; GIVEN:   a ball and racket
;; RETURNS: the same racket in the next tick.

;; EXAMPLES:
;; (move-racket (make-ball 100 293 3 9)
;;              (make-racket 120 300 0 -1)) => (make-racket 120 299 0 0)
;; (move-racket (make-ball 150 350 3 -9))
;;              (make-racket 20 645 3 9))   => (make-racket 23 649 3 9)

;; TESTS:
(begin-for-test
  (check-equal? (move-racket (make-ball 100 293 3 9)
                             (make-racket 120 300 0 -1))
                (make-racket 120 299 0 0)
    "(move-racket (make-ball 100 293 3 9)
                  (make-racket 120 300 0 -1))
          should return: (make-racket 120 299 0 0)")
  (check-equal? (move-racket (make-ball 150 350 3 -9)
                             (make-racket 40 645 3 9))
                (make-racket 43 649 3 9)
    "(move-racket (make-ball 150 350 3 -9))
                  (make-racket 40 645 3 9))
          should return: (make-racket 43 649 3 9)"))

;; STRATEGY: Cases on if ball hits the racket
;;             and Use Constructor Template for Racket.
(define (move-racket ball racket)
  (if (and (ball-hitting-racket? ball racket)
           (< (racket-vy racket) 0))
      (make-racket (update-racket-x racket)
                   (update-racket-y racket)
                   (racket-vx racket)
                   0)
      (make-racket (update-racket-x racket)
                   (update-racket-y racket)
                   (racket-vx racket)
                   (racket-vy racket))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS MANIPULATING STATES OF THE WORLD:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; move-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world in the next tick.

;; EXAMPLES:
;; (move-world (make-world (make-ball 330 384 3 -9)
;;                         (make-racket 330 384 0 0)
;;                         #false
;;                         #true
;;                         1
;;                         4)
;;                  => (make-world (make-ball 333 375 3 -9)
;;                                 (make-racket 330 384 0 0)
;;                                 #false
;;                                 #true
;;                                 1
;;                                 5)
;; (move-world (make-world (make-ball 20 645 3 9))
;;                         (make-racket 330 384 0 0)
;;                         #false
;;                         #true
;;                         1
;;                         4)
;;                  => (make-world (make-ball 20 645 3 9))
;;                                 (make-racket 330 384 0 0)
;;                                 #false
;;                                 #false
;;                                 1
;;                                 0)

;; TESTS:
(begin-for-test
  (check-equal? (move-world (make-world (make-ball 330 384 3 -9)
                                        (make-racket 330 384 0 0)
                                        #false
                                        #true
                                        1
                                        4))
                (make-world (make-ball 333 375 3 -9)
                            (make-racket 330 384 0 0)
                            #false
                            #true
                            1
                            5)
     "(move-world World in a rally state) should return: world
           at the next tick with appropriate updates to its fields.")
  (check-equal? (move-world (make-world (make-ball 20 645 3 9)
                                        (make-racket 330 384 0 0)
                                        #false
                                        #true
                                        1
                                        4))
                (make-world (make-ball 20 645 3 9)
                            (make-racket 330 384 0 0)
                            #false
                            #false
                            1
                            0)
     "(move-world World with ball hitting bottom wall in next tick)
            should return: world in paused state."))

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (move-world w)
  (if (or (ball-hitting-bottom-wall? (world-ball w))
         (racket-hitting-top-wall? (world-racket w)))
      (pause-world w)
      (make-world (move-ball (world-ball w) (world-racket w))
                  (move-racket (world-ball w) (world-racket w))
                  (world-ready-to-serve? w)
                  (world-in-rally? w)
                  (world-speed w)
                  (add1 (world-ticks-passed w)))))

;; CONTRACT & PURPOSE STATEMENTS:
;; pause-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world in the paused state.

;; EXAMPLES:
;; (pause-world (make-world (make-ball 20 645 3 9))
;;                         (make-racket 330 384 0 0)
;;                         #false
;;                         #true
;;                         1
;;                         4)
;;                  => (make-world (make-ball 20 645 3 9))
;;                                 (make-racket 330 384 0 0)
;;                                 #false
;;                                 #false
;;                                 1
;;                                 0)

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (pause-world w)
  (make-world (world-ball w)
              (world-racket w)
              (world-ready-to-serve? w)
              (update-in-rally w)
              (world-speed w)
              0))

;; CONTRACT & PURPOSE STATEMENTS:
;; restart-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world after the paused state.
;;             Same world withing the first 3 seconds of paused state.
;;             World in ready to serve state after 3 seconds pause.

;; EXAMPLES:
;; (restart-world (make-world (make-ball 20 645 3 9)
;;                         (make-racket 330 384 0 0)
;;                         #false
;;                         #false
;;                         1
;;                         1)
;;                  => (make-world (make-ball 20 645 3 9)
;;                                 (make-racket 330 384 0 0)
;;                                 #false
;;                                 #false
;;                                 1
;;                                 2)
;; (restart-world (make-world (make-ball 20 645 3 9))
;;                         (make-racket 330 384 0 0)
;;                         #false
;;                         #false
;;                         1
;;                         4)
;;                  => (make-world (make-ball 330 384 0 0))
;;                                 (make-racket 330 384 0 0)
;;                                 #true
;;                                 #false
;;                                 1
;;                                 0)

;; TESTS:
(begin-for-test
  (check-equal? (restart-world (make-world (make-ball 20 645 3 9)
                                        (make-racket 330 384 0 0)
                                        #false
                                        #false
                                        1
                                        1))
                (make-world (make-ball 20 645 3 9)
                            (make-racket 330 384 0 0)
                            #false
                            #false
                            1
                            2)
     "(restart-world World in paused state for less than 3 seconds)
            should return: world in paused state in next tick.")
  (check-equal? (restart-world (make-world (make-ball 20 645 3 9)
                                        (make-racket 330 384 0 0)
                                        #false
                                        #false
                                        1
                                        4))
                (make-world (make-ball 330 384 0 0)
                            (make-racket 330 384 0 0)
                            #true
                            #false
                            1
                            0)
     "(restart-world World in paused state for more than 3 seconds)
            should return: world in ready to serve state."))

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (restart-world w)
  (if (< (* (world-speed w) (world-ticks-passed w)) 3)
           (make-world (world-ball w)
                       (world-racket w)
                       (world-ready-to-serve? w)
                       (world-in-rally? w)
                       (world-speed w)
                       (add1 (world-ticks-passed w)))
           (initial-world (world-speed w))))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-after-tick : World -> World
;; GIVEN:   any world that's possible for the simulation
;; RETURNS: the world that should follow the given world
;;           after a tick

;; EXAMPLES:
;; (world-after-tick WORLD-AFTER-SPACE-KEY)
;;                           => (make-world (make-ball 333 375 3 -9)
;;                                          (make-racket 330 384 0 0)
;;                                          #false #true 1 1)

;; TESTS:
(begin-for-test
  (check-equal? (world-after-tick WORLD-AFTER-SPACE-KEY)
                (make-world (make-ball 333 375 3 -9)
                            (make-racket 330 384 0 0)
                            #false #true 1 1)
     "(world-after-tick WORLD-AFTER-SPACE-KEY)
          should return: World in rally state in the next tick")
  (check-equal? (world-after-tick WORLD-IN-PAUSE-STATE)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 0 0)
                            #false #false 1 1)
     "(world-after-tick WORLD-IN-PAUSE-STATE)
          should return: World in pause state in the next tick"))

;; STRATEGY: Combine Simple Functions
(define (world-after-tick w)
  (if (or (world-ready-to-serve? w)
          (world-in-rally? w))
      (move-world w)
      (restart-world w)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTION TO CREATE SCENES:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; world-to-scene : World -> Scene
;; GIVEN:   a world
;; RETURNS: a Scene that portrays the given world.

;; EXAMPLES:
;; (world-to-scene WORLD-AFTER-SPACE-KEY)
;;                 =>  (place-image BALL SERVE-X-CORD SERVE-Y-CORD
;;                          (place-image RACKET SERVE-X-CORD SERVE-Y-CORD
;;                                            EMPTY-SCENE))

;; TESTS:
;; Example For Testing
(define WORLD-IN-PAUSE-STATE (make-world (make-ball 330 384 3 -9)
                                          (make-racket 330 384 0 0)
                                          #false
                                          #false
                                          1
                                          0))
(begin-for-test
  (check-equal? (world-to-scene WORLD-AFTER-SPACE-KEY)
                (place-image BALL SERVE-X-CORD SERVE-Y-CORD
                    (place-image RACKET SERVE-X-CORD SERVE-Y-CORD
                                        EMPTY-SCENE))
     "(world-to-scene WORLD-AFTER-SPACE-KEY)
           should return: scene in rally state")
  (check-equal? (world-to-scene WORLD-IN-PAUSE-STATE)
                (place-image BALL SERVE-X-CORD SERVE-Y-CORD
                    (place-image RACKET SERVE-X-CORD SERVE-Y-CORD
                                        PAUSED-EMPTY-SCENE))
     "(world-to-scene WORLD-IN-PAUSE-STATE)
           should return: scene in paused state"))

;; STRATEGY: Place the image of the Ball & Racket on an empty canvas
;;             depending on if world state is paused or no.
(define (world-to-scene w)
  (if (or (world-ready-to-serve? w)
          (world-in-rally? w))
      (place-image BALL (ball-x (world-ball w))
                    (ball-y (world-ball w))
                    (place-image RACKET (racket-x (world-racket w))
                                        (racket-y (world-racket w))
                                        EMPTY-SCENE))
      (place-image BALL (ball-x (world-ball w))
                    (ball-y (world-ball w))
                    (place-image RACKET (racket-x (world-racket w))
                                        (racket-y (world-racket w))
                                        PAUSED-EMPTY-SCENE))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS HANDLING KEY EVENTS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; is-space-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a space key.

;; EXAMPLES:
(define SPACE-KEY " ")
;; (is-space-key-event? SPACE-KEY) => #true

;; TESTS:
(begin-for-test
  (check-equal? (is-space-key-event? SPACE-KEY)
                #true
     "(is-space-key-event? SPACE-KEY)
          should return: true"))

;; STRATEGY: Check if given key event string
;;             matches spacebar key event string.
(define (is-space-key-event? ke)
  (key=? ke SPACE-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-left-arrow-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a left arrow key.

;; EXAMPLES:
(define LEFT-ARROW-KEY "left")
;; (is-left-arrow-key-event? LEFT-ARROW-KEY) => #true

;; TESTS:
(begin-for-test
  (check-equal? (is-left-arrow-key-event? LEFT-ARROW-KEY)
                #true
     "(is-left-arrow-key-event? LEFT-ARROW-KEY)
          should return: true"))

;; STRATEGY: Check if given key event string
;;             matches left arrow key event string.
(define (is-left-arrow-key-event? ke)
  (key=? ke LEFT-ARROW-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-right-arrow-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a right arrow key.

;; EXAMPLES:
(define RIGHT-ARROW-KEY "right")
;; (is-right-arrow-key-event? RIGHT-ARROW-KEY) => #true

;; TESTS:
(begin-for-test
  (check-equal? (is-right-arrow-key-event? RIGHT-ARROW-KEY)
                #true
     "(is-right-arrow-key-event? RIGHT-ARROW-KEY)
          should return: true"))

;; STRATEGY: Check if given key event string
;;             matches right arrow key event string.
(define (is-right-arrow-key-event? ke)
  (key=? ke RIGHT-ARROW-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-down-arrow-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a down arrow key.

;; EXAMPLES:
(define DOWN-ARROW-KEY "down")
;; (is-down-arrow-key-event? DOWN-ARROW-KEY) => #true

;; TESTS:
(begin-for-test
  (check-equal? (is-down-arrow-key-event? DOWN-ARROW-KEY)
                #true
     "(is-down-arrow-key-event? DOWN-ARROW-KEY)
          should return: true"))

;; STRATEGY: Check if given key event string
;;             matches down arrow key event string.
(define (is-down-arrow-key-event? ke)
  (key=? ke DOWN-ARROW-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-up-arrow-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a up arrow key.

;; EXAMPLES:
(define UP-ARROW-KEY "up")
;; (is-up-arrow-key-event? UP-ARROW-KEY) => #true

;; TESTS:
(begin-for-test
  (check-equal? (is-up-arrow-key-event? UP-ARROW-KEY)
                #true
     "(is-up-arrow-key-event? UP-ARROW-KEY)
          should return: true"))

;; STRATEGY: Check if given key event string
;;             matches up arrow key event string.
(define (is-up-arrow-key-event? ke)
  (key=? ke UP-ARROW-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-with-space-toggled : World -> World
;; GIVEN:   a world
;; RETURNS: the world that should follow the given world
;;           after the space key is toggled.

;; EXAMPLES:
;; (world-with-space-toggled (initial-world 1))
;;                       => (make-world (make-ball 330 384 3 -9)
;;                                      (make-racket 330 384 0 0)
;;                                      #false
;;                                      #true
;;                                      1
;;                                      0))

;; TESTS:
;; Example For Testing:
(define WORLD-AFTER-SPACE-KEY (make-world (make-ball 330 384 3 -9)
                                          (make-racket 330 384 0 0)
                                          #false
                                          #true
                                          1
                                          0))
(begin-for-test
  (check-equal? (world-with-space-toggled WORLD-AFTER-SPACE-KEY)
                WORLD-IN-PAUSE-STATE))

;; STRATEGY:  Cases on the state of the world
;;            and use Constructor Template for World.
(define (world-with-space-toggled w)
  (cond
    [(world-ready-to-serve? w)
     (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 3 -9)
                 (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
                 (update-serve-ready w)
                 (update-in-rally w)
                 (world-speed w)
                 (world-ticks-passed w))]
    [(world-in-rally? w) (pause-world w)]))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-with-arrow-toggled : World KeyEvent -> World
;; GIVEN:   a world and a KeyEvent
;; RETURNS: the world that should follow the given world
;;           after the arrow key event.

;; EXAMPLES:
;; (world-with-arrow-toggled WORLD-AFTER-SPACE-KEY LEFT-KEY)
;;                  =>  (make-world (make-ball 330 384 3 -9)
;;                                  (make-racket 330 384 -1 0)
;;                                  #false
;;                                  #true
;;                                  1
;;                                  0)

;; TESTS:
(begin-for-test
  (check-equal? (world-with-arrow-toggled (initial-world 1)
                                          ANY-OTHER-KEY)
                (initial-world 1)
      "(world-with-arrow-toggled (initial-world 1))
           should return: (initial-world 1)")
  (check-equal? (world-with-arrow-toggled
                 WORLD-AFTER-SPACE-KEY
                 LEFT-ARROW-KEY)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 -1 0)
                            #false
                            #true
                            1
                            0)
      "(world-with-arrow-toggled (initial-world 1))
           should return: (initial-world 1)"))

;; STRATEGY: Cases on the state of the world
;;            and use Constructor Template for World.
(define (world-with-arrow-toggled w ke)
  (if (world-ready-to-serve? w)
      w
      (make-world (world-ball w)
                  (update-racket-speed (world-racket w) ke)
                  (world-ready-to-serve? w)
                  (world-in-rally? w)
                  (world-speed w)
                  (world-ticks-passed w))))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-after-key-event : World KeyEvent -> World
;; GIVEN:   a world and a KeyEvent
;; RETURNS: the world that should follow the given world
;;           after the given key event.

;; EXAMPLES:
;; (world-after-key-event (initial-world 1) SPACE-KEY)
;;                  =>  (make-world (make-ball 330 384 3 -9)
;;                                  (make-racket 330 384 0 0)
;;                                  #false
;;                                  #true
;;                                  1
;;                                  0)

;; TESTS:
(begin-for-test
  (check-equal? (world-after-key-event (initial-world 1) SPACE-KEY)
                WORLD-AFTER-SPACE-KEY
    "(world-after-key-event
            (World in initial ready to serve state SPACE-KEY)
                should return World in rally state")
  (check-equal? (world-after-key-event
                 WORLD-AFTER-SPACE-KEY
                 LEFT-ARROW-KEY)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 -1 0)
                            #false
                            #true
                            1
                            0)
    "(world-after-key-event
          (World in initial ready to serve state LEFT-ARROW-KEY)
               should return World with decreased vx of racket")
  (check-equal? (world-after-key-event
                 WORLD-AFTER-SPACE-KEY
                 RIGHT-ARROW-KEY)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 1 0)
                            #false
                            #true
                            1
                            0)
    "(world-after-key-event
          (World in initial ready to serve state RIGHT-ARROW-KEY)
               should return World with increased vx of racket")
  (check-equal? (world-after-key-event
                 WORLD-AFTER-SPACE-KEY
                 DOWN-ARROW-KEY)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 0 1)
                            #false
                            #true
                            1
                            0)
    "(world-after-key-event
          (World in initial ready to serve state DOWN-ARROW-KEY)
               should return World with increased vx of racket")
  (check-equal? (world-after-key-event
                 WORLD-AFTER-SPACE-KEY
                 UP-ARROW-KEY)
                (make-world (make-ball 330 384 3 -9)
                            (make-racket 330 384 0 -1)
                            #false
                            #true
                            1
                            0)
    "(world-after-key-event
          (World in initial ready to serve state UP-ARROW-KEY)
               should return World with decreased vy of racket")
  (check-equal? (world-after-key-event
                 WORLD-AFTER-SPACE-KEY
                 ANY-OTHER-KEY)
                (make-world (make-ball 330 384 3 -9)
                             (make-racket 330 384 0 0)
                             #false
                             #true
                             1
                             0)
    "(world-after-key-event
          (World in initial ready to serve state ANY-OTHER-KEY)
               should return World with decreased vy of racket"))

;; STRATEGY: Combine simple functions.
(define (world-after-key-event w kev)
  (cond
    [(is-space-key-event? kev) (world-with-space-toggled w)]
    [(or (is-left-arrow-key-event? kev)
         (is-right-arrow-key-event? kev)
         (is-down-arrow-key-event? kev)
         (is-up-arrow-key-event? kev))
     (world-with-arrow-toggled w kev)]
    [else w]))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAIN FUNCTION:
;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; simulation : PosReal -> World
;; GIVEN:   the speed of the simulation, in seconds per tick
;;            (so larger numbers run slower)
;; EFFECT:  runs the simulation, starting with the initial world
;; RETURNS: the final state of the world

;; EXAMPLES:
;;(simulation 1) runs in super slow motion
;;(simulation 1/24) runs at a more realistic speed

;; STRATEGY: Combine simple functions.
(define (simulation sim-speed)
  (big-bang (initial-world sim-speed)
            (on-key world-after-key-event)
            (on-tick world-after-tick sim-speed)
            (on-draw world-to-scene)))