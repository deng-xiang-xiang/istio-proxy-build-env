build:
	docker buildx bake -f bake.hcl istio-proxy --load

build.build-env:
	docker buildx bake -f bake.hcl --push	

	