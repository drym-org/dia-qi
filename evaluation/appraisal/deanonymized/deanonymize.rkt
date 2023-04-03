#! /usr/bin/env racket
#lang rash

(require racket
         racket/runtime-path
         qi)

(define-runtime-path here ".")
(define evaluation (build-path here 'up 'up))
(define inputs (build-path evaluation 'up "input"))
(define appraisals (build-path evaluation "appraisal"))
(define-flow input (build-path inputs __))
(define-flow appraisal (build-path appraisals __))
(define-flow output (build-path here __))
(define-flow sed (~> (string-append ".sed") (build-path here __)))

(define anon->actual
  (hash "capital-anonymized.md" "capital.md"
        "labor-anonymized.md" "labor.md"))

(define (make-lookup anon actual)
  (define anon-actual-table
    #{paste $anon $actual | column -ts'* |> port->lines})
  (for/hash ([line anon-actual-table])
    (~> (line) (string-split "\t") (sep string-trim))))

(define (lookup->sed lookup)
  (define-flow sed-escape
    (regexp-replace* #rx"[/\\]" _ "\\\\&"))
  (string-join
    (for/list ([(anon actual) lookup])
      (format "s/~a/~a/" (sed-escape anon) (sed-escape actual)))
    "\n"))

(define execute? (make-parameter #f))
(command-line
  #:usage-help
  "Generate deanonymization scripts."
  "When enabled, execute deanonymization scripts."
  #:once-each
  [("--execute") "execute deanonmyization" (execute? #t)]
  #:args ()
  (void))

(for ([(anon actual) anon->actual])
  (define lookup (make-lookup (input anon) (input actual)))
  {
    echo (lookup->sed lookup) &>! (sed actual)
  })

(when (execute?)
  {
    (for ([actual (in-hash-values anon->actual)])
      { sed -f (sed actual) (appraisal actual) &>! (output actual) })
  })
