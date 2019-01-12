IMAGE := superbrothers/dev

.PHONY: image
image:
		docker build -t $(IMAGE) .
