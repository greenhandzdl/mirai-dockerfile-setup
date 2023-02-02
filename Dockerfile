FROM oraclelinux:8 as builder

MAINTAINER greenhandzdl@gmail.com

#https://github.com/oracle/docker-images
RUN set -eux; \
	dnf install -y tar; 
ENV LANG en_US.UTF-8
ENV JAVA_URL=https://download.oracle.com/java/17/latest \
	JAVA_HOME=/usr/java/jdk-17
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
	ARCH="$(uname -m)" && \
	# Java uses just x64 in the name of the tarball
        if [ "$ARCH" = "x86_64" ]; \
        then ARCH="x64"; \
        fi && \
        JAVA_PKG="$JAVA_URL"/jdk-17_linux-"${ARCH}"_bin.tar.gz ; \
	JAVA_SHA256="$(curl "$JAVA_PKG".sha256)" ; \ 
	curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
	echo "$JAVA_SHA256" */tmp/jdk.tgz | sha256sum -c; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1
FROM oraclelinux:8
ENV LANG en_US.UTF-8
ENV	JAVA_HOME=/usr/java/jdk-17
ENV	PATH $JAVA_HOME/bin:$PATH	
COPY --from=builder $JAVA_HOME $JAVA_HOME
RUN set -eux; \
	dnf -y update; \
	dnf install -y \
		freetype fontconfig \
	; \
	rm -rf /var/cache/dnf; \
	ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done;

ENV MCL_VERSION=2.1.2

USER root

# 下载MCL
RUN dnf -y update && dnf -y install unzip wget && dnf clean all && \
		mkdir /root/MCL && \
    	cd /root/MCL && \
        wget  https://github.com/iTXTech/mirai-console-loader/releases/download/v${MCL_VERSION}/mcl-${MCL_VERSION}.zip  && \
		unzip mcl-${MCL_VERSION}.zip && \
		rm mcl-${MCL_VERSION}.zip && \
		wget 这里是你机器人配置文件的地址 &&\
		unzip 解压缩的名字 &&\
		rm mirai-docker.zip &&\
		chmod 777 . &&\
		chmod +x mcl &&\
		chmod +x mcl.jar &&\
		./mcl --update-package org.itxtech:mcl-addon &&\
        ./mcl --update-package org.itxtech:soyuz &&\
        ./mcl --update-package net.mamoe:chat-command --type plugin --channel stable

RUN java -jar ./root/MCL/mcl.jar

CMD java -jar ./root/MCL/mcl.jar