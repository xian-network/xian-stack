FROM python:3.11.9-bullseye

RUN apt-get update && apt-get install -y \
    git \
    libhdf5-dev

WORKDIR /usr/src/app


# Here we install the dependencies for contracting and later overwrite this folder with the mounted folder
COPY ./xian-core ./xian-core
COPY ./xian-contracting ./xian-core/xian-contracting

RUN pip install -e ./xian-core
RUN pip install -e ./xian-core/xian-contracting

# Install cometbft

RUN wget https://github.com/cometbft/cometbft/releases/download/v0.38.12/cometbft_0.38.12_linux_amd64.tar.gz \
    && tar -xf cometbft_0.38.12_linux_amd64.tar.gz \
    && rm cometbft_0.38.12_linux_amd64.tar.gz \
    && ./cometbft init


# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install pm2 globally
RUN npm install pm2 -g

RUN pm2 install pm2-logrotate \
    && pm2 set pm2-logrotate:max_size 100M \
    && pm2 set pm2-logrotate:retain 7

# Expose port 26657 for cometbft
EXPOSE 26657
EXPOSE 26656
EXPOSE 26660

CMD ["tail", "-f", "/dev/null"]
