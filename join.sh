#!/bin/bash

TARGET_IMAGE=${1};
IFS=":" read -r -a TARGET_REPO_VERSION <<< "${1}"
TARGET_REPO=${TARGET_REPO_VERSION[0]}

TARGET_IMAGE_AMD64=${1}-amd64;
TARGET_IMAGE_ARM64=${1}-arm64;

echo "[${TARGET_REPO}] creating ${TARGET_IMAGE} by ${TARGET_IMAGE_AMD64} ${TARGET_IMAGE_ARM64}";

docker pull "${TARGET_IMAGE_AMD64}";
docker pull "${TARGET_IMAGE_ARM64}";

AMD64_SHA=$(docker images --format "{{.Repository}}:{{.Tag}}\t{{.Digest}}" | grep "${TARGET_IMAGE_AMD64}" | awk '{ printf $2 }');
ARM64_SHA=$(docker images --format "{{.Repository}}:{{.Tag}}\t{{.Digest}}" | grep "${TARGET_IMAGE_ARM64}" | awk '{ printf $2 }');

docker buildx imagetools create -t "${TARGET_IMAGE}" "${TARGET_REPO}@${AMD64_SHA}" "${TARGET_REPO}@${ARM64_SHA}"