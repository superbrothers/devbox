IMAGE := superbrothers/devbox

.PHONY: build
build:
		DOCKER_BUILDKIT=1 docker build -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)

.PHONY: pull
pull:
		docker pull $(IMAGE)
