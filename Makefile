IMAGE := superbrothers/devbox

ERB ?= docker run -i ruby:2.5-slim erb

.PHONY: build
build:
		cat Dockerfile.erb | $(ERB) -T 2 | DOCKER_BUILDKIT=1 docker build -f- -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)
