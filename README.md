# Docker Chisel

Docker Chisel is a tool for managing and optimizing Docker images and containers. It generates Docker images with Chisel and Chisel releases for specific Ubuntu versions, which can be used as a base for the builder pattern.

## Usage

To use this base image with Chisel:

```Dockerfile
FROM tgagor/chisel:24.04 AS builder
ARG UBUNTU_RELEASE=24.04

RUN chisel cut --release ubuntu-$UBUNTU_RELEASE --root /rootfs \
        base-files_base \
        base-files_release-info \
        dash_bins

# Add a tool you need
ADD https://github.com/the-tool/the-tool/releases/download/v1.2.3/the-tool-linux-amd64 /rootfs/usr/local/bin/the-tool
RUN chmod +x /rootfs/usr/local/bin/the-tool

FROM scratch
COPY --from=builder /rootfs /
RUN the-tool -v
```
