Requirements : 

#### What is this ?
- A standardised environment, using Docker for developing the contracting package & running unit tests.

#### Quickstart 
1. Install Docker
    - [MacOS](https://docs.docker.com/desktop/install/mac-install/)
    - [Windows](https://docs.docker.com/desktop/install/windows-install/)
    - [Linux](https://docs.docker.com/desktop/install/linux-install/)
2. Clone Contracting
    - `git clone https://github.com/xian-network/contracting`
    - (optional) : create a new feature branch for making changes to contracting
        - `git checkout -b <new-branch-name>`
3. Build the environment
    - make contracting-dev-build
4. Start the container shell
    - make contracting-dev-up
5. Run contracting unit tests
    - `pytest contracting/`

## TO-DO
- [ ] Bring Contracting tests up to date with Xian improvements
- [ ] Add environment for developing & working on the entire xian stack (xian-core + contracting)
    - [ ] Test harness mocking CometBFT integration
    - [ ] Live environment (CometBFT, xian-core, contracting)
- [ ] Add some example smart contract repositories and associated tests (will add to this over time)

