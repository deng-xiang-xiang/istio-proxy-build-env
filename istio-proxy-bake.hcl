target "istio-proxy-amd64" {
  context = "."
  dockerfile = "istio-proxy.Dockerfile"
  tags = [
    "morlay/istio-proxyv2:1.6.1-amd64"
  ]
  args = {
    ARCH = "amd64"
    VERSION = "1.6.1"
  }
  platforms = [
    "linux/amd64"
  ]
}

target "istio-proxy-arm64" {
  context = "."
  dockerfile = "istio-proxy.Dockerfile"
  tags = [
    "morlay/istio-proxyv2:1.6.1-arm64"
  ]
  args = {
    ARCH = "arm64"
    VERSION = "1.6.1"
  }
  platforms = [
    "linux/arm64"
  ]
}
