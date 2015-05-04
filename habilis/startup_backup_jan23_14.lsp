
(define range (lambda (from to)
    (if (= from to)
        ()
        (cons from (range (+ from 1) to)))

    (define temp ())

    (set! to (- to 1))
    (while (>= to from)
        
        (set! temp (cons to temp))
        (set! to (- to 1))
    )
    temp
))



(define function? (lambda (x) (native "isFunction" x)))

(define union append)

(define ** (lambda (a b) (native "Math.pow" a b)))

(define pi (graphics "PI"))

(define save (lambda (file) (graphics "save" file)))

(define filter (lambda (func l)
    (if l
        (if (func (car l))
            (cons (car l) (filter func (cdr l)))
            (filter func (cdr l))
        )
        ()
    )
))



(define class (lambda (members)
	(lambda params

	(for member members
	(defineVar (car member) (cdr member))

    (if params
    	(defineVar (car member) (car params))
        ()
    )
    (set! params (cdr params))
    )

    (object)
	)
	)
)

    (define even? (lambda (x)
        (= (% x 2) 0)))


(define xor (lambda (x y)
    (if (and (or x y) (!= x y))
        (= 0 0)
        (= 1 0)
    )))


(define False (= 0 1))
(define True (= 1 1))
(define null ())
(define and (lambda (x y) 
    (if (= x y) 
        (if (= x (= 0 0))
        (= 0 0) 
        (= 1 0))
    (= 1 0)
    )))

(define or (lambda (x y) 
    (if (= x (= 0 0))
        (= 0 0)
        (if (= y (= 0 0))
            (= 0 0)
            (= 0 1)
        )
    )
))



(define integrate (lambda (func start stop tolerance)
    (if (= tolerance NULL)
         (define tolerance .01)
         ()
    )
    
    (define deltaArea 100)
    (define deltaX .1)
    (define areaOld 0)
    (define areaNew 0)
    (while (> deltaArea tolerance)
        (define position start)
        (set! areaNew 0)
        (while (<= position stop)
    (define simpsons (* (/ deltaX 6) 
    (func position)
    (* 4 (func (+ position (/ deltaX 2))))
    (func (+ position deltaX))))

            (set! areaNew (+ areaNew simpsons))
            (set! position (+ position deltaX))
        )
        
        (set! deltaX (/ deltaX 2))
        (set! deltaArea (abs (- areaOld areaNew)))
        (set! areaOld areaNew)
    )
    areaOld
))

(define rect (lambda (x y h w) (graphics "rect" x y h w)))

(define line (lambda (x y x2 y2) (graphics "line" x y x2 y2)))

(define sphere (lambda (r) (graphics "sphere" r)))

(define point (lambda (x y) (graphics "point" x y)))

(define circle (lambda (x y r) (graphics "ellipse" x y (* r 2)(* r 2) )))

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


(define color (lambda (r g b) (graphics "color" r g b)))
(define background-color (color 211 222 222))
(define erase (lambda () (graphics "background" background-color)))
(define stroke (lambda (color) (graphics "stroke" color)))
(define fill (lambda (color) (graphics "fill" color)))
(define background (lambda (color) (graphics "background" color)))

(define translate (lambda (x y) 
    (if (= y ())
        (begin (define y x)
               (define x 0))
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
    (translate (/ (graphics "width") 2) (/ (graphics "height") 2))
    (rotate pi)
    (scale -1 1)))


(define red (color 255 0 0))
(define green (color 0 255 0))
(define blue (color 0 0 255))
(define white (color 255 255 255))
(define black (color 0 0 0))
(define yellow (color 255 255 0))
(define orange (color 255 165 0))





(define differentiate (lambda (func)
    (if (= func cos) (return (lambda (x) (sin (- x)))) ())
    (if (= func sin) (return (lambda (x) (cos x))) ())
    (if (= func e) (return (lambda (x) (e x))) ())
    (if (= func ln) (return (lambda (x) (/ 1 x))) ())
    
    (define deltaX 0.001)
    (lambda (x)
        (/ (- (func (+ x deltaX)) (func (- x deltaX))) (* 2 deltaX))
    )
))

#Interesting Equations
(define E (lambda (mantissa exp) (* mantissa (** 10 exp))))
(define choose (lambda (n k) (/ (perm n k) (fact k))))
(define perm (lambda (n k) (/ (fact n) (fact (- n k)))))
(define fact (lambda (x) (if (= x 0) 1 (* x (fact (- x 1))))))

(define normalDistribution (lambda (mew siqma)
    (lambda (x)
        (* (/ 1 (sqrt (** siqma 2) pi 2)) (e (- (/ (** (- x mew) 2) (* 2 (** siqma 2))))))
    )
    )
)
(define random rand)
(define arctan (lambda (x) (native "Math.atan" x)))
(define arcsine (lambda (x) (native "Math.asin" x)))
(define arccos (lambda (x) (native "Math.acos" x)))
(define degrees 
    (lambda (x) 
        (* x (/ 180 pi))
    )
)
(define rads (lambda (x) (* x (/ pi 180))))
(define SHM (lambda (amplitude omega phi) (lambda (x) (* amplitude (cos (+ (* omega x) phi))))))
(define SHM_PERIOD (lambda (k m)
    (if (= m NULL)s
        (/ 1 k)
        (/ (sqrt (/ k m)) (* 2 pi))
    )
))

(define SHM_FREQ (lambda (k m) 
    (if (= m NULL)
        (/ 1 k)
        (/ 1 (SHM_PERIOD k m))
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








(lambda ()
(pad 0 -3)

(pad 3.5 -3)

(pad 7.5 -3)


(pad 0 0)

(pad 3.5 0)

(pad 7.5 0)
)



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



(define coolCircles (lambda (param)
(for x (filter even? (range -100 100))
        (set! x (* x param))
        (circles x (sqrt (+ (** 200 2) (** x 2))) 50 10)
        (circles x (- (sqrt (+ (** 200 2) (** x 2)))) 50 10)
)
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

(define circlesAndHearts (lambda ()
(background (color 0x13 0x4C 0x69))

(stroke (color 0xFF 0xEC 00))



(coolCircles 100)


(rotate (/ pi 2))

(coolCircles 50)

(resetMatrix)
(translate 210)
(hearts 10 -30 30 15 .1 .1)
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














































(print "*Cilaule")

(reset)





