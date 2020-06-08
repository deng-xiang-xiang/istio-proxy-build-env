group "default" {
  targets = [
    "build-env",
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
