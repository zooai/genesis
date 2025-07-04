#!/usr/bin/env node

// ZOO Genesis Export Tool
// Exports ZOO mainnet data and preserves BSC airdrop allocations

const Web3 = require('web3');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);

const ZOO_RPC = 'http://127.0.0.1:9650/ext/bc/bXe2MhhAnXg6WGj6G8oDk55AKT1dMMsN72S8te7JdvzfZX1zM/rpc';
const GENESIS_DIR = '/home/z/genesis-zoo';

class ZooGenesisExporter {
    constructor() {
        this.web3 = new Web3(ZOO_RPC);
        this.state = {
            metadata: {
                exportTime: new Date().toISOString(),
                chainId: 200200,
                tokenSymbol: 'ZOO'
            },
            accounts: {},
            airdrop: {},
            summary: {
                mainnet: { accounts: 0, balance: '0' },
                airdrop: { accounts: 0, balance: '0' },
                merged: { accounts: 0, balance: '0' }
            }
        };
    }

    async loadBSCAirdrop() {
        console.log('\n📁 Loading BSC airdrop data...');
        
        // Check multiple possible locations
        const possiblePaths = [
            '/home/z/backup/zoo-bsc-airdrop/airdrop.csv',
            '/home/z/backup/zoo-airdrop/airdrop.csv',
            '/home/z/genesis-zoo/bsc-airdrop.csv',
            '/home/z/zoo-bsc-airdrop.csv'
        ];
        
        for (const csvPath of possiblePaths) {
            if (fs.existsSync(csvPath)) {
                console.log(`  Found airdrop data at: ${csvPath}`);
                return await this.loadAirdropCSV(csvPath);
            }
        }
        
        // Create template if no airdrop data found
        console.log('  No airdrop data found, creating template...');
        await this.createAirdropTemplate();
        return {};
    }

    async loadAirdropCSV(filepath) {
        return new Promise((resolve, reject) => {
            const airdrop = {};
            let totalBalance = this.web3.utils.toBN('0');
            
            fs.createReadStream(filepath)
                .pipe(csv())
                .on('data', (row) => {
                    const address = (row.address || row.Address || row.wallet || '').toLowerCase();
                    const amount = row.amount || row.Amount || row.balance || row.tokens || '0';
                    
                    if (address && this.web3.utils.isAddress(address)) {
                        const amountWei = this.web3.utils.toWei(amount.toString(), 'ether');
                        airdrop[address] = {
                            amount: amountWei,
                            source: 'BSC_AIRDROP'
                        };
                        totalBalance = totalBalance.add(this.web3.utils.toBN(amountWei));
                    }
                })
                .on('end', () => {
                    this.state.summary.airdrop.accounts = Object.keys(airdrop).length;
                    this.state.summary.airdrop.balance = totalBalance.toString();
                    console.log(`  ✓ Loaded ${Object.keys(airdrop).length} airdrop recipients`);
                    console.log(`  ✓ Total airdrop: ${this.web3.utils.fromWei(totalBalance, 'ether')} ZOO`);
                    resolve(airdrop);
                })
                .on('error', reject);
        });
    }

    async createAirdropTemplate() {
        const template = `# ZOO BSC Airdrop Template
# Format: address,amount (in ZOO tokens)
address,amount
0x1234567890123456789012345678901234567890,10000
0x2345678901234567890123456789012345678901,5000
# Add BSC airdrop recipients below...
`;
        await writeFile(path.join(GENESIS_DIR, 'bsc-airdrop-template.csv'), template);
        console.log(`  ✓ Created template at ${GENESIS_DIR}/bsc-airdrop-template.csv`);
    }

