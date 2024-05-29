CONTRACTING_BRANCH ?= master
CORE_BRANCH ?= master

# CONTRACTING_BRANCH and CORE_BRANCH are environment variables used to specify the branch of the xian-core and xian-contracting repositories respectively that should be used when performing git operations in the 'pull' target of this Makefile. By default, they are set to 'master'.

# Usage:
# You can override these variables directly from the command line when invoking make. For example:
# make pull CONTRACTING_BRANCH=development CORE_BRANCH=feature-branch
# This will check out and pull the 'development' branch for xian-contracting and the 'feature-branch'


contracting-dev-up:
	docker-compose -f docker-compose-contracting.yml up -d
	docker-compose -f docker-compose-contracting.yml exec contracting /bin/bash

contracting-dev-build:
	docker-compose -f docker-compose-contracting.yml build

core-dev-build:
	docker-compose -f docker-compose-core.yml build

core-dev-up:
	docker-compose -f docker-compose-core.yml up -d
	docker-compose -f docker-compose-core.yml exec core /bin/bash

setup:
	mkdir -p ./cometbft
	git clone https://github.com/xian-network/xian-core.git
	git clone https://github.com/xian-network/xian-contracting.git

pull:
	cd xian-core
	git checkout $(CORE_BRANCH)
	git pull
	cd xian-contracting
	git checkout $(CONTRACTING_BRANCH)
	git pull
