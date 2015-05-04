


"Additional Functions constants and support for the processing.js graphics library"



(define rect (lambda (x y h w) (graphics "rect" x y h w)))

(define line (lambda (x y x2 y2) (graphics "line" x y x2 y2)))

(define sphere (lambda (r) (graphics "sphere" r)))

(define point (lambda (x y) (graphics "point" x y)))

(define circle (lambda (x y r) (graphics "ellipse" x y (* r 2)(* r 2) )))

(define sphere (lambda (r) (graphics "sphere" r)))

(define box (lambda (w h d) (graphics "box" w h d)))

(define pixelSize 0.3528)

(define pad (lambda (x y) (rect x y (* pixelSize 2) (* pixelSize 20)))) 


(define part1 (lambda (theta)
	(/ (* (sin theta) (sqrt (abs (cos theta)))) (+ (sin theta) 1.4)))
)
(define heart (lambda (theta)
	(+ 2 (- (* 2 (sin theta))) (part1 theta))))

(define graphPolarPoints (lambda (func start stop dx scale) 
    (while (< start stop)
        
        (graphics "point"  (* scale (* (cos start) (func start))) (* scale (* (sin start) (func start)))
            )
        (set! start (+ start dx))
    )
))

(define graphParametric (lambda (funcX funcY start stop dx scale) 

    (while (< start stop)
        (graphics "line"  (* scale (funcX start)) (* scale (funcY start))  (* scale (funcX (+ dx start))) (* scale (funcY (+ dx start))))
        (set! start (+ start dx))
    )
))


(define drawAxis (lambda (color1 color2)
    (stroke color1)
    (graph () (- width) width width 1)
    (stroke color2)
    (graphY () (- height) height height 1)
))


(define drawGrid (lambda (scale color1 color2)
    (define start (- width))
    (if (= color1 ())
        (define color1 (color 0 0 0 100))
        ()
    )
    (if (= color2 ())
        (define color2 color1)
        ()
    )
    (stroke color1)
    (while (< start width)
        (graphics "line"  (- width) start width start)
        (set! start (+ start scale))
    )
    (stroke color2)
    (set! start (- height))
    (while (< start height)
        (graphics "line"  start (- height) start height )
        (set! start (+ start scale))
    )

))


(define graphPolarLines (lambda (func start stop dx scale) 
    (while (< start stop)
        
        (graphics "line"  (* scale (* (cos start) (func start))) (* scale (* (sin start) (func start)))
            (* scale (* (cos start) (func (+ start dx)))) (* scale (* (sin start) (func (+ start dx)))))
        (set! start (+ start dx))
    )
))
(define graphPolar graphPolarPoints)
(define graph (lambda (func start stop dx scale) 
    (while (< start stop)
        (graphics "line"  (* scale start) (* scale (func start)) (* scale (+ start dx)) (* scale (func (+ start dx))))
        (set! start (+ start dx))
    )
))

(define graphY (lambda (func start stop dy scale) 
    (while (< start stop)
        (graphics "line"  (* scale (func start)) (* scale start) (* scale (func (+ start dy))) (* scale (+ start dy)))
        (set! start (+ start dy))
    )
))


(define width (graphics "width"))

(define height (graphics "height"))


(define color (lambda (r g b a)
    (if (and (= a "a") (= b ()) (= g ()))
        (graphics "color" r)
        (if (= a "a")
            (graphics "color" r g b)
            (graphics "color" r g b a)
        )
    )
)
)
(define camera (lambda () (graphics "camera")))
(define lights (lambda () (graphics "lights")))
(define background-color (color 211 222 222))
(define erase (lambda () (graphics "background" background-color)))
(define stroke (lambda (color) (graphics "stroke" color)))
(define fill (lambda (color) (graphics "fill" color)))
(define background (lambda (color) (graphics "background" color)))

(define translate (lambda (x y z) 
    (if (= y "y")
        (begin (define y x)
               (define x 0))
        ())
    (if (= z "z")
        (define z 0)
        ())

    (graphics "translate" x y)))
(define rotate (lambda (rads) (graphics "rotate" rads)))
(define rotateX (lambda (rads) (graphics "rotateX" rads)))
(define rotateY (lambda (rads) (graphics "rotateY" rads)))
(define rotateZ (lambda (rads) (graphics "rotateZ" rads)))

(define scale (lambda (x y)
    (if (= y NULL) (set! y 1) ())
    (graphics "scale" x y)))

(define resetMatrix (lambda ()
    (graphics "resetMatrix")
    (translate (/ (graphics "width") 2) (/ (graphics "height") 2))
    (rotate pi)
    (scale -1 1)))

(define reset (lambda ()
    (clearIntervals)
    (erase)
    (stroke black)
    (graphics "resetMatrix")
    (camera)
    (lights)
    (translate (/ (graphics "width") 2) (/ (graphics "height") 2) 0)
    (scale -1 1)
    (rotate pi)

))


(define red (color 255 0 0))
(define green (color 0 255 0))
(define blue (color 0 0 255))
(define white (color 255 255 255))
(define black (color 0 0 0))
(define yellow (color 255 255 0))
(define orange (color 255 165 0))








(define circles (lambda (x y d limit)
    (if (!= limit 0)
    (begin
    (circle x y d)
    (circles (* x .5) (* y .5) (* d .4) (- limit 1))
    )
    ())))

