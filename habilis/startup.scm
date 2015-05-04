(define help (lambda ()
    (print "Other help commands:")
    (print "    help-math")
    (print "    help-constants")
    (print "    help-graphics")
    (graphics "link"  "core.scm" "_blank")
))

(define help-math (lambda ()
    (graphics "link"  "math.scm" "_blank")
))

(define help-constants (lambda ()
    (graphics "link"  "constants.scm" "_blank")
))

(define help-graphics (lambda ()
    (graphics "link"  "graphics.scm" "_blank")
))

(define setup (lambda ()
(load "core.scm")
(load "constants.scm")
(load "math.scm")
(load "graphics.scm")
(load "cs188.scm")


(print "*Cilaule")
(print "(help) links to the source.")
(print "Try (exampleHeart), (1d-heat), (coolerCircles), (radialHeart) - some may take awhile to load. ")


))

(setup)







