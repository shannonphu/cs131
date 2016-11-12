#lang racket

(define null-ld?
        (lambda(ls) (eq? (car ls) (cdr ls)))
)

(define (listdiff_helper? h t)
        (if (pair? h) 
        (cond 
        [(eq? h t) #t]
        [else (listdiff_helper? (cdr h) t)])
        #f))

(define listdiff? (lambda(ls)
                        (if (pair? ls)
                            (if (empty? (cdr ls)) #t
                                (listdiff_helper? (car ls) (cdr ls)))
                            #f)))

(define diff-helper 
        (lambda (ls1 ls2)
             (if (not (empty? ls2)) 
                     (if (not (equal? (car ls1) (car ls2)))
                     (cons (car ls1) (diff-helper (cdr ls1) ls2))
                     '()
        ) ls1))
)

(define car-ld
        (lambda (ls) (if (empty? (diff-helper (car ls) (cdr ls))) '()
                         (car (diff-helper (car ls) (cdr ls)))
        ))
)

(define (cdr-ld ls) (cons (cdr (diff-helper (car ls) (cdr ls))) '()))

(define (length-ld ls) (length (diff-helper (car ls) (cdr ls))))

(define (cons-ld obj ld) (cons (cons obj (car ld)) (cdr ld)))

(define (listdiff-helper obj . args)
        (if (empty? (car args)) obj
            (cons obj (listdiff-helper (car args) (cdr args)))
        )
)

(define listdiff (lambda (h . t) (cons (listdiff-helper h t) '())))


(define (append-ld-helper h . t)
  (if (empty? (car t)) h
  (append (diff-helper (car h) (cdr h)) (car (append-ld-helper (car t) (cdr t))))))

(define (append-ld h . t)
  (cons (append-ld-helper h t) '()))

(define (assq-ld-pair p obj)
  (if (not (pair? p)) #f
  (if (equal? p obj) #t (assq-ld-pair (car p) obj))))

(define (assq-ld-helper obj lf)
  (if (empty? lf) #f
  (if (assq-ld-pair (car lf) obj) (car lf)
      (assq-ld-helper obj (cdr lf)))))

(define (assq-ld obj lf)
  (assq-ld-helper obj (car lf)))

(define (list->listdiff ls) (cons ls '()))

(define (listdiff->list ls) (diff-helper (car ls) (cdr ls)))

;(define expr-returning (ld) ())

;;;;;;;;;;; Test
(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)
(define d6 (listdiff ils d1 37))
(define d7 (append-ld d1 d2 d6))

(define kv1 (cons d1 'a))
(define kv2 (cons d2 'b))
(define kv3 (cons d3 'c))
(define kv4 (cons d1 'd))
(define d8 (listdiff kv1 kv2 kv3 kv4))
(eq? (assq-ld d1 d8) kv1)
(eq? (assq-ld d2 d8) kv2)
(not (eq? (assq-ld d1 d8) kv4))

(eq? (listdiff? d1) #t)
(eq? (listdiff? d2) #t)
(eq? (listdiff? d3) #f)
(eq? (listdiff? d4) #f)
(eq? (listdiff? d5) #f)
(eq? (listdiff? d6) #t)
(eq? (listdiff? d7) #t)

(eq? (null-ld? d1) #f)
(eq? (null-ld? d2) #t)
(eq? (null-ld? d3) #f)
(eq? (null-ld? d6) #f)

(equal? (car-ld d1) 'a)
(equal? (car-ld d6) '(a e i o u . y))

(eq? (car-ld d6) ils) 
(eq? (car-ld (cdr-ld d6)) d1)
(eqv? (car-ld (cdr-ld (cdr-ld d6))) 37)
(equal? (listdiff->list d6) (list ils d1 37))
(eq? (list-tail (car d6) 3) (cdr d6))

;(define e1 (expr-returning d1))
;(equal? (listdiff->list (eval e1)) '(a e))
;(equal? (listdiff->list (eval e1)) (listdiff->list d1))
