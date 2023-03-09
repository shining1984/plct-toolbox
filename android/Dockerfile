FROM ubuntu:20.04

WORKDIR /root/

RUN apt-get update -qq\
    && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y -qq --no-install-recommends \
    python3 python3-pip \
    curl \
    gnupg \
    git \
    ssh

RUN ln /usr/bin/python3 /usr/bin/python
RUN python --version

COPY install_repo.sh ./
RUN bash install_repo.sh
RUN repo version

COPY download_android_source_code.sh ./
RUN bash download_android_source_code.sh

#CMD bash

