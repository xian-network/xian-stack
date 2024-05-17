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

pull-testnet:
	cd xian-core
	git pull origin testnet
	cd ../xian-contracting
	git pull origin testnet
