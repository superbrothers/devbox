IMAGE := superbrothers/devbox

.PHONY: image
image:
		docker build -t $(IMAGE) .

.PHONY: push
push:
		docker push $(IMAGE)
