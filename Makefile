CONTRACTING_BRANCH ?= master
CORE_BRANCH ?= master
# CONTRACTING_BRANCH and CORE_BRANCH are environment variables used to specify the branch of the xian-core and xian-contracting repositories respectively that should be used when performing git operations in the 'pull' target of this Makefile. By default, they are set to 'master'.

# ::: Usage

# You can override these variables directly from the command line when invoking make. For example:
# make pull CONTRACTING_BRANCH=development CORE_BRANCH=feature-branch
# This will check out and pull the 'development' branch for xian-contracting and the 'feature-branch' for xian-core

# ::: Xian Stack Setup & Git Commands
# ::: For setting up the xian-core and xian-contracting repositories and pulling the latest changes

setup:
	git clone https://github.com/xian-network/xian-core.git
	cd xian-core && git checkout $(CORE_BRANCH)
	git clone https://github.com/xian-network/xian-contracting.git
	cd xian-contracting && git checkout $(CONTRACTING_BRANCH)
	mkdir -p ./.bds.db

pull:
	cd xian-core && git pull
	cd xian-contracting && git pull

checkout:
	cd xian-core && git fetch && git checkout $(CORE_BRANCH) && git pull
	cd xian-contracting && git fetch && git checkout $(CONTRACTING_BRANCH) && git pull


# ::: Contracting Dev Commands
# ::: For developing on / running tests on the xian-contracting package

contracting-dev-up:
	docker-compose -f docker-compose-contracting.yml up -d
	docker-compose -f docker-compose-contracting.yml exec contracting /bin/bash

contracting-dev-build:
	docker-compose -f docker-compose-contracting.yml build


contracting-dev-down:
	docker-compose -f docker-compose-contracting.yml down


# ::: Core Dev Commands
# ::: For developing on / running tests on the xian-core package

core-dev-build:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml -f docker-compose-core-bds.yml build

core-dev-up:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml -f docker-compose-core-bds.yml up -d

core-dev-down:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml -f docker-compose-core-bds.yml down

core-dev-shell:
	make core-dev-up
	docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml exec -w /usr/src/app/xian-core core /bin/bash

# ::: Core Commands
# ::: For running a xian-node

core-build:
	docker-compose -f docker-compose-core.yml build

core-up:
	docker-compose -f docker-compose-core.yml up -d

core-down:
	docker-compose -f docker-compose-core.yml down

core-shell:
	make core-up
	docker-compose -f docker-compose-core.yml exec  -w /usr/src/app/xian-core core /bin/bash

# ::: Core BDS Commands 
# ::: For running a xian-node with Blockchain Data Service enabled

core-bds-build:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml build

core-bds-up:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml up -d

core-bds-down:
	docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml down

core-bds-shell:
	make core-bds-up
	docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml exec -w /usr/src/app/xian-core core /bin/bash

wipe-bds:
	rm -rf ./.bds.db/*

# ::: Core Node Commands
# ::: For interacting with cometbft / xian core running inside a container
# ::: container must be UP, see make commands core-dev-up / core-up / core-bds-up

wipe:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make wipe"

wipe-all:
	make wipe-bds
	make wipe

dwu:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make dwu"

down:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make down"

up:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make up"

init:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make init"


# '--moniker some-node-moniker --genesis-file-name genesis-devnet.json --validator-privkey priv_key --seed-node <seed_ip> --copy-genesis --service-node'

configure:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core/src/xian/tools/ && python configure.py ${CONFIGURE_ARGS}"

node-id:
	docker-compose -f docker-compose-core.yml exec -T core /bin/bash -c "cd xian-core && make node-id"