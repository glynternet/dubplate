# dubplate version: v1.0.0-2-g61f3327-dirty (manually edited)

dockerfile:
	$(MAKE) Dockerfile.$(APP_NAME)

Dockerfile.%:
	sed 's/{{APP_NAME}}/$(subst Dockerfile.,,$@)/g' Dockerfile.template > $(BUILD_DIR)/$@

image: Dockerfile.$(APP_NAME) check-docker-username
	docker build \
		--tag $(DOCKER_USERNAME)/$(APP_NAME):$(VERSION) \
		-f $(BUILD_DIR)/Dockerfile.$(APP_NAME) \
		./bin

check-docker-username:
ifndef DOCKER_USERNAME
	$(error DOCKER_USERNAME var not defined)
endif
