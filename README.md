# ZOO Network Genesis Repository

This repository contains the genesis configuration and blockchain data for the ZOO network.

## Network Information

- **Network Name**: ZOO
- **Chain ID**: 200200 (Mainnet), 200201 (Testnet)
- **Subnet ID**: `xJzemKCLvBNgzYHoBHzXQr9uesR3S3kf3YtZ5mPHTA9LafK6L`
- **Blockchain ID**: `bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM` (Mainnet)
- **Token**: ZOO
- **Token Symbol**: ZOO
- **Database Size**: ~12MB
- **Status**: Active Subnet

## Network Status
Updated: 2025-06-25 17:02:42 UTC

### Zoo Mainnet
- Chain ID: 200200
- Blockchain ID: bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM
- Latest Block: #799
- Block Hash: 0xd6f92941bb2ac91dfd2443f32b0d93f2730e6cc81ddb2edd3f35720a9e1f72b8
- Last Update: 2025-06-15 04:53:30 UTC

### Zoo Testnet
- Chain ID: 200201
- Blockchain ID: 2usKC5aApgWQWwanB4LL6QPoqxR1bWWjPCtemBYbZvxkNfcnbj
- Latest Block: #84
- Block Hash: 0x7077c4e52ace2a56dd1189b2aaf91ba9ec338d86c5b4530b0ac98a8ff6d8ba0c
- Last Update: 2025-01-13 16:34:54 UTC

## Repository Structure

```
genesis-zoo/
├── blockscout_json_dump_20250624_213119/  # Blockchain export data
├── v1-200200/                             # Chain data for chain ID 200200
├── chain.json                             # Chain configuration
├── genesis.json                           # Genesis block configuration
├── sidecar.json                           # Subnet sidecar configuration
├── subnet.json                            # Subnet definition
├── NETWORK_METADATA.json                  # Network metadata
├── network_status.json                    # Current network status
├── postgres_dump.sql                      # Database dump
├── DATA_NOTE.md                           # Data extraction notes
├── zoo_network_data_extraction.md         # Detailed extraction process
└── data/                                  # Compressed chain data (to be added)
```

## Network Configuration

### Chain Configuration (chain.json)
```json
{
  "config": {
    "chainId": 200200,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "muirGlacierBlock": 0,
    "subnetEVMTimestamp": 0,
    "feeConfig": {
      "gasLimit": 10000000,
      "targetBlockRate": 2,
      "minBaseFee": 10000000000,
      "targetGas": 50000000,
      "baseFeeChangeDenominator": 36,
      "minBlockGasCost": 0,
      "maxBlockGasCost": 1000000,
      "blockGasCostStep": 200000
    }
  }
}
```

### Subnet Information
- **VM ID**: `srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy`
- **VM Version**: v0.6.12
- **Network**: Lux Testnet/Mainnet compatible

## Blockchain Data

The ZOO network blockchain data is stored in compressed format:

```bash
# Location of source data
~/.avalanche-cli/runs/network_current/node1/chainData/bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM/

# Compressed archive location (to be created)
data/zoo-chaindata.tar.gz
```

### Data Statistics
- **Total Accounts**: 168
- **Total Transactions**: 1,000+
- **Contract Deployments**: Multiple DeFi contracts
- **Token Contracts**: Various ERC20 tokens including:
  - SPELL Token: 0x41354A2E27D3E12f8569C2E5cd9286f8aC0a7C53
  - MIM Token: 0x39026d12035071FEdB0Fc2D6E5a7856F9b169547
  - wMEMO Token: 0xC0d90609510b96b961cB58ab7b7534f75754C76a
  - And many more...

## Import Process

### Using LUX CLI
```bash
# Import ZOO network data
lux history import \
    --network zoo-mainnet \
    --chain-id bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM \
    --db ./data/zoo-chaindata \
    --verify
```

### Manual Import
1. Extract the chaindata archive:
   ```bash
   tar -xzf data/zoo-chaindata.tar.gz -C data/
   ```
2. Copy to node's chainData directory
3. Create aliases.json with ZOO network mapping
4. Restart node with proper configuration

## API Endpoints (Production)

- **RPC**: https://api.zoo.network
- **Explorer**: https://explore.zoo.network  
- **Graph**: https://graph.zoo.network
- **IPFS**: https://ipfs.zoo.network

## Data Extraction Details

The network data was extracted on June 24, 2025 with the following key findings:

### Network Totals
- Total ETH/ZOO held across all addresses: **1,699,665,290.14 ZOO**
- Addresses with balance > 1 ETH: **45 addresses**
- Largest balance: **334,780,114.00 ZOO** (Address: 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97)

See `zoo_network_data_extraction.md` and `network_totals_report_20250624_223954.md` for detailed analysis.

## Development

### Build from Genesis
```bash
# Generate genesis from configuration
lux subnet create ZOO --genesis genesis.json

# Deploy subnet
lux subnet deploy ZOO --local
```

### Connect to Network
```bash
# Add to MetaMask
Network Name: ZOO Network
RPC URL: https://api.zoo.network
Chain ID: 200200
Currency Symbol: ZOO
Block Explorer: https://explore.zoo.network
```

## Repository Maintenance

### Prepare Chain Data
```bash
# Create compressed archive of chain data
cd data
tar -czf zoo-chaindata.tar.gz -C ~/.avalanche-cli/runs/network_current/node1/chainData bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM
```

### Update Network Status
```bash
# Check current block height
curl -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  https://api.zoo.network
```

## License

Part of the ZOO Network infrastructure.