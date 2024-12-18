ARG SUBNETEVM_VERSION=wrong_tag_to_supress_warning
ARG AVALANCHEGO_VERSION=wrong_tag_to_supress_warning

FROM avaplatform/avalanchego:${AVALANCHEGO_VERSION} AS avalanchego
FROM avaplatform/subnet-evm:${SUBNETEVM_VERSION} AS subevm

FROM debian:bookworm-slim

COPY --from=avalanchego /avalanchego/build/avalanchego /usr/local/bin/avalanchego
COPY --from=subevm /avalanchego/build/plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy /plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
