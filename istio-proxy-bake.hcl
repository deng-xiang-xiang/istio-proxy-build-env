target "istio-proxy-amd64" {
  context = "."
  dockerfile = "istio-proxy.Dockerfile"
  tags = [
    "morlay/istio-proxyv2:1.6.0-amd64"
  ]
  args = {
    ARCH = "amd64"
  }
  platforms = [
    "linux/amd64"
  ]
}

target "istio-proxy-arm64" {
  context = "."
  dockerfile = "istio-proxy.Dockerfile"
  tags = [
    "morlay/istio-proxyv2:1.6.0-arm64"
  ]
  args = {
    ARCH = "arm64"
  }
  platforms = [
    "linux/arm64"
  ]
}
