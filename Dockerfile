FROM centos:7

ARG OPENJDK_BUILD_TAG="jdk-17.0.5+3"

RUN yum install -y java-17-openjdk-devel

RUN yum-builddep -y java-17-openjdk-devel

RUN yum groupinstall -y 'Development Tools'

RUN yum install -y git which

WORKDIR /opt

RUN git clone https://github.com/openjdk/jdk17u.git jdk17u

WORKDIR /opt/jdk17u

RUN git checkout $OPENJDK_BUILD_TAG

RUN bash ./configure

RUN make images

RUN ./build/*/images/jdk/bin/java -version

RUN make run-test-tier1
