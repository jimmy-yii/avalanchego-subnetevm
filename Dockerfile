# # # # # # # # # # # # # # 
# AvalancheGo builder
# # # # # # # # # # # # # # 

FROM golang:1.22-bookworm AS avalanchego-builder

ARG AVALANCHEGO_VERSION=v1.12.0

WORKDIR /app

RUN git clone https://github.com/ava-labs/avalanchego.git && cd avalanchego && git checkout ${AVALANCHEGO_VERSION} && ./scripts/build.sh

# # # # # # # # # # # # # # 
# Subnet-EVM builder
# # # # # # # # # # # # # # 

FROM golang:1.22-bookworm AS subnet-evm-builder

ARG SUBNETEVM_VERSION=v0.6.12

RUN git clone https://github.com/ava-labs/subnet-evm.git /app/subnet-evm && cd /app/subnet-evm && git checkout ${SUBNETEVM_VERSION}

RUN cd /app/subnet-evm && go build -v -o /app/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy ./plugin

# # # # # # # # # # # # # # 
# Execution
# # # # # # # # # # # # # # 

FROM debian:bookworm-slim

RUN apt-get update 
RUN apt-get install -y wget

# Create nobody group if it doesn't exist
RUN groupadd -r nobody || true

COPY --from=avalanchego-builder /app/avalanchego/build/avalanchego /usr/local/bin/avalanchego
COPY --from=subnet-evm-builder /app/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy /plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
