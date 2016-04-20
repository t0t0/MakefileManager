include Transformer


ifdef RUNVARS
E_RUNVARS=$(RUNVARS)
endif

ifdef BUILDVARS
E_BUILDVARS=$(BUILDVARS)
endif

run:
	for i in `seq 1 $(CONTAINERS)`; do docker run $(E_RUNVARS); done;

testvars:
	echo $(RUNVARS)

logs:
	docker logs $(CONTAINER)

test: 
	if ! $$(docker inspect -f {{.State.Running}} $(CONTAINER)); then exit 2; fi;

build:
	docker build $(E_BUILDVARS) 