DOCKER_USERNAME := continuousengineeringproject
IMAGE_NAME := factory-cli-base
VERSION := $(shell git rev-parse --short HEAD)

# Build the Docker image using a specific Dockerfile
build:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME) -f Dockerfile .

# Run the Docker image locally
run:
	docker run -p 8080:80 $(DOCKER_USERNAME)/$(IMAGE_NAME)

push_latest:
	docker tag $(DOCKER_USERNAME)/$(IMAGE_NAME) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest

# Build and push version & latest of the Docker image
release:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)
	docker tag $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest

# Remove the Docker image
clean:
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)