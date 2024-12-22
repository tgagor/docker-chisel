SHELL=/bin/bash
DOCKER_REGISTRY ?= tgagor
BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
GIT_COMMIT ?= $(shell git rev-parse HEAD)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_URL ?= $(shell git config --get remote.origin.url)
GIT_TAG ?= $(shell echo $(GIT_BRANCH) | sed -E 's/[/:]/-/g' | sed 's/master/latest/' )
DOCKER_CMD ?= docker
MAINTAINER ?= "Tomasz Gągor <https://gagor.pro>"

# use numer of available CPUs to run multiple builds at the same time
PARALLEL := $(shell $(DOCKER_CMD) info --format "{{ .NCPU }}")

all: $(STAGES) summary



.PHONY: all $(SUBDIRS) push summary clean

define stage_status
	@echo
	@echo
	@echo ================================================================================
	@echo Building: $(1)
	@echo ================================================================================
endef

define summary
	@echo
	@echo
	@echo ================================================================================
	@echo Generated images:
	@echo ================================================================================
	@$(DOCKER_CMD) image ls \
		--format "{{.Repository}}:{{.Tag}}\t{{.Size}}" \
		--filter=dangling=false \
		--filter=reference="$(DOCKER_REGISTRY)/*:*" | sort | column -t
endef


clean:
	@$(DOCKER_CMD) image rm -f $(shell $(DOCKER_CMD) image ls --format "{{.Repository}}:{{.Tag}}" --filter=dangling=false --filter=reference="$(BUILD_PREFIX)/*:*") 2>/dev/null || true
	@$(DOCKER_CMD) image rm -f $(shell $(DOCKER_CMD) image ls --format "{{.Repository}}:{{.Tag}}" --filter=dangling=false --filter=reference="$(DOCKER_REGISTRY)/*:*") 2>/dev/null || true

prune:
	@$(DOCKER_CMD) system prune --all --force --volumes

summary:
	$(call summary)
