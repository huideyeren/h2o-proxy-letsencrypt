NAME 			:= h2o-proxy-letsencrypt
CONTAINER := nyarla/$(NAME)
CF_EMAIL 	:= 
CF_KEY 		:=

email     := 
agreement := 
docker    := sudo docker
port      := --net=host -p 80:80 -p 443:443
socket    := -v /var/run/docker.sock:/tmp/docker.sock:ro
mount     := -v /opt/docker/$(NAME):/opt/data
env       := -e EMAIL=$(email) -e AGREEMENT=$(agreement) 
dns   		:= -e CF_EMAIL=$(CF_EMAIL) -e CF_KEY=$(CF_KEY)

args      := $(port) $(socket) $(mount) $(env) $(dns)

all:
	@echo ':)'

.PHONY: build run debug start stop clean cleanup-containers

build:
	$(docker) build --rm -t $(CONTAINER) .

run:
	$(docker) run --name "$(NAME)" -d $(args) $(CONTAINER):latest

debug:
	$(docker) run --name "$(NAME)" -it --entrypoint=/bin/bash $(args) $(CONTAINER):latest

start:
	$(docker) start $(NAME)

stop:
	$(docker) stop $(NAME)

clean:
	$(docker) rm $(NAME)

cleanup-containers:
	$(docker) ps -a -q -f "status=exited" | xargs --no-run-if-empty docker rm -v
	$(docker) images -q -f "dangling=true" 	| xargs --no-run-if-empty docker rmi

