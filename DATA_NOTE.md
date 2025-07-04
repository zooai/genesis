# ZOO Network Data Note

## Current State

The ZOO network was launched on November 13, 2024 with chain ID 200200.

### Genesis Allocation
- Initial supply: 2,000,000,000,000 ZOO (2 trillion)
- Single allocation to: `0x9011E888251AB053B7bD1cdB598Db4f9DEd94714`

### Blockchain Data Status
- Network has been running since November 2024
- Blockchain data exists in `/home/z/.avalanche-cli/runs/network_20241113_190424/`
- Data size: ~705MB per node
- However, the Blockscout explorer was never properly configured for ZOO

### Data Export Attempt
When attempting to export ZOO balances from the PostgreSQL database at 192.168.1.99, we discovered that the `blockscout` database actually contains LUX network data, not ZOO data. The ZOO-specific databases (explorer_zoonet, blockscout_zoonet, etc.) exist but are empty.

### Recovery Options
To get ZOO network balance data:
1. Start the ZOO network with the correct chain ID (200200)
2. Configure and run Blockscout properly to index the blockchain
3. Export balances after indexing is complete

### Graph Node Data
The graph_zoonet database does contain some Uniswap indexing data for ZOO, indicating DeFi activity on the network.