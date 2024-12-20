

# ==============================================================================
# AVALANCHEGO STAGE
# Imports the AvalancheGo binary
# ==============================================================================
ARG AVALANCHEGO_VERSION

FROM avaplatform/avalanchego:v${AVALANCHEGO_VERSION} AS avalanchego


FROM debian:bookworm-slim AS subevm_builder

# ==============================================================================
# SUBNET-EVM BUILDER STAGE
# ==============================================================================
RUN apt-get update && apt-get install -y wget
RUN mkdir -p /subnet-evm

ARG TARGETARCH
ARG SUBNETEVM_VERSION
RUN echo "Downloading subnet-evm version ${SUBNETEVM_VERSION} for ${TARGETARCH}" && \
    wget -O subnet-evm.tar.gz "https://github.com/ava-labs/subnet-evm/releases/download/v${SUBNETEVM_VERSION}/subnet-evm_${SUBNETEVM_VERSION}_linux_${TARGETARCH}.tar.gz" && \
    tar -xzf subnet-evm.tar.gz -C /subnet-evm

# ==============================================================================
# FINAL STAGE
# Combines binaries and sets up the runtime environment
# ==============================================================================
FROM debian:bookworm-slim

COPY --from=avalanchego /avalanchego/build/avalanchego /usr/local/bin/avalanchego
COPY --from=subevm_builder /subnet-evm/subnet-evm /plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
