### What is this ?
- A standardised environment, using Docker for developing the xian-core / xian-contracting packages, running unit tests, and running a node.

### How it works
- The necessary environments are configured & built by Docker.
- xian-contracting, xian-core & .cometbft folders are mounted from the host machine inside the docker containers.
- Any changes to these folders on the host machine are reflected in the docker containers.

#### Prerequisites
1. Install Docker
    - [MacOS](https://docs.docker.com/desktop/install/mac-install/)
    - [Windows](https://docs.docker.com/desktop/install/windows-install/)
    - [Linux](https://docs.docker.com/desktop/install/linux-install/)
2. Pull xian repositories
    - `make setup`

#### Contracting Dev Quickstart 
1. Clone Contracting
    - `git clone https://github.com/xian-network/contracting`
    - (optional) : create a new feature branch for making changes to contracting
        - `git checkout -b <new-branch-name>`
2. Build the environment
    - `make contracting-dev-build`
3. Start the container shell
    - `make contracting-dev-up`
4. Run contracting unit tests
    - `pytest contracting/`
5. When you're finished
    - from the test-shell `exit`

#### Core Dev Quickstart

##### Build & Initialise
1. Build the xian core environment
    - `make core-dev-build`
2. Start the xian core container shell
    - `make core-dev-shell`
3. Initialise CometBFT
    - `make init`

##### To run tests :
1. Enter the test shell :
    - `make core-dev-shell`
2. Run tests:
    - `pytest xian-core/tests/`
3. Exit the shell when finished
    - `exit`

##### To run a node (in shell)
1. Enter the shell :
    - `make core-dev-shell`
2. Start the node :
    - `make up`
3. Stop the node :
    - `make down`
4. Exit the shell when finished
    - `exit`

##### To run a node (without shell)
1. Start the container:
    - `make core-dev-up`
2. Start the node:
    - `make up`
3. Stop the node:
    - `make down`
4. Stop the container:
    - `make core-dev-down`

