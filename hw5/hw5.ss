#lang racket
(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)


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

(define diff-helper 
        (lambda (ls1 ls2)
             (if (not (empty? ls2)) 
                     (if (not (equal? (car ls1) (car ls2)))
                     (cons (car ls1) (diff-helper (cdr ls1) ls2))
                     '()
        ) ls1))
)

(define car-ld
        (lambda (ls) (car (diff-helper (car ls) (cdr ls))))
)

(define (cdr-ld ls) (cdr (diff-helper (car ls) (cdr ls))))

(define (listdiff-helper obj . args)
        (if (empty? (car args)) obj
            (cons obj (listdiff-helper (car args) (cdr args)))
        )
)

(define listdiff (lambda (h . t) (cons (listdiff-helper h t) '())))

(define d6 (listdiff ils d1 37))



