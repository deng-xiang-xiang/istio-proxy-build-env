target "build-env-amd64" {
  context = "."
  dockerfile = "build-env.Dockerfile"
  tags = [
    "morlay/istio-proxy-build-env:latest-amd64"
  ]
  platforms = [
    "linux/amd64"
  ]
}

target "build-env-arm64" {
  context = "."
  dockerfile = "build-env.Dockerfile"
  tags = [
    "morlay/istio-proxy-build-env:latest-arm64"
  ]
  platforms = [
    "linux/arm64"
  ]
}
