#lang racket

(provide read-attribution-tree
         read-idea-attribution-tree
         read-idea-antecedents-tree)

(require racket/hash
         qi)

;; If this is not defined with function syntax, inner implementation functions
;; unbound because they are eagerly evaluated.
(define-flow (read-attribution-tree f)
  (~> file->lines
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map label->attribution leaf->attribution)))

(define-flow (read-idea-attribution-tree f)
  (~> file->lines
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map label->attribution label->attribution)))

(define-flow (read-idea-antecedents-tree f)
  (~> file->lines
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map values leaf->antecedents)
      (leaves->hash car cdr)))

(define (make-indent-based-tree lines [on-line values])
  (define by-indent
    (for/list ([line lines])
      (match-define (regexp #px"^(\\s*)" (list _ (app string-length indent))) line)
      (cons indent (on-line line))))
  (match by-indent
    ['() '()]
    [(cons (cons ind _) _)
     (let make-tree ([indents by-indent]
                     [prev-indent ind])
       (match indents
         ['() '()]
         [(cons (cons ind line) indents)
          (cond
            [(= ind prev-indent)
             (cons line (make-tree indents prev-indent))]
            [(> ind prev-indent)
             (map (flow (make-tree ind))
                  (make-groups-at ind (cons (cons ind line) indents)))]
            ;; all smaller have already been handled, so this would be a bug
            ;; or bad input: say, the first line is indented and the next is not
            [(< ind prev-indent)
             (error 'make-tree "smaller indent: ~a < ~a in ~a" ind prev-indent indents)])]))]))

(define (make-groups-at n xs)
  (let loop ([acc null]
             [xs xs])
    (match xs
      ['() (reverse acc)]
      [(cons x xs)
       (define-values (group rest)
         (split-at xs (or (index-where xs (flow (~> car (= n))))
                          (length xs))))
       (loop (cons (cons x group) acc)
             rest)])))

(define (leaf->attribution x)
  (match x
    [(regexp #px"^\\s*\\* ([^ ]+)(?:\\s+and\\s+([^ ]+))?.*\\[([[:digit:].]+)%\\]"
             (list _ name1 name2 (app string->number attribution)))
     (cons (if name2 (list name1 name2) name1)
           attribution)]))

(define (label->attribution x)
  (match x
    [(regexp #px"^\\s*\\* (.*) \\[([[:digit:].]+)%\\]"
             (list _ thing (app string->number attribution)))
     (cons thing attribution)]))

(define (leaf->antecedents x)
  (match x
    [(regexp #px"^\\s*\\* (.*) \\[(.*)\\]" (list _ idea antecedents))
     (cons idea (string-split antecedents ", "))]))

(define (leaves->hash t k v)
  (tree-fold t (hash) (flow (~> 2> sep hash-union)) (flow (~> (-< k v) hash))))

(define (tree-map t label leaf)
  (match t
    ['() '()]
    [(list x) (list (leaf x))]
    [(cons x children)
     (cons (label x)
           (map (flow (tree-map label leaf)) children))]))

(define (tree-fold t z label leaf)
  (match t
    ['() z]
    [(list x) (leaf x)]
    [(cons x children)
     (label x (map (flow (tree-fold z label leaf)) children))]))

(module+ main
  (read-attribution-tree "../appraisal/deanonymized/capital.md")
  (read-attribution-tree "../appraisal/deanonymized/labor.md")
  (read-idea-attribution-tree "../appraisal/ideas.md")
  (read-idea-antecedents-tree "../antecedents/ideas.md"))
