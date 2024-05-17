FROM python:3.11.9-bullseye

RUN apt-get update && apt-get install -y \
    git \
    libhdf5-dev

WORKDIR /usr/src/app

RUN pip install pytest

# Here we install the dependencies for contracting and later overwrite this folder with the mounted folder
COPY ./xian-core ./xian-core
COPY ./xian-contracting ./xian-core/xian-contracting

RUN pip install -e ./xian-core
RUN pip install -e ./xian-core/xian-contracting

# Install cometbft

RUN wget https://github.com/cometbft/cometbft/releases/download/v0.38.7/cometbft_0.38.7_linux_amd64.tar.gz \
    && tar -xf cometbft_0.38.7_linux_amd64.tar.gz \
    && rm cometbft_0.38.7_linux_amd64.tar.gz \
    && ./cometbft init


# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install pm2 globally
RUN npm install pm2 -g


# Expose port 26657 for cometbft
EXPOSE 26657

CMD ["tail", "-f", "/dev/null"]
