#####
# test deploy
####

####
# vars
####

PORTHOST=3000
PORTGUEST=3000
EXPOSEPORT=3000
S3_BUCKET=stage-bucket.smalltownheroes.be
DOCKERFILEPATH ?= infra/node/Dockerfile

####
# ssh vars
####

REMOTE_USER_NAME ?= core
IP ?= 52.49.229.231

####
# Storage vars
####

ST_NAME=storage
ST_IMAGE=ubuntu:vivid

####
# Nginx vars
####

NX_CONFIGPATH=/home/core/config/nginx/nginx.conf
NX_NAME=nginx

####
# Docker-gen vars
####

DOCKGEN_NAME=dock-gen

####
# Datadog vars
####

DATADOG_NAME=dd-agent
API_KEY=**********
HOSTNAME=stage-agent

####
# container variables
####

HOSTS ?= 2
CONTAINER ?= node
IMAGE_NAME ?= dev-node
IMAGE_VERSION ?= latest
VIRTUAL_HOST ?= demo1-stage.smalltownheroes.be

####
# concatenate vars
####
# full file name for tarbal
TARNAME = $(IMAGE_NAME).tar
# full image name
IMAGE = $(IMAGE_NAME):$(IMAGE_VERSION)
#full ssh connect vars
CONNECT = $(REMOTE_USER_NAME)@$(IP)

####
# Make commands
####

docker_build:
	docker build -t $(IMAGE) -f $(DOCKERFILEPATH) .

docker_run:
	docker run -d -p  $(PORTHOST):$(PORTGUEST) $(IMAGE); sleep 10

docker_curltest:
	curl --retry 10 --retry-delay 5 -v http://localhost:$(PORTHOST)

docker_save:
	docker save -o $(TARNAME) $(IMAGE)

s3_config:
	echo "[default]" > ~/.s3cfg
	echo "access_key=$(S3_ACCESS_KEY)" >> ~/.s3cfg
	echo "secret_key=$(S3_SECRET_KEY)" >> ~/.s3cfg

s3_upload:
	s3cmd del s3://$(S3_BUCKET)/images/$(TARNAME)
	s3cmd put $(TARNAME) s3://$(S3_BUCKET)/images/$(TARNAME)

remote_s3_download:
	ssh $(CONNECT) AWS_ACCESS_KEY_ID=$(S3_ACCESS_KEY) AWS_SECRET_ACCESS_KEY=$(S3_SECRET_KEY) ./gof3r cp --no-md5 --endpoint=s3-eu-west-1.amazonaws.com s3://$(S3_BUCKET)/images/$(TARNAME) /home/core/$(TARNAME)
	ssh $(CONNECT) docker load -i $(TARNAME)

#docker_loop_cleanup:
#	ssh $(CONNECT) docker ps -qa --filter="name=$(CONTAINER)" >> ~/.containers
#	for container in `cat ~/.containers`; do ssh $(CONNECT) docker stop $$container; done
#	for container in `cat ~/.containers`; do ssh $(CONNECT) docker rm $$container; done

docker_loop_cleanup:
	ssh $(CONNECT) docker ps -qa --filter="name=$(CONTAINER)" | xargs -r ssh $(CONNECT) docker stop | xargs -r ssh $(CONNECT) docker rm
	ssh $(CONNECT) docker images -q --filter "dangling=true" | xargs -r ssh $(CONNECT) docker rmi

docker_loop_deploy:
	for i in `seq 1 $(HOSTS)`; do  ssh $(CONNECT) docker run -d --name $(CONTAINER)$$i --expose $(EXPOSEPORT) -e VIRTUAL_HOST=$(VIRTUAL_HOST) --volumes-from $(ST_NAME) $(IMAGE); done;

docker_deploy: remote_s3_download docker_loop_cleanup docker_loop_deploy

ssh:
	ssh $(CONNECT)

nginx_config_push:
	scp infra/nginx/nginx.conf $(CONNECT):$(NX_CONFIGPATH)

nginx_run:
	ssh $(CONNECT) docker run -d -p 80:80 --name $(NX_NAME) -v /tmp/nginx:/etc/nginx/conf.d -v $(NX_CONFIGPATH):/etc/nginx/nginx.conf nginx

nginx_cleanup:
	ssh $(CONNECT) docker stop $(NX_NAME)
	ssh $(CONNECT) docker rm $(NX_NAME)

nginx_deploy: nginx_cleanup nginx_run

storage_run:
	ssh $(CONNECT) docker create -v /src/public/videos/ --name $(ST_NAME) $(ST_IMAGE) /bin/true

storage_cleanup:
	ssh $(CONNECT) docker stop $(ST_NAME)
	ssh $(CONNECT) docker rm $(ST_NAME)

storage_deploy: storage_cleanup storage_run

docker_ps:
	ssh $(CONNECT) docker ps -a

docker_images:
	ssh $(CONNECT) docker images

dockgen_run:
	ssh $(CONNECT) docker run -d- --name $(DOCKGEN_NAME) -v /var/run/docker.sock:/tmp/docker.sock:ro -v /home/core/poc-animatedgifmaker/infra/ansible/:/etc/docker-gen/templates/ --volumes-from $(NX_NAME) jwilder/docker-gen -notify-sighup nginx -watch -only-exposed /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf

dockgen_cleanup:
	ssh $(CONNECT) docker stop $(DOCKGEN_NAME) | xargs -r ssh $(CONNECT) docker rm 

dockgen_deploy: dockgen_cleanup dockgen_run

datadog_run:
	ssh $(CONNECT) docker run -d --name $(DATADOG_NAME) -h $(HOSTNAME) -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -v /opt/dd-agent-conf.d:/conf.d:ro -e API_KEY=$(API_KEY) datadog/docker-dd-agent

datadog_cleanup:
	ssh $(CONNECT) docker stop $(DATADOG_NAME) | xargs -r ssh $(CONNECT) docker rm 

datadog_deploy: datadog_cleanup datadog_run	
