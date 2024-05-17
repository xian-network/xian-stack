FROM python:3.11.9-bullseye

RUN apt-get update && apt-get install -y \
    git \
    libhdf5-dev

WORKDIR /usr/src/app

RUN pip install pytest

# Here we install the dependencies for contracting and later overwrite this folder with the mounted folder
COPY ./xian-contracting ./xian-contracting
RUN pip install -e ./xian-contracting
RUN pip install xian-py

CMD ["tail", "-f", "/dev/null"]
