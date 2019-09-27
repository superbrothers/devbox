IMAGE := superbrothers/devbox

ERB ?= docker run -v "$${PWD}:$${PWD}" -w "$${PWD}" ruby:2.5-slim erb

packages.txt:
		./hack/update-packages.sh

Dockerfile: hack/Dockerfile.erb packages.txt
		$(ERB) -T 2 hack/Dockerfile.erb >$@

.PHONY: build
build: Dockerfile
		DOCKER_BUILDKIT=1 docker build -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)

.PHONY: pull
pull:
		docker pull $(IMAGE)
