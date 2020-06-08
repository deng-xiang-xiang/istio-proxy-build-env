FROM morlay/istio-proxy-build-env:latest as builder

ARG TARGETARCH

ENV ISTIO_PROXY_VERSION 1.6.0

RUN set -eux; \
    \
    wget https://github.com/istio/proxy/archive/${ISTIO_PROXY_VERSION}.zip; \
    unzip ./${ISTIO_PROXY_VERSION}.zip; \
    mkdir -p /root/go; \
    mv ./proxy-${ISTIO_PROXY_VERSION}/ /root/go/proxy; \
    cd /root/go/proxy; \
    git config --global user.email "you@example.com"; \
    git init && git add . && git commit -m "init";

WORKDIR /root/go/proxy

RUN make build_envoy

FROM busybox

COPY --from=builder /proxy /proxy