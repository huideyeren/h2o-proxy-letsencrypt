NAME 			:= h2o-proxy-letsencrypt
CONTAINER := nyarla/$(NAME)

email     := 
agreement := 

docker    := docker
port      := --net=container:boulder 
socket    := -v /var/run/docker.sock:/tmp/docker.sock:ro

devserver := --server http://127.0.0.1:4000/directory
testflags := --no-verify-ssl --tls-sni-01-port 5001 --http-01-port 5002 --register-unsafely-without-email --debug -vvvvvvv
test      := -e EXTRA_ARGS="$(devserver) $(testflags)" -e ACME_TEST=1

env       := -e EMAIL=$(email) -e AGREEMENT=$(agreement) $(test)
args      := $(port) $(socket) $(env)


all: build

.PHONY: build run debug start stop clean

build:
	$(docker) build --rm -t $(CONTAINER) .

run:
	$(docker) run --name "$(NAME)" -d $(args) $(CONTAINER):latest

debug:
	$(docker) run --name "$(NAME)" -it --entrypoint=/bin/sh $(args) $(CONTAINER):latest

start:
	$(docker) start $(NAME)

stop:
	$(docker) stop $(NAME)

clean:
	$(docker) rm $(NAME)

