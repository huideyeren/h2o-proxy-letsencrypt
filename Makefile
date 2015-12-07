NAME := h2o-proxy-letsencrypt
CONTAINER := $(NAME)

DOCKER := sudo docker
DOCKER_RUN_ARG := --net=host -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock:ro
DOCKER_RUN_VOL := -v /data/letsencrypt:/etc/letsencrypt -v /data/acme:/data/acme

EMAIL := 
AGREEMENT := 

all:
	@echo ':)'

build:
	$(DOCKER) build --build-arg EMAIL=$(EMAIL) --build-arg AGREEMENT=$(AGREEMENT) --rm -t "$(CONTAINER)" .

run:
	$(DOCKER) run --name "$(NAME)" -d $(DOCKER_RUN_ARG) $(DOCKER_RUN_VOL) $(CONTAINER):latest

debug:
	$(DOCKER) run --name "$(NAME)" -it --entrypoint=/bin/bash $(DOCKER_RUN_ARG) $(DOCKER_RUN_VOL) $(CONTAINER):latest -i

start:
	$(DOCKER) start $(NAME)

stop:
	$(DOCKER) stop $(NAME)

clean:
	$(DOCKER) rm $(NAME)

docker-cleanup-containers:
	docker ps -a -q -f "status=exited" | xargs --no-run-if-empty docker rm -v
	docker images -q -f "dangling=true" | xargs --no-run-if-empty docker rmi

