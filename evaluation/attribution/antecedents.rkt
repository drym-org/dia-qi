#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

(require racket/runtime-path
         syntax/parse/define
         abe/dia
         "tree-parser.rkt")

(define-syntax-parse-rule
  (mb [ideas:string antecedents:string] {~datum =>} export:id)
  ;; Make sure runtime-path resolved like a require: from context of written
  ;; module, not this module. Also, we have to wrap path in #%datum manually or
  ;; suffer a "#%datum not bound in the transformer environment" error.
  #:with runtime-path-define-ideas
  (datum->syntax #'ideas (syntax-e #'(define-runtime-path ideas-p (#%datum . ideas))) #'ideas)
  #:with runtime-path-define-antecdents
  (datum->syntax #'antecdents (syntax-e #'(define-runtime-path antecdents-p (#%datum . antecedents))) #'antecdents)
  (#%module-begin
   (provide export)
   runtime-path-define-ideas
   runtime-path-define-antecdents
   (define tree (read-idea-attribution-tree ideas-p))
   (define antes (read-idea-antecedents-tree antecdents-p))
   (unless (validate-appraisal tree)
     (error 'validate-appraisal "bad appraisal: ~a" tree))
   (define export (make-hash))
   (define aux (make-hash))
   (tally tree node-weight bump #:results aux)
   (unless (validate-attributions aux)
     (error 'validate-attributions "bad attributions: ~a" aux))
   (attribute-antecedents aux antes export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))
