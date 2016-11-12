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

(define (expr-returning ld)
  `(car (list ',ld)))
