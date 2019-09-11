IMAGE := superbrothers/devbox

.PHONY: build
build:
		erb -T 2 Dockerfile.erb | DOCKER_BUILDKIT=1 docker build -f- -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)
