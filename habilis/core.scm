
"Various useful functions"


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


(define xor (lambda (x y)
    (if (and (or x y) (!= x y))
        (= 0 0)
        (= 1 0)
    )))



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

(define max (lambda (x y)
    (if (>= x y)
        x
        y)
))

(define min (lambda (x y)
    (if (<= x y)
        x
        y)
))

(define even? (lambda (x)
    (= (% x 2) 0)))

(define filter (lambda (func l)
    (if l
        (if (func (car l))
            (cons (car l) (filter func (cdr l)))
            (filter func (cdr l))
        )
        ()
    )
))

(define list? (lambda (x) 
    (if (= x ())
        (return true))
    (if (pair? x)
        (print (+ x " is a pair")))

    (return false)
))

(define equal? (lambda (x)))
    


(define function? (lambda (x) (native "isFunction" x)))

(define union append)

(define repeat (lambda (str num) (map (lambda (x) str) (range 0 num))))

(define array-list (lambda (arr)
    (define tempList ())
    (for l (range (length arr) 0)
        (set! tempList (cons arr[l] tempList)))
    tempList
))

(define list-length (lambda (l)
    (if (!= l null)
        (+ 1 (list-length (cdr l)))
        0
    )
))

(define length (lambda (thing)
    (if (= thing[-1] "habilisArray")
        (array-length thing)
        (list-length thing)
    )
))

(define range (lambda (from to)
    (if (< to from)
        (return (rev-range from to))
    )
    (define temp ())

    (set! to (- to 1))
    (while (>= to from)
        
        (set! temp (cons to temp))
        (set! to (- to 1))
    )
    temp
))

(define rev-range (lambda (from to)
    (define temp ())
    (set! from (- from 1))

    (while (<= to from)
        (set! temp (cons to temp))
        (set! to (+ to 1))
    )
    temp
))






(define Queue (lambda ()
    (define handle ())
    (define len 0)
    (define size (lambda ()
        len
    ))
    (define push (lambda (e)
        (set! handle (cons e handle))
        (set! len (+ len 1))
    ))
    (define pop (lambda (e)
        (if (> len 0) (begin
        (define temp (car handle))
        (set! handle (cdr handle))
        (set! len (- len 1))
        temp
        ))
    ))
    (lambda)
))



(define PriorityQueue (lambda (orderer)
    (define handle ())
    (define push (lambda (e)
        (set! handle (cons e handle))
    ))
    (define size (lambda ()
        (length handle)
    ))

    (define contains (lambda (e proc)
        (in (proc e) (map proc handle))
    ))

    (define pop (lambda (e)
        (define best ())
        (if (> (length handle) 0) 
            (begin
            (set! best (car handle))
            (for x handle
                (if (< (orderer x) (orderer best))
                    (set! best x)
                )
            )
            (set! handle (filter (lambda (x) (!= x best)) handle))
            )
        (print "Nothing to pop")
        )
        best)
    )
    (lambda)
))












