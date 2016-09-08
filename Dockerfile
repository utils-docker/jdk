FROM alpine:3.4
MAINTAINER Fábio Luciano <fabioluciano@php.net>
LABEL Description="Alpine Image with jdk installed"

# Set some variables to continue with the build process
ENV JAVA_VERSION=7 \
  JAVA_UPDATE=79 \
  JAVA_BUILD=15 \
  JAVA_HOME="/usr/lib/jvm/" \
  URL_FRAGMENT="http://download.oracle.com/otn-pub/java/jdk/"
ENV JOINED_VERSION="${JAVA_VERSION}u${JAVA_UPDATE}"
ENV COMPOUND_VERSION="${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}"

WORKDIR /tmp

# Install packages and jdk
RUN apk update \
  && apk --update --no-cache add tar ca-certificates curl \
  && curl -L -b "oraclelicense=accept-securebackup-cookie" \
    $URL_FRAGMENT/$COMPOUND_VERSION/jdk-${JOINED_VERSION}-linux-x64.tar.gz > jdk.tar.gz \
  && directory=$(tar tfz jdk.tar.gz --exclude '*/*') \
  && tar -xzf jdk.tar.gz \
  && mkdir -p $JAVA_HOME && mv $directory/* $JAVA_HOME \
  && ln -s $JAVA_HOME/bin/* /usr/bin/ \

# Cleanup instalation
  && apk del curl tar \
  && rm -rf \
    $JAVA_HOME/lib/missioncontrol \
    $JAVA_HOME/lib/visualvm \
    $JAVA_HOME/lib/*javafx* \
    $JAVA_HOME/jre/lib/plugin.jar \
    $JAVA_HOME/jre/lib/ext/jfxrt.jar \
    $JAVA_HOME/jre/bin/javaws \
    $JAVA_HOME/jre/lib/javaws.jar \
    $JAVA_HOME/jre/lib/desktop \
    $JAVA_HOME/jre/plugin \
    $JAVA_HOME/jre/lib/deploy* \
    $JAVA_HOME/jre/lib/*javafx* \
    $JAVA_HOME/jre/lib/*jfx* \
    $JAVA_HOME/jre/lib/amd64/libdecora_sse.so \
    $JAVA_HOME/jre/lib/amd64/libprism_*.so \
    $JAVA_HOME/jre/lib/amd64/libfxplugins.so \
    $JAVA_HOME/jre/lib/amd64/libglass.so \
    $JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so \
    $JAVA_HOME/jre/lib/amd64/libjavafx*.so \
    $JAVA_HOME/jre/lib/amd64/libjfx*.so \
    /var/cache/apk/* \
    /tmp/*
