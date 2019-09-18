IMAGE := superbrothers/devbox

ERB ?= docker run -v "$${PWD}:$${PWD}" -w "$${PWD}" ruby:2.5-slim erb

Dockerfile: Dockerfile.erb packages.txt
		$(ERB) -T 2 Dockerfile.erb >$@

.PHONY: build
build: Dockerfile
		DOCKER_BUILDKIT=1 docker build -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)

.PHONY: pull
pull:
		docker pull $(IMAGE)
