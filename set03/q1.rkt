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
;; is pressed.


(define BALL (circle 3 "solid" "black"))
(define RACKET (rectangle 47 7 "solid" "green"))
(define RACKET-MID-LENGTH (/ (image-width RACKET) 2))
(define COURT-X-CORD 425)
(define COURT-Y-CORD 649)
(define SERVE-X-CORD 330)
(define SERVE-Y-CORD 384)
(define EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD))
(define PAUSED-EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD "yellow"))



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
;; (make-world ball racket serve-ready? in-rally? speed ticks-passed)
;;  with the following fields:
;;     ball         : Ball       is the ball in the world.
;;     racket       : Racket     is the Racket in the world.
;;     serve-ready? : Boolean    represents if the world is in a
;;                                ready to serve state.
;;     in-rally?    : Boolean    represents if the world is in a
;;                                 rally state.
;;     speed        : NonNegReal is the speed of the simulation
;;                                 given by the user.
;;     ticks-passed : PosInt     is the number of ticks that have passed
;;                                 in a non-paused or paused state.

;; IMPLEMENTATION:
(define-struct world
  (ball racket serve-ready? in-rally? speed ticks-passed))

;; CONSTRUCTOR TEMPLATE:
;; (make-world Ball Racket Boolean Boolean NonNegReal PosInt)

;; OBSERVER TEMPLATE:
;; world-fn: World -> ?
;; (define (world-ball world)
;;    (... (world-racket world)
;;         (world-serve-ready? world)
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

;; EXAMPLE:
;;(initial-world 1)

;; STRATEGY: Use Constructor Template for World.
(define (initial-world sim-speed)
  (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 0 0)
              (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
              #true
              #false
              sim-speed
              0))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-ready-to-serve? : World -> Boolean
;; GIVEN:   a world
;; RETURNS: true iff the world is in its ready-to-serve state.

;; STRATEGY: Use Observer Template for World
;;             on world-serve-ready?.
(define (world-ready-to-serve? w)
  (world-serve-ready? w))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-serve-ready : World -> Boolean
;; GIVEN:   a world
;; RETURNS: true iff the world is not in its ready-to-serve state.

;; STRATEGY: Use Observer Template for World
;;             on world-serve-ready?.
(define (update-serve-ready w)
  (not (world-serve-ready? w)))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-in-rally : World -> Boolean
;; GIVEN:   a world
;; RETURNS: true iff the world is not in a rally state.

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

;; STRATEGY: Cases on if ball hits walls along the y-axis.
(define (update-racket-y racket)
  (cond
    [(racket-hitting-top-wall? racket)
         (racket-y racket)]
    [(racket-hitting-bottom-wall? racket)
         (racket-y racket)]
    [else (+ (racket-y racket) (racket-vy racket))]))

;; CONTRACT & PURPOSE STATEMENTS:
;; update-racket-vx : Racket KeyEvent -> Real
;; GIVEN:   a racket and a KeyEvent
;; RETURNS: the x-component of the velocity
;;             of the racket in the next tick.

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
;; FUNCTIONS MANIPULATING STATES OF THE World:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONTRACT & PURPOSE STATEMENTS:
;; move-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world in the next tick.

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (move-world w)
  (if (or (ball-hitting-bottom-wall? (world-ball w))
         (racket-hitting-top-wall? (world-racket w)))
      (pause-world w)
      (make-world (move-ball (world-ball w) (world-racket w))
                  (move-racket (world-ball w) (world-racket w))
                  (world-serve-ready? w)
                  (world-in-rally? w)
                  (world-speed w)
                  (add1 (world-ticks-passed w)))))

;; CONTRACT & PURPOSE STATEMENTS:
;; pause-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world in the paused state.

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (pause-world w)
  (make-world (world-ball w)
              (world-racket w)
              (world-serve-ready? w)
              (update-in-rally w)
              (world-speed w)
              0))

