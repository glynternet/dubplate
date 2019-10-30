# dubplate version: {{DUBPLATE_VERSION}}

ROOT_DIR ?= $(shell git rev-parse --show-toplevel)
UNTRACKED ?= $(shell test -z "$(shell git ls-files --others --exclude-standard "$(ROOT_DIR)")" || echo -untracked)
VERSION ?= $(shell git describe --tags --dirty --always)$(UNTRACKED)

BUILD_DIR ?= ./build/$(VERSION)

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm $(BUILD_DIR)/*

version:
	@echo ${VERSION}

cmd-all: binary test-binary-version-output image
