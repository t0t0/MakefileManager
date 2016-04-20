include Transformer


ifdef RUNVARS
E_RUNVARS=$(RUNVARS)
endif

run:
	for i in `seq 1 $(CONTAINERS)`; do docker run $(E_RUNVARS); done;

test:
	echo $(RUNVARS)
