debug-arm:
    docker run -it -e=ISTIO_PROXY_VERSION=1.6.1 -v=/tmp/arm:/root/.cache morlay/istio-proxy-build-env:latest-arm64

rebuild-build-env:
	git tag -f build-env && git push -f origin build-env

rebuild-istio-proxy:
	git tag -f istio-proxy && git push -f origin istio-proxy