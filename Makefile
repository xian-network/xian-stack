contracting-dev-up:
	docker-compose -f docker-compose-contracting.yml up -d
	docker-compose -f docker-compose-contracting.yml exec contracting /bin/bash

contracting-dev-build:
	docker-compose -f docker-compose-contracting.yml build
