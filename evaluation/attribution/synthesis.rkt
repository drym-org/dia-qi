#lang racket

(require abe/dia
         qi
         "../appraisal/deanonymized/capital.md"
         "../appraisal/deanonymized/labor.md"
         "../antecedents/ideas.md")

(define attributions (make-hash))

(define N 3)

(reconcile-appraisals N
                      labor-attributions
                      capital-attributions
                      antecedents-attributions
                      attributions)

(unless (validate-attributions attributions)
  (error 'validate-attributions "bad attributions: ~a" attributions))

(define-flow round-attribution
  (~>> (~r #:precision '(= 2)) string->number))

(~> (attributions)
    (hash-map/copy (flow (== _ round-attribution)))
    hash->list
    (sort > #:key cdr)
    pretty-print)
