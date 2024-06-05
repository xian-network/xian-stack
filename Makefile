CONTRACTING_BRANCH ?= master
CORE_BRANCH ?= master
# CONTRACTING_BRANCH and CORE_BRANCH are environment variables used to specify the branch of the xian-core and xian-contracting repositories respectively that should be used when performing git operations in the 'pull' target of this Makefile. By default, they are set to 'master'.

# Usage:
# You can override these variables directly from the command line when invoking make. For example:
# make pull CONTRACTING_BRANCH=development CORE_BRANCH=feature-branch
# This will check out and pull the 'development' branch for xian-contracting and the 'feature-branch'

# CONFIGURE_ARGS ex. --moniker some_moniker --genesis-file-name genesis.json --validator-privkey 0xPrivateKey --seed-node-address 392a05fe83a27cd75f7431f070cfb57446d1e93b@116.203.81.165 --copy-genesis true


contracting-dev-up:
	docker-compose -f docker-compose-contracting.yml up -d
	docker-compose -f docker-compose-contracting.yml exec contracting /bin/bash

contracting-dev-build:
	docker-compose -f docker-compose-contracting.yml build

core-dev-build:
	docker-compose -f docker-compose-core.yml build

core-dev-up:
	docker-compose -f docker-compose-core.yml up -d

core-dev-down:
	docker-compose -f docker-compose-core.yml down

core-dev-shell:
	make core-dev-up
	docker-compose -f docker-compose-core.yml exec core /bin/bash

setup:
	git clone https://github.com/xian-network/xian-core.git
	cd xian-core && git checkout $(CORE_BRANCH)
	git clone https://github.com/xian-network/xian-contracting.git
	cd xian-contracting && git checkout $(CONTRACTING_BRANCH)

checkout:
	cd xian-core && git checkout master && git pull && git checkout $(CORE_BRANCH)
	cd xian-contracting && git checkout master && git pull && git checkout $(CONTRACTING_BRANCH)

wipe:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make wipe"

dwu:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make dwu"

down:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make down"

up:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make up"

init:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make init"

configure:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core/src/xian/tools/ && python configure.py ${CONFIGURE_ARGS}"

node-id:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make node-id"