# avalanchego-subnetevm
A wrapper around the original AvalancheGo container image with improved configuration handling.

Use at your own risk. Hopefully envconfig will be supported by avalanchego soon, making this image obsolete.

## Example docker-compose.yml

```yaml
services:
  node0:
    container_name: node0
    image: containerman17/avalanchego-subnetevm:v1.12.0_v0.6.12
    volumes:
      - ./data/:/data/
    network_mode: host
    user: "${CURRENT_UID}:${CURRENT_GID}"
    environment:
      # These AVALANCHEGO_* ENV vars are not supported by avalanchego by default, we handle them in the entrypoint.sh
      - AVALANCHEGO_CHAIN_CONFIG_DIR=/data/chains
      - AVALANCHEGO_NETWORK_ID=fuji
      - AVALANCHEGO_DATA_DIR=/data/node0
      - AVALANCHEGO_PLUGIN_DIR=/plugins/
      - AVALANCHEGO_HTTP_PORT=9650
      - AVALANCHEGO_STAKING_PORT=9651
      - AVALANCHEGO_TRACK_SUBNETS=${AVALANCHEGO_TRACK_SUBNETS}
      - AVALANCHEGO_HTTP_ALLOWED_HOSTS=*
      - AVALANCHEGO_HTTP_HOST=0.0.0.0

```

## Tags
| Tag | AvalancheGo Version | Subnet-EVM Version |
|-----|-------------------|-------------------|
| `v1.12.0_v0.6.12` | v1.12.0 | v0.6.12 |
| `v1.12.0-fuji_v0.6.12` | v1.12.0-fuji | v0.6.12 |

## VM ID
The Subnet-EVM VM ID is hardcoded to `srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy`

## ENV Configuration
This image supports all AvalancheGo flags via environment variables in the format: `AVALANCHEGO_<FLAG_NAME>=<VALUE>`. 
Flag names should be uppercase with underscores replacing dashes.

The default value of `AVALANCHEGO_PLUGIN_DIR` is set to `/plugins/` in the entrypoint.sh. That's because the subnet evm plugin is located with the name `srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy` in the `/plugins/` directory.
