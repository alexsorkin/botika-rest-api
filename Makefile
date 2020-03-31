PROJECT_VERSION = 0.0.9

TARGET_IMAGE_REPO = alexsorkin/botika
TARGET_IMAGE_TAG = latest
TARGET_NAMESPACE = botika
TARGET_RELEASE_NAME = botika-rest-api

SOURCE_HELM_CHART = deploy/botika

HELM_TLS_ARGUMENT = 

.PHONY: all build push deploy

all: build push deploy

build:
	docker build -t $(TARGET_IMAGE_REPO):$(TARGET_IMAGE_TAG) .
	helm lint $(SOURCE_HELM_CHART)

push:
	docker push $(TARGET_IMAGE_REPO):$(TARGET_IMAGE_TAG)

deploy:
	helm upgrade $(HELM_TLS_ENABLED) --install --namespace $(TARGET_NAMESPACE) $(TARGET_RELEASE_NAME) $(SOURCE_HELM_CHART)