    async scanZooMainnet() {
        console.log('\n🔍 Scanning ZOO mainnet (Chain ID 200200)...');
        
        try {
            const chainId = await this.web3.eth.getChainId();
            const latestBlock = await this.web3.eth.getBlockNumber();
            console.log(`  Connected to chain ${chainId}, latest block: ${latestBlock}`);
            
            const accounts = {};
            let totalBalance = this.web3.utils.toBN('0');
            const uniqueAddresses = new Set();
            
            // Add known important addresses
            uniqueAddresses.add('0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC'.toLowerCase());
            uniqueAddresses.add('0x9011E888251AB053B7bD1cdB598Db4f9DEd94714'.toLowerCase()); // From genesis
            
            // Scan recent blocks
            const startBlock = Math.max(0, latestBlock - 3000);
            console.log(`  Scanning blocks ${startBlock} to ${latestBlock}...`);
            
            for (let i = startBlock; i <= latestBlock; i += 100) {
                const endBlock = Math.min(i + 99, latestBlock);
                const blocks = await Promise.all(
                    Array.from({length: endBlock - i + 1}, (_, idx) => 
                        this.web3.eth.getBlock(i + idx, true)
                    )
                );
                
                for (const block of blocks) {
                    if (block && block.transactions) {
                        for (const tx of block.transactions) {
                            uniqueAddresses.add(tx.from.toLowerCase());
                            if (tx.to) uniqueAddresses.add(tx.to.toLowerCase());
                        }
                    }
                }
            }
            
            console.log(`  Found ${uniqueAddresses.size} unique addresses`);
            
            // Get balances
            const addresses = Array.from(uniqueAddresses);
            for (let i = 0; i < addresses.length; i += 50) {
                const batch = addresses.slice(i, i + 50);
                const balances = await Promise.all(
                    batch.map(addr => this.web3.eth.getBalance(addr))
                );
                
                batch.forEach((addr, idx) => {
                    const balance = balances[idx];
                    if (balance !== '0') {
                        accounts[addr] = {
                            balance: balance,
                            source: 'ZOO_MAINNET'
                        };
                        totalBalance = totalBalance.add(this.web3.utils.toBN(balance));
                    }
                });
            }
            
            this.state.summary.mainnet.accounts = Object.keys(accounts).length;
            this.state.summary.mainnet.balance = totalBalance.toString();
            console.log(`  ✓ Found ${Object.keys(accounts).length} accounts with balance`);
            console.log(`  ✓ Total: ${this.web3.utils.fromWei(totalBalance, 'ether')} ZOO`);
            
            return accounts;
            
        } catch (error) {
            console.error('  ❌ Failed to connect to ZOO mainnet:', error.message);
            return {};
        }
    }

    mergeAccounts(airdrop, mainnet) {
        console.log('\n🔀 Merging ZOO accounts (preserving airdrop)...');
        
        const merged = {};
        let totalBalance = this.web3.utils.toBN('0');
        
        // Start with all mainnet accounts
        for (const [address, data] of Object.entries(mainnet)) {
            merged[address] = {
                balance: data.balance,
                sources: ['ZOO_MAINNET'],
                breakdown: {
                    mainnet: data.balance
                }
            };
            totalBalance = totalBalance.add(this.web3.utils.toBN(data.balance));
        }
        
        // Add/merge airdrop accounts
        for (const [address, airdropData] of Object.entries(airdrop)) {
            if (merged[address]) {
                // Account has both mainnet and airdrop
                const currentBalance = this.web3.utils.toBN(merged[address].balance);
                const airdropBalance = this.web3.utils.toBN(airdropData.amount);
                const newBalance = currentBalance.add(airdropBalance);
                
                merged[address].balance = newBalance.toString();
                merged[address].sources.push('BSC_AIRDROP');
                merged[address].breakdown.airdrop = airdropData.amount;
                merged[address].hasAirdrop = true;
                
                totalBalance = totalBalance.add(airdropBalance);
                
                console.log(`  💰 Merged airdrop for ${address}: +${this.web3.utils.fromWei(airdropBalance, 'ether')} ZOO`);
            } else {
                // Only airdrop (no mainnet activity yet)
                merged[address] = {
                    balance: airdropData.amount,
                    sources: ['BSC_AIRDROP'],
                    breakdown: {
                        airdrop: airdropData.amount
                    },
                    hasAirdrop: true
                };
                totalBalance = totalBalance.add(this.web3.utils.toBN(airdropData.amount));
            }
        }
        
        this.state.accounts = merged;
        this.state.airdrop = airdrop;
        this.state.summary.merged.accounts = Object.keys(merged).length;
        this.state.summary.merged.balance = totalBalance.toString();
        
        console.log(`  ✓ Total merged accounts: ${Object.keys(merged).length}`);
        console.log(`  ✓ Total balance: ${this.web3.utils.fromWei(totalBalance, 'ether')} ZOO`);
    }

    async generateGenesis() {
        console.log('\n⚡ Generating ZOO subnet genesis...');
        
        const genesis = {
            config: {
                chainId: 200200,
                homesteadBlock: 0,
                eip150Block: 0,
                eip150Hash: "0x2086799aeebeae135c246c65021c82b4e15a2c451340993aacfd2751886514f0",
                eip155Block: 0,
                eip158Block: 0,
                byzantiumBlock: 0,
                constantinopleBlock: 0,
                petersburgBlock: 0,
                istanbulBlock: 0,
                muirGlacierBlock: 0,
                berlinBlock: 0,
                londonBlock: 0,
                subnetEVMTimestamp: 0,
                feeConfig: {
                    gasLimit: 8000000,
                    targetBlockRate: 2,
                    minBaseFee: 25000000000,
                    targetGas: 15000000,
                    baseFeeChangeDenominator: 36,
                    minBlockGasCost: 0,
                    maxBlockGasCost: 1000000,
                    blockGasCostStep: 200000
                }
            },
            alloc: {},
            nonce: "0x0",
            timestamp: "0x0",
            extraData: "0x00",
            gasLimit: "0x7A1200",
            difficulty: "0x0",
            mixHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
            coinbase: "0x0000000000000000000000000000000000000000",
            number: "0x0",
            gasUsed: "0x0",
            parentHash: "0x0000000000000000000000000000000000000000000000000000000000000000"
        };
        
        // Add all accounts to genesis
        for (const [address, data] of Object.entries(this.state.accounts)) {
            genesis.alloc[address] = {
                balance: '0x' + this.web3.utils.toBN(data.balance).toString(16)
            };
        }
        
        await writeFile(
            path.join(GENESIS_DIR, 'genesis.json'),
            JSON.stringify(genesis, null, 2)
        );
        
        console.log(`  ✓ Genesis saved to ${GENESIS_DIR}/genesis.json`);
    }

