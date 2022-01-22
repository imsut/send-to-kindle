FROM ubuntu:focal

RUN apt-get update -y && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    calibre \
    mpack \
    python-lxml \
    python3 \
    python3-pyqt5 \
    python3-pythonmagick \
    && rm -rf /var/lib/apt/lists/*

ADD send-to-kindle.sh /usr/local/bin/send-to-kindle.sh

ENTRYPOINT ["send-to-kindle.sh"]
