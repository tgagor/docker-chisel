# Build the chiselled filesystem based on the desired slices.
FROM ubuntu:{{ .ubuntu }}
ARG UBUNTU_RELEASE={{ .ubuntu }}
ARG TARGETARCH
ARG CHISEL_VERSION={{ .chisel }}

ENV DEBIAN_FRONTEND=noninteractive
VOLUME ["/tmp", "/var/tmp", "/var/cache/apt"]

RUN apt-get update && \
    apt-get install -y \
        curl \
        git && \
    curl -fsSLo chisel.tar.gz https://github.com/canonical/chisel/releases/download/$CHISEL_VERSION/chisel_${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz && \
    tar xvf chisel.tar.gz -C /usr/local/bin/ && \
    rm -f chisel.tar.gz && \
    apt-get purge -y curl

RUN apt-get update && \
    apt-get install -y git \
    git clone https://github.com/canonical/chisel-releases.git /releases && \
    cd /releases && \
    git switch -c $UBUNTU_RELEASE

WORKDIR /rootfs

CMD ["chisel"]
