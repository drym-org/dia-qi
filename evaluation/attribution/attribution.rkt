#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

(require racket/runtime-path
         syntax/parse/define
         abe/dia
         "tree-parser.rkt")

(define-syntax-parse-rule
  (mb path:string {~datum =>} export:id)
  ;; Make sure runtime-path resolved like a require: from context of written
  ;; module, not this module. Also, we have to wrap path in #%datum manually or
  ;; suffer a "#%datum not bound in the transformer environment" error.
  #:with runtime-path-define
  (datum->syntax #'path (syntax-e #'(define-runtime-path input (#%datum . path))) #'path)
  (#%module-begin
   (provide export)
   runtime-path-define
   (define tree (read-attribution-tree input))
   (unless (validate-appraisal tree)
     (error 'validate-appraisal "bad appraisal: ~a" tree))
   (define export (make-hash))
   (tally tree node-weight bump #:results export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))
