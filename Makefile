GIT_HASH            ?= $(shell git rev-parse --short HEAD)

DOCKER_IMAGE        ?= xiam/openvpn-proxy
DOCKER_TAG          ?= $(GIT_HASH)

docker-build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker-push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

release: docker-build docker-push
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest && \
	docker push $(DOCKER_IMAGE):latest
