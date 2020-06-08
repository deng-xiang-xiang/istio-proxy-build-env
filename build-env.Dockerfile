FROM ubuntu:18.04
ARG TARGETARCH

ENV DEBIAN_FRONTEND noninteractive

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
    virtualenv \
    python \
    vim \
    g++ \
    wget \
    ninja-build \
    curl \
    lsb-core \
    software-properties-common \
    openjdk-8-jdk \
    ca-certificates-java

RUN set -eux; \
    \
    case "${TARGETARCH}" in \
        amd64) BAZELISK_URL=https://github.com/bazelbuild/bazelisk/releases/download/latest/bazelisk-linux-amd64;; \
        arm64) BAZELISK_URL=https://github.com/Tick-Tocker/bazelisk-arm64/releases/download/arm64/bazelisk-linux-arm64;; \
     *) echo "unsupported architecture"; exit 1 ;; \
    esac; \
    wget -O /usr/local/bin/bazel ${BAZELISK_URL}; \
    chmod +x /usr/local/bin/bazel

# fix hsdis-aarch64.so
RUN set -eux; \
    \
    case "${TARGETARCH}" in \
        amd64) \
        ;; \
        arm64) \
            cd /usr/lib/jvm; \
            git clone --depth=1 https://github.com/AdoptOpenJDK/openjdk-jdk8u.git; \
            cd openjdk-jdk8u/hotspot/src/share/tools/hsdis;  \
            wget https://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.gz; \
            tar -xzf binutils-2.29.tar.gz; \
            sed -ri 's/development=.*/development=false/' ./binutils-2.29/bfd/development.sh; \
            make BINUTILS=binutils-2.29 ARCH=aarch64; \
            mkdir -p /usr/lib/jvm/java-8-openjdk-arm64/jre/lib/aarch64/server/; \
            cp build/linux-aarch64/hsdis-aarch64.so /usr/lib/jvm/java-8-openjdk-arm64/jre/lib/aarch64/server/; \
            rm -rf /usr/lib/jvm/openjdk-jdk8u; \
        ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac;


ENV GOVERSION=1.14.4

RUN set -eux; \
    \
    curl -LO https://dl.google.com/go/go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    tar -C /usr/local -xzf go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    rm go${GOVERSION}.linux-${TARGETARCH}.tar.gz; \
    export PATH=$PATH:/usr/local/go/bin; \
    export PATH=$PATH:/root/go/bin; \
    export GOPATH=$HOME/go; \
    go get -u github.com/bazelbuild/buildtools/buildifier; \
    export BUILDIFIER_BIN=$GOPATH/bin/buildifier; \
    go get -u github.com/bazelbuild/buildtools/buildozer; \
    export BUILDOZER_BIN=$GOPATH/bin/buildozer;

ENV LLVM_VERSION=9.0.0
ENV LLVM_PATH=/usr/lib/llvm-9

RUN set -eux; \
    \
    case "${TARGETARCH}" in \
    amd64) export LLVM_RELEASE=clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04;; \
    arm64) export LLVM_RELEASE=clang+llvm-${LLVM_VERSION}-aarch64-linux-gnu;; \
    *) echo "unsupported architecture"; exit 1 ;; \
    esac; \
    curl -LO  "https://releases.llvm.org/${LLVM_VERSION}/${LLVM_RELEASE}.tar.xz"; \
    tar Jxf "${LLVM_RELEASE}.tar.xz"; \
    mv "./${LLVM_RELEASE}" ${LLVM_PATH}; \
    chown -R root:root ${LLVM_PATH}; \
    rm "./${LLVM_RELEASE}.tar.xz"; \
    echo "${LLVM_PATH}/lib" > /etc/ld.so.conf.d/llvm.conf; \
    ldconfig; \
    export PATH=${LLVM_PATH}/bin:${PATH};
