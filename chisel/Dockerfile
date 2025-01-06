# Build the chiselled filesystem based on the desired slices.
ARG UBUNTU_RELEASE=24.04
FROM ubuntu:$UBUNTU_RELEASE AS fetcher
ARG TARGETARCH
ARG CHISEL_VERSION=v1.0.0
ENV DEBIAN_FRONTEND=noninteractive
VOLUME ["/tmp", "/var/tmp", "/var/cache/apt"]

ADD https://github.com/canonical/chisel/releases/download/$CHISEL_VERSION/chisel_${CHISEL_VERSION}_linux_${TARGETARCH}.tar.gz /opt/chisel/
RUN cd /opt/chisel/ && \
    tar xvf *.tar.gz && \
    rm -f *.tar.gz && \
    ln -s /opt/chisel/chisel /usr/local/bin/chisel && \
    apt-get update && \
    apt-get install -y \
        ca-certificates

# ADD https://github.com/canonical/chisel-releases.git#ubuntu-${UBUNTU_RELEASE} /releases

WORKDIR /rootfs

CMD ["chisel"]
