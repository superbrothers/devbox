IMAGE := superbrothers/devbox

.PHONY: image
image:
		docker build -t $(IMAGE) .
