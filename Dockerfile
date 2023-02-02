FROM oraclelinux:8 as builder

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

# DockerFile目录下需要包含机器人文件
WORKDIR .
# 复制机器人信息，以免登录
COPY bots /root/MCL/bots
COPY plugins /root/MCL/plugins
COPY config /root/MCL/config
COPY data /data/MCL/data

RUN dnf -y update && dnf -y install unzip wget && dnf clean all && \
        cd /root/MCL && \
        wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip && \
        unzip mcl-2.1.2.zip && \
        chmod +x mcl &&\
        ./mcl --update-package org.itxtech:mcl-addon &&\
        ./mcl --update-package org.itxtech:soyuz &&\
        ./mcl --update-package net.mamoe:chat-command --type plugin --channel stable &&\
	./mcl &