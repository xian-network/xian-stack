### What is this ?
- A standardised environment using Docker for :
- Running the Xian Node
- Running a Xian Node / Blockchain Data Service (BDS) w/ Postgres DB
- Developing the xian-core / xian-contracting packages
- Running unit tests

### How it works
- The necessary environments are configured & built by Docker.
- `xian-contracting`, `xian-core`, `.cometbft` & `.bds.db` folders are mounted from the host machine inside the docker containers.
- Any changes to these folders on the host machine are reflected in the docker containers, and visa-versa

#### Prerequisites
1. Install Docker
    - [MacOS](https://docs.docker.com/desktop/install/mac-install/)
    - [Windows](https://docs.docker.com/desktop/install/windows-install/)
    - Linux
        - `curl -fsSL https://get.docker.com -o get-docker.sh`
        - `sudo sh get-docker.sh`
        - `sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
        - `sudo chmod +x /usr/local/bin/docker-compose`

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

*For running a xian-node with postgres for BDS*

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

#### To run a node (in shell)
1. Build the container :
    - `make core-build` / `make core-dev-build` / `make core-bds-build`
1. Enter the shell :
    - `make core-dev-shell` / `make core-shell` / `make core-bds-shell`
2. Start the node :
    - `make up`
3. Stop the node :
    - `make down`
4. Exit the shell when finished
    - `exit`

##### To run a node (without shell)
1. Start the container:
    - `make core-dev-up` / `make core-up` / `make core-bds-up`
2. Start the node:
    - `make up`
3. Stop the node:
    - `make down`
4. Stop the container:
    - `make core-dev-down`