;; CONTRACT & PURPOSE STATEMENTS:
;; restart-world : World -> World
;; GIVEN:   a world
;; RETURNS: the same world after the paused state.
;;             Same world withing the first 3 seconds of paused state.
;;             World in ready to serve state after 3 seconds pause.

;; STRATEGY: Divide into simple functions
;;             and Use Constructor Template for World.
(define (restart-world w)
  (if (< (* (world-speed w) (world-ticks-passed w)) 3)
           (make-world (world-ball w)
                       (world-racket w)
                       (world-serve-ready? w)
                       (world-in-rally? w)
                       (world-speed w)
                       (add1 (world-ticks-passed w)))
           (initial-world (world-speed w))))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-after-tick : World -> World
;; GIVEN:   any world that's possible for the simulation
;; RETURNS: the world that should follow the given world
;;           after a tick

;; STRATEGY: Combine Simple Functions
(define (world-after-tick w)
  (if (or (world-serve-ready? w)
          (world-in-rally? w))
      (move-world w)
      (restart-world w)))

;; CONTRACT & PURPOSE STATEMENTS:
;; world-to-scene : World -> Scene
;; GIVEN:   a world
;; RETURNS: a Scene that portrays the given world.

;; EXAMPLE:

;; STRATEGY: Place the image of the Ball & Racket on an empty canvas
;;             depending on if world state is paused or no.
(define (world-to-scene w)
  (if (or (world-serve-ready? w)
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


;; CONTRACT & PURPOSE STATEMENTS:
;; is-space-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a space key.

;; EXAMPLES:
(define SPACE-KEY " ")

;; STRATEGY: Check if given key event string
;;             matches spacebar key event string.
(define (is-space-key-event? ke)
  (key=? ke PAUSE-KEY))

;; CONTRACT & PURPOSE STATEMENTS:
;; is-left-arrow-key-event? : KeyEvent -> Boolean
;; GIVEN:   a KeyEvent
;; RETURNS: true iff the KeyEvent represents a left arrow key.

;; EXAMPLES:
(define LEFT-ARROW-KEY "left")

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

;; STRATEGY: Check if given key event string
;;             matches up arrow key event string.
(define (is-up-arrow-key-event? ke)
  (key=? ke UP-ARROW-KEY))

(define (world-with-space-toggled w)
  (if (world-ready-to-serve? w)
      (make-world (make-ball SERVE-X-CORD SERVE-Y-CORD 3 -9)
                  (make-racket SERVE-X-CORD SERVE-Y-CORD 0 0)
                  (update-serve-ready w)
                  (update-in-rally w)
                  (world-speed w)
                  (world-ticks-passed w))
      (if (world-in-rally? w)
          (pause-world w)
          w)))


(define (world-with-arrow-toggled w ke)
  (if (world-ready-to-serve? w)
      w
      (make-world (world-ball w)
                  (update-racket-speed (world-racket w) ke)
                  (world-serve-ready? w)
                  (world-in-rally? w)
                  (world-speed w)
                  (world-ticks-passed w))))

(define (world-after-key-event w kev)
  (cond
    [(is-space-key-event? kev) (world-with-space-toggled w)]
    [(or (is-left-arrow-key-event? kev)
         (is-right-arrow-key-event? kev)
         (is-down-arrow-key-event? kev)
         (is-up-arrow-key-event? kev))
     (world-with-arrow-toggled w kev)]
    [else w]))

;; CONTRACT & PURPOSE STATEMENTS:
;; simulation : PosReal -> World
;; GIVEN:   the speed of the simulation, in seconds per tick
;;            (so larger numbers run slower)
;; EFFECT:  runs the simulation, starting with the initial world
;; RETURNS: the final state of the world

;; EXAMPLES:
;;(simulation 1) runs in super slow motion
;;(simulation 1/24) runs at a more realistic speed

;; STRATEGY:
(define (simulation sim-speed)
  (big-bang (initial-world sim-speed)
            (on-key world-after-key-event)
            (on-tick world-after-tick sim-speed)
            (on-draw world-to-scene)))