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
  ;; sed uses BREs by default (man re_format). With a pattern separator of /,
  ;; the only interesting metacharacters are /, \, ^ at the beginning of the
  ;; pattern, and $ at the end of the pattern. The careful reader will note
  ;; that, in the BRE \(^foo\), ^ is also a metacharacter; because we already
  ;; escape the \( and \) metacharacters, there is no need to adjust this ^.
  ;; More generally, escaping all \s escapes most of the unenhanced BRE
  ;; metacharacters.
  (define-flow sed-escape
    ;; double-escaped replacements to quote the backslashes, not the following
    ;; replacement characters.
    (regexp-replaces '([#rx"[/\\]" "\\\\&"]
                       [#rx"^\\^" "\\\\^"]
                       [#rx"\\$$" "\\\\$"])))
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
