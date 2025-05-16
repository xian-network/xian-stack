# Xian Stack Quickstart

This guide will get you up and running with the Xian blockchain stack as quickly as possible. For advanced details, see the **Reference** section at the end.

---

## 1. Prerequisites

### 1.1 Install Docker & Docker Compose
- **Mac:** [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Linux:** [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)

> **Note:** Docker Desktop (Mac) includes Docker Compose. On Linux, install Docker Compose separately after Docker Engine.

### 1.2 Clone the Repositories

```bash
make setup CORE_BRANCH=mainnet CONTRACTING_BRANCH=mainnet
```
This will pull all required Xian repositories.

---

## 2. Running a Xian Node (Core Only)

### 2.1 Build the Environment
```bash
make core-build
```

### 2.2 Start the Node Docker Container
```bash
make core-up
```

### 2.3 Initialize cometbft
```bash
make init
```

### 2.4 Configure the Node
```bash
make configure CONFIGURE_ARGS='--moniker "<your node name>" --genesis-file-name "genesis-mainnet.json" --validator-privkey "<your validator privatekey>" --seed-node-address "c3861ffd16cf6708aef6683d3d0471b6dedb3116@152.53.18.220:26656" --copy-genesis'
```

### 2.5 Enter the Core Shell
```bash
make core-shell
```

### 2.6 Start the node
```bash
make up
```

### 2.7 View the logs to ensure the node is running
```bash
pm2 logs --lines 1000
```

### 2.8 Exit the Core Shell (the node will continue to run in the background)
```bash
exit
```

### 2.9 Stop the Node
```bash
make core-down
```

---

## 3. Running a Node with Blockchain Data Service (BDS)

### 3.1 Build the Environment
```bash
make core-bds-build
```

### 3.2 Start the Node Docker Container with BDS
```bash
make core-bds-up
```

### 3.3 Initialize cometbft
```bash
make init
```

### 3.4 Configure the Node
```bash
make configure CONFIGURE_ARGS='--moniker "<your node name>" --genesis-file-name "genesis_mainnet.json" --validator-privkey "<your validator privatekey>" --seed-node-address "c3861ffd16cf6708aef6683d3d0471b6dedb3116@152.53.18.220" --copy-genesis --service-node'
```

### 3.5 Enter the BDS Shell
```bash
make core-bds-shell
```

### 3.6 Start the node
```bash
make up-bds
```

### 3.7 View the logs to ensure the node is running
```bash
pm2 logs --lines 1000
```

### 3.8 Exit the BDS Shell (the node will continue to run in the background)
```bash
exit
```

### 3.9 Stop the Node
```bash
make core-bds-down
```

---

## 4. Running a Node in Development Mode (Core Dev)

### 4.1 Build the Dev Environment
```bash
make core-dev-build
```

### 4.2 Start the Dev Node Docker Container
```bash
make core-dev-up
```

### 4.3 Initialize cometbft
```bash
make init
```

### 4.4 Configure the Node
```bash
make configure CONFIGURE_ARGS='--moniker "<your node name>" --genesis-file-name "genesis_mainnet.json" --validator-privkey "<your validator privatekey>" --seed-node-address "c3861ffd16cf6708aef6683d3d0471b6dedb3116@152.53.18.220:26656" --copy-genesis --service-node'
```

### 4.5 Enter the Dev Shell
```bash
make core-dev-shell
```

### 4.6 Start the node
```bash
make up
```

### 4.7 View the logs to ensure the node is running
```bash
pm2 logs --lines 1000
```

### 4.8 Exit the Dev Shell (the node will continue to run in the background)
```bash
exit
```

### 4.9 Stop the Node
```bash
make core-dev-down
```

---

## 5. Contracting Development Quickstart

### 5.1 Clone Contracting (if not already done)
```bash
git clone https://github.com/xian-network/contracting
cd contracting
# (Optional) Create a new feature branch
# git checkout -b <new-branch-name>
```

### 5.2 Build the Contracting Dev Environment
```bash
make contracting-dev-build
```

### 5.3 Start the Contracting Dev Shell
```bash
make contracting-dev-up
```

### 5.4 Run Contracting Unit Tests
```bash
pytest contracting/
```

### 5.5 Exit the Shell
```bash
exit
```

---

## 6. Running Tests for Core

### 6.1 Enter the Core Dev Shell
```bash
make core-dev-shell
```

### 6.2 Run Core Tests
```bash
pytest xian-core/tests/
```

### 6.3 Exit the Shell
```bash
exit
```

---

## 7. Useful Makefile Shortcuts

| Action | Command |
|--------|---------|
| Start node (core only) | `make core-up` |
| Start node with BDS | `make core-bds-up` |
| Start dev environment with BDS | `make core-dev-up` |
| Stop node | `make down` |
| Stop container | `make core-dev-down` |

---

## 8. (Optional) Firewall Configuration (Linux Only)

If you are running on Ubuntu/Debian, you may want to secure your node with UFW:

```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 26656/tcp comment 'Tendermint P2P'
sudo ufw allow 26657/tcp comment 'Tendermint RPC'
sudo ufw allow 26660/tcp comment 'Tendermint Prometheus'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw enable
sudo ufw status numbered
```
> **Warning:** Always allow SSH before enabling UFW to avoid locking yourself out.

---

## 9. Troubleshooting

- **Docker permission errors:** Try running with `sudo` or add your user to the `docker` group.
- **Ports already in use:** Make sure no other services are using the required ports (26656, 26657, 26660, 5000).
- **Containers not starting:** Run `docker-compose ps` or `docker ps` to check status. Use `docker-compose logs` for details.
- **Database connection issues:** Ensure the `xian-db` network is running and not blocked by firewall.

---

# Reference

## Docker Networking
- `xian-net`: Main network for service communication and internet access. Exposes ports 26657, 26656, 26660, 5000.
- `xian-db`: Isolated network for database access (PostgreSQL only accessible within this network).

## Docker Compose File Combinations
- `docker-compose-core.yml`: Base config for Xian node
- `docker-compose-core-dev.yml`: Adds dev settings
- `docker-compose-core-bds.yml`: Adds BDS with PostgreSQL

Combine with `-f` flag, e.g.:
```bash
docker-compose -f docker-compose-core.yml -f docker-compose-core-bds.yml up
```

## Makefile Shortcuts (Reference)
- `make up` — Start node without BDS
- `make up-bds` — Start node with BDS
- `make core-up` — Start node (core only)
- `make core-bds-up` — Start node with BDS
- `make core-dev-up` — Start dev environment with BDS
- `make down` — Stop node
- `make core-dev-down` — Stop container

## Advanced: Initializing CometBFT
If you need to initialize CometBFT manually:
```bash
make core-dev-shell
make init
```

---

For more details, see the comments in each Docker Compose file or the Makefile.

