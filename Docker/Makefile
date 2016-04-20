include Transformer


ifdef RUNVARS
E_RUNVARS=$(RUNVARS)
endif

ifdef BUILDVARS
E_BUILDVARS=$(BUILDVARS)
endif

run:
	@for i in `seq 1 $(CONTAINERS)`; do docker run $(E_RUNVARS); done;

logs:
	docker logs $(CONTAINER)

test: 
	@if ! $$(docker inspect -f {{.State.Running}} $(CONTAINER)); then echo "test failed" && exit 2; else echo "test succeeded!";fi;

build:
	@docker build $(E_BUILDVARS)
	@echo "$(IMAGE) built!" 


clean:
	@docker kill $(CONTAINER) | xargs docker rm
	@echo "cleaned!"