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

(define BALL (circle 3 "solid" "black"))
(define RACKET (rectangle 47 7 "solid" "green"))
(define RACKET-MID-LENGTH (/ (image-width RACKET) 2))
(define COURT-X-CORD 425)
(define COURT-Y-CORD 649)
(define SERVE-X-CORD 330)
(define SERVE-Y-CORD 384)
(define EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD))
(define PAUSED-EMPTY-SCENE (empty-scene COURT-X-CORD COURT-Y-CORD "yellow"))

(define-struct ball (x y vx vy))
(define-struct racket (x y vx vy))
(define-struct world (ball racket serve-ready? in-rally? speed ticks-passed))


;; CONTRACT & PURPOSE STATEMENTS:
;; initial-world : PosReal -> World
;; GIVEN:   the speed of the simulation, in seconds per tick
;;            (so larger numbers run slower)
;; RETURNS: the ready-to-serve state of the world

;; EXAMPLE:
;;(initial-world 1)

;; STRATEGY:
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
;; RETURNS: true iff the world is in its ready-to-serve state

;; STRATEGY:
(define (world-ready-to-serve? w)
  (world-serve-ready? w))


(define (update-serve-ready w)
  (not (world-serve-ready? w)))

(define (update-in-rally w)
  (not (world-in-rally? w)))


(define (ball-hitting-left-wall? ball)
  (<= (+ (ball-x ball) (ball-vx ball)) 0))

(define (ball-hitting-right-wall? ball)
  (>= (+ (ball-x ball) (ball-vx ball)) COURT-X-CORD))

(define (ball-hitting-top-wall? ball)
  (<= (+ (ball-y ball) (ball-vy ball)) 0))

(define (ball-hitting-bottom-wall? ball)
  (>= (+ (ball-y ball) (ball-vy ball)) COURT-Y-CORD))

(define (ball-hitting-racket? ball racket)
  (and (= (+ (ball-y ball) (ball-vy ball))
          (racket-y racket))
       (<= (+ (ball-x ball) (ball-vx ball))
           (+ (racket-x racket) RACKET-MID-LENGTH))
       (>= (+ (ball-x ball) (ball-vx ball))
           (- (racket-x racket) RACKET-MID-LENGTH))))

(define (update-ball-x ball)
  (cond
    [(ball-hitting-left-wall? ball)
         (* (+ (ball-x ball) (ball-vx ball)) -1)]
    [(ball-hitting-right-wall? ball)
         (- (* 2 COURT-X-CORD) (+ (ball-x ball) (ball-vx ball)))]
    [else (+ (ball-x ball) (ball-vx ball))]))

(define (update-ball-y ball)
  (cond
    [(ball-hitting-top-wall? ball)
     (* (+ (ball-y ball) (ball-vy ball)) -1)]
    [else (+ (ball-y ball) (ball-vy ball))]))

(define (update-ball-vx ball)
  (if (or (ball-hitting-left-wall? ball)
          (ball-hitting-right-wall? ball))
      (* -1 (ball-vx ball))
      (ball-vx ball)))

(define (update-ball-vy ball)
  (cond
    [(ball-hitting-top-wall? ball)
     (* -1 (ball-vy ball))]
    [else (ball-vy ball)]))

(define (move-ball ball racket)
  (if (ball-hitting-racket? ball racket)
      (make-ball (update-ball-x ball)
                 (ball-y ball)
                 (update-ball-vx ball)
                 (- (racket-vy racket) (ball-vy ball)))
      (make-ball (update-ball-x ball)
                 (update-ball-y ball)
                 (update-ball-vx ball)
                 (update-ball-vy ball))))

(define (racket-hitting-left-wall? racket)
  (<= (- (+ (racket-x racket)
            (racket-vx racket))
         RACKET-MID-LENGTH)
      0))

(define (racket-hitting-right-wall? racket)
  (>= (+ (racket-x racket)
         (racket-vx racket)
         RACKET-MID-LENGTH)
      COURT-X-CORD))

(define (racket-hitting-top-wall? racket)
  (<= (+ (racket-y racket) (racket-vy racket)) 0))

(define (racket-hitting-bottom-wall? racket)
  (>= (+ (racket-y racket) (racket-vy racket)) COURT-Y-CORD))

(define (update-racket-x racket)
  (cond
    [(racket-hitting-left-wall? racket)
         RACKET-MID-LENGTH]
    [(racket-hitting-right-wall? racket)
         (- COURT-X-CORD RACKET-MID-LENGTH)]
    [else (+ (racket-x racket) (racket-vx racket))]))

(define (update-racket-y racket)
  (cond
    [(racket-hitting-top-wall? racket)
         (racket-y racket)]
    [(racket-hitting-bottom-wall? racket)
         (racket-y racket)]
    [else (+ (racket-y racket) (racket-vy racket))]))

(define (update-racket-vx racket ke)
  (cond
    [(is-left-arrow-key-event? ke) (sub1 (racket-vx racket))]
    [(is-right-arrow-key-event? ke) (add1 (racket-vx racket))]
    [else (racket-vx racket)]))

(define (update-racket-vy racket ke)
  (cond
    [(is-up-arrow-key-event? ke) (sub1 (racket-vy racket))]
    [(is-down-arrow-key-event? ke) (add1 (racket-vy racket))]
    [else (racket-vy racket)]))

(define (update-racket-speed racket kev)
  (make-racket (racket-x racket)
               (racket-y racket)
               (update-racket-vx racket kev)
               (update-racket-vy racket kev)))


(define (move-racket ball racket)
  (if (and (ball-hitting-racket? ball racket)
           (< (racket-y racket) 0))
      (make-racket (update-racket-x racket)
                   (update-racket-y racket)
                   (racket-vx racket)
                   0)
      (make-racket (update-racket-x racket)
                   (update-racket-y racket)
                   (racket-vx racket)
                   (racket-vy racket))))

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


(define (pause-world w)
  (make-world (world-ball w)
              (world-racket w)
              (world-serve-ready? w)
              (update-in-rally w)
              (world-speed w)
              0))

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

;; STRATEGY:
(define (world-after-tick w)
  (if (or (world-serve-ready? w)
          (world-in-rally? w))
      (move-world w)
      (restart-world w)))


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

(define (is-space-key-event? ke)
  (key=? ke " "))

(define (is-left-arrow-key-event? ke)
  (key=? ke "left"))

(define (is-right-arrow-key-event? ke)
  (key=? ke "right"))

(define (is-down-arrow-key-event? ke)
  (key=? ke "down"))

(define (is-up-arrow-key-event? ke)
  (key=? ke "up"))

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