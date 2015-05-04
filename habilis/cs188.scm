

"Search Functions for CS188"




"Search Node (node steps currentCost)"
(define createSearchNode (lambda (node steps costCurrent)
    (list node steps costCurrent)))

(define getNode (lambda (searchNode)
    (car searchNode)
    ))

(define getSteps (lambda (searchNode)
    (car (cdr searchNode))))

(define getCost (lambda (searchNode)
    (car (cdr (cdr searchNode)))))

(define addStep (lambda (new steps)
    (cons new steps)))




(define problem (class "start" "goal?" "available" "order"))



(define uniformCostSearch (lambda (goal)
    "In this problem states are represented by a pair (state cost)"
    (define goalState goal)

    (define start 0)

    (define goal? (lambda (state)
        (= state goalState)
    ))
    (define available (lambda (state)
        (list (createSearchNode (** (getNode state) 2) (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                (createSearchNode (+ (getNode state) 1) (addStep (getNode state) (getSteps state)) (+ 1 (getCost state)))
        )
    ))
    (define cost (lambda (lastState nextState)
        (+ (getCost lastCost) (getCost nextCost))
    ))
    (define order (lambda (state)
        (getCost state)
    ))
    (lambda)
))

(define greedy (lambda (goal)
    "In this problem states are represented by a pair (state cost)"
    (define goalState goal)
    (define h (lambda (x)

        (abs (- goalState x))
    ))
    (define start 0)

    (define goal? (lambda (state)
        (= state goalState)
    ))
    (define available (lambda (state)
        (list (createSearchNode (** (getNode state) 2) (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                (createSearchNode (+ (getNode state) 1) (addStep (getNode state) (getSteps state)) (+ 1 (getCost state)))
        )
    ))
    (define cost (lambda (lastState nextState)
        (+ (getCost lastCost) (getCost nextCost))
    ))
    (define order (lambda (state)
        (h (getNode state))
    ))
    (lambda)
))

(define aStarSearch (lambda (goal)
    "In this problem states are represented by a pair (state cost)"
    (define goalState goal)
    (define h (lambda (x)
        (/ (abs (- goalState x)) 3)
    ))
    (define start 0)

    (define goal? (lambda (state)
        (= state goalState)
    ))
    (define available (lambda (state)
        (list (createSearchNode (** (getNode state) 2) (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                (createSearchNode (+ (getNode state) 1) (addStep (getNode state) (getSteps state)) (+ 1 (getCost state)))
        )
    ))
    (define cost (lambda (lastState nextState)
        (+ (getCost lastCost) (getCost nextCost))
    ))
    (define order (lambda (state)
        (+ (getCost state) (h (getNode state)))
    ))
    (lambda)
))





(define tree-search (lambda (problem limit)
    
    (define originalLimit limit)
    (define fringe (PriorityQueue problem.order))
    (define closed ())
    (fringe.push (createSearchNode problem.start () 0))
    (while (and (> limit 0) (> (fringe.size) 0))
        (print (+ "Evaluated: " (- originalLimit limit) " nodes."))
        (set! limit (- limit 1))
        (define leaf (fringe.pop))

        (if (problem.goal? (getNode leaf))
            (return (problem.returnState leaf)))

        (if (not (in (getNode leaf) closed))
            (begin 
                (map (lambda (state)

                    (fringe.push state)
                ) (problem.available leaf))
                (set! closed (cons (getNode leaf) closed))
            )
        )


    )
    (if (<= limit 0)
        (print "Max depth Reached"))
    ()
))


(define graph-search (lambda (problem limit)
    
    (define originalLimit limit)
    (define fringe (PriorityQueue problem.order))
    (define closed ())
    (fringe.push (createSearchNode problem.start () 0))
    (while (and (> limit 0) (> (fringe.size) 0))
        (print (+ "Evaluated: " (- originalLimit limit) " nodes."))
        (set! limit (- limit 1))
        (define leaf (fringe.pop))

        (if (problem.goal? (getNode leaf))
            (return (problem.returnState leaf)))

        (if (not (in (getNode leaf) closed))
            (begin 
                (map (lambda (state)
                    (if (not (fringe.contains state problem.fringeEq))
                    (fringe.push state))
                ) (problem.available leaf))
                (set! closed (cons (getNode leaf) closed))
            )
        )


    )
    (if (<= limit 0)
        (print "Max depth Reached"))
    ()
))




(define hw1-2 (lambda ()
    (enum A B C D E F G)

    (define fringeEq (lambda (state)
        (getNode state)
    ))

    (define prettifyNode (lambda (x)
        (if (= x A)
            (return "A")
        )
        (if (= x B)
            (return "B")
        )
        (if (= x C)
            (return "C")
        )
        (if (= x D)
            (return "D")
        )
        (if (= x E)
            (return "E")
        )
        (if (= x F)
            (return "F")
        )
        (if (= x G)
            (return "G")
        )


        "?"
    ))

    (define returnState (lambda (S)

     (createSearchNode (prettifyNode (getNode S)) (map prettifyNode (getSteps S)) (getCost S))
    ))

    (define h1 (lambda (x)
        (if (= x A)
            (return 9.5)
        )
        (if (= x B)
            (return 9)
        )
        (if (= x C)
            (return 8)
        )
        (if (= x D)
            (return 7)
        )
        (if (= x E)
            (return 1.5)
        )
        (if (= x F)
            (return 4)
        )
        (if (= x G)
            (return 0)
        )
        0
    ))

    (define h2 (lambda (x)
        (if (= x A)
            (return 10)
        )
        (if (= x B)
            (return 12)
        )
        (if (= x C)
            (return 10)
        )
        (if (= x D)
            (return 8)
        )
        (if (= x E)
            (return 1)
        )
        (if (= x F)
            (return 4.5)
        )
        (if (= x G)
            (return 0)
        )
        0
    ))
    (define start 0)

    (define goal? (lambda (state)
        (= state G)
    ))
    (define available (lambda (state)

        (define temp ())
        (if (= A (getNode state))
            (begin 
                (set! temp (list  (createSearchNode B (addStep (getNode state) (getSteps state)) (+ 1 (getCost state))) 
                                    (createSearchNode C (addStep (getNode state) (getSteps state)) (+ 4 (getCost state)))
                            )          
                )
            )
        )

        (if (= B (getNode state))
            (begin 
                (set! temp (list  (createSearchNode A (addStep (getNode state) (getSteps state)) (+ 1 (getCost state))) 
                                (createSearchNode C (addStep (getNode state) (getSteps state)) (+ 1 (getCost state)))
                                (createSearchNode D (addStep (getNode state) (getSteps state)) (+ 5 (getCost state))))
                )

            )
        )

        (if (= C (getNode state))
            (begin 
                (set! temp (list  (createSearchNode A (addStep (getNode state) (getSteps state)) (+ 4 (getCost state)))
                                (createSearchNode B (addStep (getNode state) (getSteps state)) (+ 1 (getCost state)))
                                (createSearchNode D (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                ))

            )
        )

        (if (= D (getNode state))
            (begin 
                (set! temp (list  (createSearchNode B (addStep (getNode state) (getSteps state)) (+ 5 (getCost state)))
                     (createSearchNode C (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                     (createSearchNode E (addStep (getNode state) (getSteps state)) (+ 8 (getCost state)))
                     (createSearchNode G (addStep (getNode state) (getSteps state)) (+ 9 (getCost state)))
                     (createSearchNode F (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                ))
            )
        )

        (if (= E (getNode state))
            (begin 
                (set! temp (list  (createSearchNode G (addStep (getNode state) (getSteps state)) (+ 2 (getCost state)))
                     (createSearchNode D (addStep (getNode state) (getSteps state)) (+ 8 (getCost state)))
                ))
            )
        )

        (if (= F (getNode state))
            (begin 
                (set! temp (list  (createSearchNode G (addStep (getNode state) (getSteps state)) (+ 5 (getCost state)))
                (createSearchNode D (addStep (getNode state) (getSteps state)) (+ 3 (getCost state)))
                ))
            )
        )


        temp
    ))
    (define cost (lambda (lastState nextState)
        (+ (getCost lastCost) (getCost nextCost))
    ))
    (define order (lambda (state)
        (+ (getCost state) (h2 (getNode state)))
    ))
    (lambda)
))


























