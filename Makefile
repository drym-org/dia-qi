.POSIX:
SHELL = /bin/sh

DEANONYMIZED_OUT = evaluation/appraisal/deanonymized/capital.md \
                   evaluation/appraisal/deanonymized/capital.md.sed \
                   evaluation/appraisal/deanonymized/labor.md \
                   evaluation/appraisal/deanonymized/labor.md.sed \

DEANONYMIZED_IN = input/capital.md \
                  input/capital-anonymized.md \
                  input/labor.md \
                  input/labor-anonymized.md \
                  evaluation/appraisal/capital.md \
                  evaluation/appraisal/labor.md \
                  evaluation/appraisal/deanonymized/deanonymize.rkt

.PHONY: deanonymize
deanonymize: $(DEANONYMIZED_OUT)
$(DEANONYMIZED_OUT): $(DEANONYMIZED_IN)
	evaluation/appraisal/deanonymized/deanonymize.rkt --execute

ATTRIBUTION_IN = $(DEANONYMIZED_OUT) \
                 evaluation/appraisal/ideas.md \
                 evaluation/antecedents/ideas.md \
                 evaluation/attribution/capital.rkt \
                 evaluation/attribution/ideas.rkt \
                 evaluation/attribution/labor.rkt \
                 evaluation/attribution/synthesis.rkt \

.PHONY: attribute
attribute: evaluation/attribution/attribution.rktd
evaluation/attribution/attribution.rktd: $(ATTRIBUTION_IN)
	racket evaluation/attribution/synthesis.rkt > $@
