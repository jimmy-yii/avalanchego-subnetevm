#!/bin/bash

set -exuo pipefail

# Set up QEMU for multi-architecture builds
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Set up buildx builder
docker buildx create --name mybuilder --use || true
docker buildx inspect mybuilder --bootstrap

# Architectures
ARCHITECTURES=("amd64" "arm64")

# Add specific versions
AVALANCHEGO_VERSIONS+=("v1.12.0" "v1.12.1")
SUBNETEVM_VERSIONS+=("v0.6.12" "v0.7.0")

# Pull AvalancheGo images first
for avalanche_version in "${AVALANCHEGO_VERSIONS[@]}"; do
  echo "Pulling AvalancheGo ${avalanche_version}"
  docker pull "avaplatform/avalanchego:${avalanche_version}"
done

# Pull Subnet-EVM images first 
for subnet_version in "${SUBNETEVM_VERSIONS[@]}"; do
  echo "Pulling Subnet-EVM ${subnet_version}"
  docker pull "avaplatform/subnet-evm:${subnet_version}"
done

# Modified build process using buildx
for avalanche_version in "${AVALANCHEGO_VERSIONS[@]}"; do
  for subnet_version in "${SUBNETEVM_VERSIONS[@]}"; do
    echo "Building for AvalancheGo ${avalanche_version} and Subnet-EVM ${subnet_version}"
    
    # Create manifest list name
    MANIFEST="containerman17/avalanchego-subnetevm:${avalanche_version}_${subnet_version}"
    
    # Build and push all architectures in one command
    docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --build-arg AVALANCHEGO_VERSION="${avalanche_version}" \
      --build-arg SUBNETEVM_VERSION="${subnet_version}" \
      -t "${MANIFEST}" \
      --push \
      .
  done
done

