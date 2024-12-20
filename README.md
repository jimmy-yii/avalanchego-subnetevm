# avalanchego-subnetevm
A wrapper around the original AvalancheGo container image with improved configuration handling.

Use at your own risk. Hopefully envconfig will be supported by avalanchego soon, making this image obsolete.

## Example command

```bash
docker run -it -d \
  --name avalanchego \
  --network host \
  -v ~/.avalanchego:/home/avalanche/.avalanchego \
  -e AVALANCHEGO_NETWORK_ID=fuji \
  -e AVALANCHEGO_HTTP_ALLOWED_HOSTS=* \
  -e AVALANCHEGO_HTTP_HOST=0.0.0.0 \
  -e AVALANCHEGO_PARTIAL_SYNC_PRIMARY_NETWORK=true \
  -e HOME=/home/avalanche \
  --user $(id -u):$(id -g) \
  containerman17/avalanchego-subnetevm:v1.12.1_v0.7.0

```

## Recommended Tags
| Tag | AvalancheGo Version | Subnet-EVM Version |
|-----|-------------------|-------------------|
| `v1.12.1_v0.7.0` | v1.12.1 | v0.7.0 |

## VM ID
The Subnet-EVM VM ID is hardcoded to `srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy`

## ENV Configuration
This image supports all AvalancheGo flags via environment variables in the format: `AVALANCHEGO_<FLAG_NAME>=<VALUE>`. 
Flag names should be uppercase with underscores replacing dashes.

The default value of `AVALANCHEGO_PLUGIN_DIR` is set to `/plugins/` in the entrypoint.sh. That's because the subnet evm plugin is located with the name `srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy` in the `/plugins/` directory.

## signer.key
If you provide a BLS key in the `BLS_KEY_BASE64` environment variable, it will be written to the `signer.key` file in the `staking` directory.

