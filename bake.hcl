group "default" {
  targets = [
    "build-env",
  ]
}

target "istio-proxy" {
context = "."
  dockerfile = "istio-proxy.Dockerfile"
  tags = [
    "morlay/istio-proxy:latest"
  ]
  platforms = [
    "linux/arm64"
  ]
}

target "build-env" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [
    "morlay/istio-proxy-build-env:latest"
  ]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
