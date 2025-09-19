FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y build-essential git libssl-dev && \
    git clone https://github.com/openwall/john.git /opt/john && \
    cd /opt/john/src && \
    ./configure && make -sj4

WORKDIR /opt/john/run

CMD ["bash"]
