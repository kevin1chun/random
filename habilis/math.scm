
"Math support functions"



(define normalDistribution (lambda (mew siqma)
    (lambda (x)
        (* (/ 1 (sqrt (** siqma 2) pi 2)) (e (- (/ (** (- x mew) 2) (* 2 (** siqma 2))))))
    )
    )
)

(define ** (lambda (a b) (native "Math.pow" a b)))
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

(define E (lambda (mantissa exp) (* mantissa (** 10 exp))))
(define choose (lambda (n k) (/ (perm n k) (fact k))))
(define perm (lambda (n k) (/ (fact n) (fact (- n k)))))
(define fact (lambda (x) (if (= x 0) 1 (* x (fact (- x 1))))))




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











