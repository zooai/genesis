# ZOO Network Data Extraction Report

## Summary

I successfully found ZOO network blockchain data in the PostgreSQL database at 192.168.1.99. The data appears to be stored in a shared blockscout database rather than the ZOO-specific databases.

## Database Connections

### Working Connection
- **Host**: 192.168.1.99
- **Database**: blockscout
- **User**: lux
- **Password**: oi1dAc9bad8MSc2da51a2544f0cb8e16lb21A

### Empty ZOO-specific Databases
The following databases exist but contain no data:
- explorer_zoonet
- blockscout_zoonet
- stats_zoonet
- accounts_zoonet
- user_ops_zoonet

## Blockchain Data Found

### Network Information
- **Chain ID**: 200200 (ZOO Mainnet)
- **Genesis Block**: November 1, 2024 at 07:39:46 UTC
- **First Activity**: November 13, 2024 at 19:53:54 UTC (Block 1)
- **Latest Block**: 1,082,780
- **Total Blocks**: 1,082,781

### Transaction Data
- **Total Transactions**: 1,229,884
- **Recent Activity**: Ongoing transactions up to block 1,082,780

### Account Data
- **Total Addresses**: 300
- **Top Balance Holder**: 0x9011e888251ab053b7bd1cdb598db4f9ded94714
  - Balance: 1,994,739,905,397,278,683,064,838,288,203 wei (approximately 1.99M ZOO)

### Token Data
- **Total Tokens**: 35
- **Notable Tokens**:
  - LZOO (Lux ZOO): 0x5e5290f350352768bd2bfc59c2da15dd04a7cb88
  - LUSD (Lux Dollar): 0x848cff46eb323f323b6bbe1df274e40793d7f2c2
  - Various bridged tokens (LETH, LBTC, LSOL, etc.)
  - Meme tokens (TRUMP, MELANIA, CYRUS)

## Graph Node Data (Uniswap)

### Database: graph_zoonet
- **Uniswap V3 Data** (schema: sgd20)
  - Tokens: 289
  - Pools: 148
  - Transactions: 141
  - Swaps: 110

- **Uniswap V2 Data** (schema: sgd2)
  - Pairs: 1

### Key Tokens in Uniswap
- WLUX (Wrapped LUX): 0x4888e4a2ee0f03051c72d2bd3acf755ed3498b3e
- ZLUX (Zoo LUX): 0x5e5290f350352768bd2bfc59c2da15dd04a7cb88
- ZUSD (Zoo Dollar): 0x848cff46eb323f323b6bbe1df274e40793d7f2c2
- USDC: 0x8031e9b0d02a792cfefaa2bdca6e1289d385426f
- USDT: 0xdf1de693c31e2a5eb869c329529623556b20abf3

## Data Extraction Commands

### Export All Addresses with Balances
```bash
PGPASSWORD=oi1dAc9bad8MSc2da51a2544f0cb8e16lb21A psql -h 192.168.1.99 -U lux -d blockscout -c "\COPY (SELECT hash as address, fetched_coin_balance as balance FROM addresses WHERE fetched_coin_balance > 0 ORDER BY fetched_coin_balance DESC) TO '/tmp/zoo_addresses.csv' WITH CSV HEADER;"
```

### Export All Transactions
```bash
PGPASSWORD=oi1dAc9bad8MSc2da51a2544f0cb8e16lb21A psql -h 192.168.1.99 -U lux -d blockscout -c "\COPY (SELECT hash, block_number, from_address_hash, to_address_hash, value, gas, gas_price, input FROM transactions ORDER BY block_number) TO '/tmp/zoo_transactions.csv' WITH CSV HEADER;"
```

### Export Token Information
```bash
PGPASSWORD=oi1dAc9bad8MSc2da51a2544f0cb8e16lb21A psql -h 192.168.1.99 -U lux -d blockscout -c "\COPY (SELECT contract_address_hash, symbol, name, decimals, total_supply FROM tokens) TO '/tmp/zoo_tokens.csv' WITH CSV HEADER;"
```

### Export Uniswap V3 Data
```bash
PGPASSWORD=oi1dAc9bad8MSc2da51a2544f0cb8e16lb21A psql -h 192.168.1.99 -U lux -d graph_zoonet -c "\COPY (SELECT * FROM sgd20.token) TO '/tmp/zoo_uniswap_v3_tokens.csv' WITH CSV HEADER;"
```

## Notes

1. The ZOO network data is stored in the main `blockscout` database, not in the ZOO-specific databases
2. The network has been active since November 13, 2024
3. There's significant DeFi activity with Uniswap V2 and V3 deployments
4. The data includes both native ZOO tokens and various bridged assets from other chains
5. The graph node is actively indexing Uniswap data for the ZOO network

## Recommendations

To extract complete ZOO network data:
1. Use the `blockscout` database with the `lux` user credentials
2. Filter data by timestamp (after November 1, 2024) to ensure only ZOO network data
3. Consider also extracting data from the graph_zoonet database for DeFi-specific information
4. The addresses table contains the current state of all accounts
5. The transactions table contains the full transaction history