FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ARG OPENJDK_BUILD_TAG="jdk-17.0.5+3"

RUN sed -i -E "s/^# deb-src (.+)/deb-src \1/g" /etc/apt/sources.list

RUN apt-get update && apt-get -y dist-upgrade \
    && apt-get install -y build-essential \
    && apt-get build-dep -y openjdk-17-jre --dry-run | grep "Inst" | cut -d " " -f2 > /var/openjdk_build_deps.txt \
    && apt-get build-dep -y openjdk-17-jre \
    && apt-get install -y git \
    && apt-get --purge -y autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/openjdk/jdk17u.git jdk17u

WORKDIR /opt/jdk17u

RUN git checkout $OPENJDK_BUILD_TAG

RUN bash ./configure

RUN make images

RUN ./build/*/images/jdk/bin/java -version

# Disabled for now, needs jtreg
#RUN make run-test-tier1
