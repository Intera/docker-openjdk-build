FROM centos:7

ARG OPENJDK_BUILD_TAG="jdk-11.0.12-ga"

RUN yum install -y java-11-openjdk-devel

RUN yum-builddep -y java-11-openjdk-devel

RUN yum groupinstall -y 'Development Tools'

COPY mercurial.repo /etc/yum.repos.d/mercurial.repo

RUN yum install -y mercurial which

WORKDIR /opt

RUN hg clone http://hg.openjdk.java.net/jdk-updates/jdk11u jdk11u

WORKDIR /opt/jdk11u

RUN hg checkout $OPENJDK_BUILD_TAG

RUN hg pull

RUN bash ./configure  --with-extra-cxxflags="-Wno-error" --with-extra-cflags="-Wno-error"

RUN make all
