ARG SUBNETEVM_VERSION
ARG AVALANCHEGO_VERSION

FROM avaplatform/avalanchego:${AVALANCHEGO_VERSION} AS avalanchego
FROM avaplatform/subnet-evm:${SUBNETEVM_VERSION} AS subevm

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y wget && groupadd -r nobody || true

COPY --from=avalanchego /avalanchego/build/avalanchego /usr/local/bin/avalanchego
COPY --from=subevm /avalanchego/build/plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy /plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