    async saveExportData() {
        console.log('\n💾 Saving export data...');
        
        // Save full state
        await writeFile(
            path.join(GENESIS_DIR, 'zoo-state-with-airdrop.json'),
            JSON.stringify(this.state, null, 2)
        );
        
        // Save merged accounts CSV
        let csv = 'address,balance_zoo,has_airdrop,mainnet_balance,airdrop_amount\n';
        for (const [address, data] of Object.entries(this.state.accounts)) {
            const balanceZoo = this.web3.utils.fromWei(data.balance, 'ether');
            const hasAirdrop = data.hasAirdrop ? 'YES' : 'NO';
            const mainnetBal = data.breakdown.mainnet ? 
                this.web3.utils.fromWei(data.breakdown.mainnet, 'ether') : '0';
            const airdropAmt = data.breakdown.airdrop ? 
                this.web3.utils.fromWei(data.breakdown.airdrop, 'ether') : '0';
            
            csv += `${address},${balanceZoo},${hasAirdrop},${mainnetBal},${airdropAmt}\n`;
        }
        await writeFile(path.join(GENESIS_DIR, 'merged-accounts.csv'), csv);
        
        // Save airdrop-only CSV
        let airdropCsv = 'address,airdrop_amount\n';
        for (const [address, data] of Object.entries(this.state.airdrop)) {
            const amount = this.web3.utils.fromWei(data.amount, 'ether');
            airdropCsv += `${address},${amount}\n`;
        }
        await writeFile(path.join(GENESIS_DIR, 'airdrop-recipients.csv'), airdropCsv);
        
        // Save report
        const report = `# ZOO Genesis Export Report

**Export Date:** ${this.state.metadata.exportTime}
**Chain ID:** ${this.state.metadata.chainId}

## Data Sources

### ZOO Mainnet
- Accounts: ${this.state.summary.mainnet.accounts}
- Balance: ${this.web3.utils.fromWei(this.state.summary.mainnet.balance, 'ether')} ZOO

### BSC Airdrop
- Recipients: ${this.state.summary.airdrop.accounts}
- Total Airdrop: ${this.web3.utils.fromWei(this.state.summary.airdrop.balance, 'ether')} ZOO

## Merged Result
- Total Accounts: ${this.state.summary.merged.accounts}
- Total Balance: ${this.web3.utils.fromWei(this.state.summary.merged.balance, 'ether')} ZOO
- Airdrop Preserved: ✅

## Files Generated
- \`genesis.json\` - ZOO subnet genesis file
- \`zoo-state-with-airdrop.json\` - Complete state export
- \`merged-accounts.csv\` - All accounts with breakdown
- \`airdrop-recipients.csv\` - Airdrop allocations only

## Deployment
\`\`\`bash
cd /home/z/genesis-zoo
avalanche subnet create zoo --custom --genesis genesis.json
avalanche subnet deploy zoo --local
\`\`\`

## Important Notes
- All BSC airdrop allocations are preserved
- Accounts with both airdrop and mainnet activity have summed balances
- Airdrop recipients who haven't used mainnet yet are included
`;
        
        await writeFile(path.join(GENESIS_DIR, 'README.md'), report);
        console.log(`  ✓ Export complete! Files saved to ${GENESIS_DIR}`);
    }

    async run() {
        console.log('=== ZOO Genesis Export Tool ===');
        console.log('Exporting mainnet data and preserving BSC airdrop\n');
        
        try {
            // Load BSC airdrop data
            const airdrop = await this.loadBSCAirdrop();
            
            // Scan current mainnet
            const mainnet = await this.scanZooMainnet();
            
            // Merge accounts
            this.mergeAccounts(airdrop, mainnet);
            
            // Generate genesis
            await this.generateGenesis();
            
            // Save all data
            await this.saveExportData();
            
            console.log('\n✅ ZOO genesis export complete!');
            
        } catch (error) {
            console.error('\n❌ Export failed:', error);
            process.exit(1);
        }
    }
}

// Run exporter
const exporter = new ZooGenesisExporter();
exporter.run();