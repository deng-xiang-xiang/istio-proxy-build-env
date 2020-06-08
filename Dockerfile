FROM envoyproxy/envoy-build-ubuntu:78d0e79e619c823d52d192a9b2fd030f66c5ac2c

ARG TARGETARCH

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
