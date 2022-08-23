FROM centos:7

ARG OPENJDK_BUILD_TAG="jdk-17.0.5+3"

RUN yum install -y java-1-openjdk-devel

RUN yum-builddep -y java-11-openjdk-devel

RUN yum groupinstall -y 'Development Tools'

COPY mercurial.repo /etc/yum.repos.d/mercurial.repo

RUN yum install -y git which

WORKDIR /opt

RUN git clone https://github.com/openjdk/jdk17u.git jdk17u

WORKDIR /opt/jdk17u

RUN git checkout $OPENJDK_BUILD_TAG

RUN bash ./configure

RUN make images

RUN ./build/*/images/jdk/bin/java -version

RUN make run-test-tier1
