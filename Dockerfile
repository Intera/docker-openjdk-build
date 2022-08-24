FROM centos:7

ARG OPENJDK_BUILD_TAG="jdk-17.0.5+3"

RUN yum install -y centos-release-scl

RUN yum install -y devtoolset-9-toolchain

WORKDIR /opt/jdk-install

RUN yum install -y wget \
    && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm \
    && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm.sha256 \
    && sha256sum jdk-17_linux-x64_bin.rpm.sha256 \
    && yum install -y ./jdk-17_linux-x64_bin.rpm \
    && yum remove -y wget \
    && rm jdk-17_linux-x64_bin.rpm jdk-17_linux-x64_bin.rpm.sha256

RUN yum install -y git

WORKDIR /opt

RUN git clone https://github.com/openjdk/jdk17u.git jdk17u

WORKDIR /opt/jdk17u

RUN git checkout $OPENJDK_BUILD_TAG

RUN yum install -y alsa-lib-devel autoconf cups-devel file fontconfig-devel unzip zip

RUN yum install -y libXtst-devel libXt-devel libXrender-devel libXrandr-devel libXi-devel

RUN scl enable devtoolset-9 "bash ./configure"

RUN scl enable devtoolset-9 "make jdk-image"

RUN ./build/*/images/jdk/bin/java -version

# # Disabled for now, needs jtreg
# #RUN make run-test-tier1
