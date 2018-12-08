const path = require('path');
const fs = require('fs');
const solc = require('solc');

const lotteryPath = path.resolve(__dirname, 'contract', 'Lottery.sol');

const src = fs.readFileSync(lotteryPath, 'utf8');

module.exports = solc.compile(src, 1).contracts[':Lottery'];