(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)


(equal? (listdiff? d1) #t)
(equal? (listdiff? d2) #t)
(equal? (listdiff? d3) #f)
(equal? (listdiff? d4) #f)
(equal? (listdiff? d5) #f)

(equal? (null-ld? d1) #f)
(equal? (null-ld? d2) #t)
(equal? (null-ld? d3) #f)

