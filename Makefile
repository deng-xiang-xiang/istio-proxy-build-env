build:
	sh ./join.sh morlay/istio-proxy-build-env:latest

rebuild-build-env:
	git tag -f build-env && git push -f origin build-env
	