FROM ubuntu:18.04

ARG TARGETARCH

ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/go/bin:${PATH}"

RUN set -eux; \
    \ 
    apt-get update; \
    apt-get install -y \ 
    build-essential \
    apt-utils \
    unzip \
    git \
    make \
    cmake \
    automake \
    autoconf \
    libtool \
    xz-utils \
    virtualenv \
    python \
    vim \
    g++ \
    wget \
    ninja-build \
    curl \
    lsb-core \
    software-properties-common \
    openjdk-8-jdk;

ENV BAZEL_VERSION="3.1.0"

RUN set -eux; \
    \
    mkdir bazel && cd bazel; \
    wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip; \
    unzip bazel-${BAZEL_VERSION}-dist.zip; \
    EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh;


ENV GOVERSION=1.14.4

RUN set -eux; \
    \
    curl -LO https://dl.google.com/go/go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    tar -C /usr/local -xzf go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    rm go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc; \
    echo 'export PATH=$PATH:/root/go/bin' >> ~/.bashrc; \
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc; \
    go get -u github.com/bazelbuild/buildtools/buildifier; \
    echo 'export BUILDIFIER_BIN=$GOPATH/bin/buildifier' >> ~/.bashrc; \
    go get -u github.com/bazelbuild/buildtools/buildozer; \
    echo 'export BUILDOZER_BIN=$GOPATH/bin/buildozer' >> ~/.bashrc

ENV LLVM_VERSION=9.0.0
ENV LLVM_PATH=/usr/lib/llvm

RUN set -eux; \
    \ 
    case "${TARGETARCH}" in \
    amd64) export LLVM_ARCHIVE=clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04;; \
    arm64) export LLVM_ARCHIVE=clang+llvm-${LLVM_VERSION}-aarch64-linux-gnu;; \
    *) echo "unsupported architecture"; exit 1 ;; \
    esac; \
    curl -LO  "https://releases.llvm.org/${LLVM_VERSION}/${LLVM_ARCHIVE}.tar.xz"; \
    tar -Jxf "${LLVM_ARCHIVE}.tar.xz"; \
    mv "./${LLVM_ARCHIVE}" ${LLVM_PATH}; \
    chown -R root:root ${LLVM_PATH}; \
    rm "./${LLVM_ARCHIVE}.tar.xz"; \
    echo "${LLVM_PATH}/lib" > /etc/ld.so.conf.d/llvm.conf; \
    ldconfig; \
    echo "export PATH=${LLVM_PATH}/bin:${PATH}" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]