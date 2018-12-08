const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');

// find path to the build folder...
const buildPath = path.resolve(__dirname, 'build');

// and fs-extra just deletes it synchronously (think of this like Nuxtjs creating a whole nuxt folder for deploy but tearing it down and rebuilding every time you rerun the code.)
fs.removeSync(buildPath);

// here we define our path to the solidity file, read the file, and use the solidity compiler to read the file's contracts (in this case there are two).
const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');
const output = solc.compile(source, 1).contracts;

// This checks to see if the build folder exists (it does not) and creates it if it cannot find it. So essentially this creates the build folder.
fs.ensureDirSync(buildPath);

// this loops through the contracts generated by the solc compiler...
for (let contract in output) {
  // outputs json synchronously..
  fs.outputJsonSync(
    // and writes the respective contract as a json file in the newly created build folder.
    path.resolve(buildPath, contract.replace(':', '') + '.json'),
    output[contract]
  );
}