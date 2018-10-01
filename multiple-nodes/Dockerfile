FROM ubuntu:16.04 as builder

WORKDIR /work
RUN apt-get update && \
    apt-get install -y \
            build-essential \
            git \
            libdb-dev \
            libsodium-dev \
            libtinfo-dev \
            sysvbanner \
            unzip \
            wget \
            wrk \
            zlib1g-dev
        
RUN wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.0.1-alpha/ubuntu1604.zip && \
    unzip ubuntu1604.zip && \
    cp ubuntu1604/constellation-node /usr/local/bin && \
    chmod 0755 /usr/local/bin/constellation-node && \
    cp ubuntu1604/constellation-enclave-keygen /usr/local/bin/ && \
    chmod 0755 /usr/local/bin/constellation-enclave-keygen && \
    rm -rf ubuntu1604.zip ubuntu1604
    
ENV GOREL go1.7.3.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin