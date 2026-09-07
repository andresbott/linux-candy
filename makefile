# Version used for local builds. In CI the release workflow overrides this with
# the pushed git tag (e.g. v0.1.4). Falls back to a dev version before any tag.
VERSION ?= $(shell git describe --tags 2>/dev/null || echo 0.0.0-dev)
PACKAGER ?= deb
DIST_DIR ?= dist
# nfpm image used by `make docker-build`; pinned to match the release workflow.
NFPM_IMAGE ?= goreleaser/nfpm:v2.43.0

default: help

#==========================================================================================
##@ Building
#==========================================================================================
.PHONY: build
build: ## build the .deb package into dist/
	@mkdir -p $(DIST_DIR)
	@VERSION=$(VERSION) nfpm package -f build/deb/nfpm.yaml -p $(PACKAGER) -t $(DIST_DIR)/
	@echo "✅ built $(PACKAGER) package (version $(VERSION)) in $(DIST_DIR)/"

.PHONY: docker-build
docker-build: ## build the .deb inside a docker container (no local nfpm needed)
	@mkdir -p $(DIST_DIR)
	@docker run --rm \
		-u "$$(id -u):$$(id -g)" \
		-v "$(CURDIR):/work" -w /work \
		-e VERSION=$(VERSION) \
		$(NFPM_IMAGE) package -f build/deb/nfpm.yaml -p $(PACKAGER) -t $(DIST_DIR)/
	@echo "✅ built $(PACKAGER) package (version $(VERSION)) in $(DIST_DIR)/ via docker"

.PHONY: clean
clean: ## remove build artifacts
	@rm -rf $(DIST_DIR)

#==========================================================================================
##@ Release
#==========================================================================================
.PHONY: check-branch
check-branch:
	@current_branch=$$(git symbolic-ref --short HEAD) && \
	if [ "$$current_branch" != "main" ]; then \
		echo "Error: You are on branch '$$current_branch'. Please switch to 'main'."; \
		exit 1; \
	fi

.PHONY: check-git-clean
check-git-clean: # fail if the working tree has uncommitted changes
	@git diff --quiet || ( echo "Error: working tree is dirty, commit or stash first."; exit 1 )

.PHONY: tag
tag: check-git-clean check-branch ## push a git tag to cut a release, usage: make tag version="v1.2.3"
	@[ "${version}" ] || ( echo ">> version is not set, usage: make tag version=\"v1.2.3\""; exit 1 )
	@git tag -d $(version) || true
	@git tag -a $(version) -m "Release $(version)"
	@git push --delete origin $(version) || true
	@git push origin $(version)
	@echo "✅ pushed tag $(version); the release workflow will build and publish the .deb"

#==========================================================================================
#  Help
#==========================================================================================
.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