(define hearts (lambda (limit start stop stretch inc dec)
    (if (> limit 0)
    (begin
    (graphPolar heart start stop inc (* stretch limit))

    (hearts (- limit dec) start stop stretch inc dec)
    )
    ())))

(define exampleHeart (lambda ()
(print "Drawing a heart in polar coordinates. ")
(translate 0 200)
(graphPolar heart 0 2pi .01 100)
(translate 0 -200)
))



(define coolCircles (lambda (param)
(for x (filter even? (range -100 100))
        (set! x (* x param))
        (circles x (sqrt (+ (** 200 2) (** x 2))) 50 10)
        (circles x (- (sqrt (+ (** 200 2) (** x 2)))) 50 10)
)
))


(define pi (graphics "PI"))
(define 2pi (* 2 (graphics "PI")))


(define save (lambda (file) (graphics "save" file)))






" These are just fun examples of what can be done"

(define animateA (lambda (x)
    (lambda ())))

(define animateA.tick (lambda ()
    (stroke black)
    (set! this.x (+ this.x (- 10 (rand 0 20))))
    (coolCircles this.x)
))

(define exampleHeartA (lambda ()
    (print "Drawing a heart in polar coordinates. ")
    (translate 0 200)
    (graphPolar heart 0 2pi .01 100)
    (translate 0 -200)
))

(define animateA (animate 10))

(define hA (lambda () 
(interval animateA.tick 500)
))

(define animate (lambda (x)
    (lambda ())))

(define animate.tick (lambda ()
    (stroke black)
    (set! this.x (+ this.x (- 10 (rand 0 20))))
    (coolCircles this.x)
))


(define animateCircles (animate 10))
(define circleShow (lambda () 
(interval animateCircles.tick 500)
))

(define thickLine (lambda (limit)
    (if (>= limit 2)
        (begin
            (graph (lambda (x) 
            (if (> (abs x) 27)
                (- limit)
                (/ 1 0)))
             -100 100 .1 1)
            (graph (lambda (x) 
            (if (> (abs x) 27)
                limit
                (/ 1 0)))
             -100 100 .1 1)
            (thickLine (- limit 1))
        )
        
        ()
    )
))

(define pokeball (lambda ()
    (thickLine 10)

    (graphPolar ln -360 360 .01 20)
    (graphPolar sqrt -360 360 .1 1.5)
)
)

(define radialHeart (lambda () (hearts 10 -30 30 15 .1 .1)))

(define coolerCircles (lambda ()
(background (color 0x13 0x4C 0x69))

(stroke (color 0xFF 0xEC 00))



(coolCircles 100)


(rotate (/ pi 2))

(coolCircles 50)

(resetMatrix)
(translate 210)

))

(define box (lambda (x y w h)
    (lambda ())))

(define box.tick (lambda (c)  
    (stroke c)

    (set! this.x (+ this.x (- 1 (rand 0 2.1))))
    (set! this.y (+ this.y (- 1 (rand 0 2))))
))
(define box.draw (lambda (c)  
(rect this.x this.y this.w this.h)
(this.tick c)
))

(define markov (lambda (c) 

(define markovBox (box 0 0 5 5))
(interval (lambda (c) (markovBox.draw c) ) 10)

))

(define randomLines (lambda (x)

    (for i (range 0 x)
        (stroke (color (random 255) (random 255) (random 255)))
        (line (- width (rand (* 2 width))) 
            (- height (rand (* 2 height)))
            (- width (rand (* 2 width))) 
            (- height (rand (* 2 height))))
    )
))


(define list-circles (lambda (l x deltaX rad)
    (if (= null l)
        ()
        (begin 
            (fill (color (random 0 255) (random 0 255) (random 0 255)))
            (circle x (- (/ (- height 100) 2) (random 0 (- height 100))) rad)
            (list-circles (cdr l) (+ x deltaX) deltaX rad)
        )
    )
))



(define sineShow (lambda () 
    (define shift 0)
    (interval (lambda ()
    (erase)
    (graph (lambda (x) (sin (* x shift))) -100 100 .1 100) 
    (set! shift (+ shift 0.5))
    ) 100)))

(define eSpiral (lambda () 
    (define shift 0)
    (interval (lambda ()

    (graph (lambda (x) (e (* x shift))) -100 100 .1 100) 
    (set! shift (+ shift 0.5))
    ) 0)))

(define moveRect (lambda () 
    (define shift 0)
    (interval (lambda ()
    (erase)
    (rect shift shift 100 100)

    (set! shift (+ shift 1))
    ) 0)))



(define 1d-heat (lambda () 
(define rod (array))

(for i (range 0 100)
    (set rod i (* (rand 7) i) )
)

(define draw-rod (lambda (rod)
    (erase)
    (define y 0)
    (define x -500)
    (for i (range 0 (length rod))
        (fill (color rod[i]))
        (rect x y 20 20)
        (set! x (+ x 10))


    )
    )
)



(define update-rod (lambda (array)
    (for i (range 1 (- (length rod) 1))
        (set array i (/ (+ array[(- i 1)] array[(+ i 1)] array[i]) 3) )
    )
))




(interval (lambda ()
(update-rod rod)
(draw-rod rod)
    ) 1000)
)
)


(reset)

