ARG ARCH

FROM morlay/istio-proxy-build-env:latest-${ARCH} as builder

ARG TARGETARCH

ENV ISTIO_PROXY_VERSION 1.6.0

WORKDIR /go/src

RUN set -eux; \
    \
    wget https://github.com/istio/proxy/archive/${ISTIO_PROXY_VERSION}.zip; \
    unzip ./${ISTIO_PROXY_VERSION}.zip; \
    mkdir -p /go/src; \
    mv ./proxy-${ISTIO_PROXY_VERSION}/ /go/src/proxy; \
    cd /go/src/proxy; \
    git config --global user.email "you@example.com"; \
    git init && git add . && git commit -m "init";

WORKDIR /go/src/proxy

RUN set -eux; \
    \
    export PATH="${LLVM_PATH}/bin:${PATH}"; \
    export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"; \
    export BAZEL_BUILD_ARGS="--verbose_failures --define=ABSOLUTE_JAVABASE=${JAVA_HOME} --javabase=@bazel_tools//tools/jdk:absolute_javabase --host_javabase=@bazel_tools//tools/jdk:absolute_javabase --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla"; \
    make build_envoy; \
    mkdir -p /envoy; \
    cp -r bazel-bin/src/envoy /envoy

FROM busybox

COPY --from=builder /envoy /envoy