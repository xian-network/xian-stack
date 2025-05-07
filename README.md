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

### Prerequisites
#### Install Docker Engine & Docker Compose

##### Windows
- **Docker Desktop for Windows**: [Installation Guide](https://docs.docker.com/desktop/install/windows-install/)
  - Includes Docker Engine, Docker CLI, Docker Compose, and other tools in a single installation
  - Requirements: Windows 10/11 64-bit with WSL 2 backend

##### Mac
- **Docker Desktop for Mac**: [Installation Guide](https://docs.docker.com/desktop/install/mac-install/)
  - Available for both Intel and Apple Silicon
  - Includes Docker Engine, Docker CLI, Docker Compose, and other Docker tools
  - Requirements: macOS 11 or newer (Big Sur and above)

##### Linux
- **Docker Engine**: [Installation Guide](https://docs.docker.com/engine/install/)
  - [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
  - [Debian](https://docs.docker.com/engine/install/debian/)
  - [CentOS](https://docs.docker.com/engine/install/centos/)
  - [Fedora](https://docs.docker.com/engine/install/fedora/)

- **Docker Compose**: [Installation Guide](https://docs.docker.com/compose/install/)
  - For Linux, Docker Compose is installed separately after Docker Engine
  - Can be installed via package manager or by downloading the binary directly

*Note: Docker Desktop for Windows and Mac already include Docker Compose, while on Linux systems you'll need to install Docker Engine first and then Docker Compose as a separate step.*

2. Pull xian repositories
    ```bash
    make setup
    ```

#### Firewall Configuration (UFW)
For secure operation, configure the Ubuntu/Debian firewall (UFW) with these recommended settings:

```bash
# Install UFW if not already present
sudo apt install ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (Important: add this first to prevent lockout)
sudo ufw allow 22/tcp comment 'SSH'

# Allow required Tendermint ports
sudo ufw allow 26656/tcp comment 'Tendermint P2P'
sudo ufw allow 26657/tcp comment 'Tendermint RPC'
sudo ufw allow 26660/tcp comment 'Tendermint Prometheus'

# Allow web traffic
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Enable UFW
sudo ufw enable

# Verify rules
sudo ufw status numbered
```

Note: Ensure SSH access is allowed before enabling UFW to prevent being locked out of your system.

#### Docker Networking Configuration
The stack uses a secure dual-network configuration:

- `xian-net`: Main network for service communication and internet access
  - Allows containers to download dependencies and packages
  - Used by core services for communication
  - Exposed ports:
    - Core node: 26657, 26656, 26660 (required for blockchain operation)
    - PostGraphile: 5000 (GraphQL API access)

- `xian-db`: Isolated network for database access
  - Internal only, no internet access
  - PostgreSQL is only accessible within this network
  - Provides an additional security layer for database operations

This dual-network setup ensures:
- Containers can download required packages during build and runtime
- Database remains secure and isolated from external access
- Services can communicate as needed while maintaining security boundaries

##### Understanding Docker Compose File Combinations
The stack uses multiple Docker Compose files that can be combined for different purposes:
- `docker-compose-core.yml`: Base configuration for running a Xian node
- `docker-compose-core-dev.yml`: Adds development-specific settings
- `docker-compose-core-bds.yml`: Adds Blockchain Data Service with PostgreSQL

When combining compose files with the `-f` flag, Docker merges them from left to right, with later files overriding settings from earlier ones. For example:
```bash
# Runs core with BDS - combines settings from both files
docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml up

# Runs development environment with BDS - combines all three configurations
docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml -f docker-compose-core-bds.yml up
```

##### Makefile Shortcuts
To simplify these commands, the Makefile provides convenient shortcuts:

```bash
# Start a node without BDS
make up

# Start a node with BDS enabled
make up-bds

# Common combinations with their Makefile equivalents:
# Regular node:
docker-compose -f docker-compose-core.yml up -d    →    make core-up
# Node with BDS:
docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml up -d    →    make core-bds-up
# Development environment with BDS:
docker-compose -f docker-compose-core.yml -f docker-compose-core-dev.yml -f docker-compose-core-bds.yml up -d    →    make core-dev-up
```

These Makefile commands handle both starting the containers and running the node. For example, `make up-bds` is equivalent to running the containers with BDS and starting the node with BDS enabled.

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

##### To run a node (in shell)
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

