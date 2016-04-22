include Transformer


ifdef RUNVARS
E_RUNVARS=$(RUNVARS)
endif

ifdef BUILDVARS
E_BUILDVARS=$(BUILDVARS)
endif

run:
	docker run $(E_RUNVARS)

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

deploy:
	@for i in `seq 1 $(CONTAINERS)`; do ssh $(CONNECT) docker run $(E_RUNVARS); done;

test_trans: transform