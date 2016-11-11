(define null-ld?
        (lambda(ls) (eq? (car ls) (cdr ls)))
)

(define (listdiff_helper? h t)
        (if (pair? h) 
        (cond 
        [(eq? h t) #t]
        [else (listdiff_helper? (cdr h) t)])
        #f))

(define listdiff? (lambda(ls) (if (pair? ls) (listdiff_helper? (car ls) (cdr ls)) #f)))

(define car-ld-helper 
        (lambda (ls1 ls2)
                     (if (equal? (car ls1) (car ls2)) '()
                     (cons (car ls1) (car-ld-helper (cdr ls1) ls2)))
        ))

(define get-diff
        (lambda (ls)
                (car-ld-helper (car ls) (cdr ls))
        ))

(define car-ld
        (lambda (ls) (car (get-diff ls)))
)

(define listdiff2 (lambda (h . t)
        (if (eq? (car h) (car t)) '()
        (cons (car h) (listdiff2 (cdr h) t)))
))

(define listdiff-helper (lambda (h . t)
        (if (null? (cdr h)) h
        (cons h (listdiff-helper (car t) (cdr t)))
        )
))

(define listdiff (lambda (ls) (cons (listdiff-helper X) '())))