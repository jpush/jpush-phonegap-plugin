/*
 * Author: Derek Chia <snipking@gmail.com>
 * common functions for cordova plugin after hook
 */
const fs = require('fs');
const path = require('path');

module.exports.addAPNSinEntitlements = (entitlementPath, isProduction) => {
    fs.readFile(entitlementPath, "utf8", function(err, data) {
        if (err) {
            throw err;
        }

        console.log("Reading entitlements file asynchronously");

        let toInsert = '<key>aps-environment</key>\n' +
                       '\t\t<string>development</string>';
        if(isProduction) {
            toInsert = '<key>aps-environment</key>\n' +
                       '\t\t<string>production</string>';
        }

        let re1 = new RegExp('<key>aps-environment<\/key>(.|[\r\n])*<string>.*<\/string>');
        let matched = data.match(re1);
        let result;
        if (matched === null) {
            if(data.match(/<\/dict>/g)) {
                result = data.replace(/<\/dict>/, '\t' + toInsert + '\n\t</dict>');
            } else if(data.match(/<dict\/>/g)) {
                result = data.replace(/<dict\/>/, '\t<dict>\n\t\t' + toInsert + '\n\t</dict>');
            }
        } else {
            result = data.replace(re1, toInsert);
        }

        // write result to entitlements file
        fs.writeFile(entitlementPath, result, {"encoding": 'utf8'}, function(err) {
            if (err) {
                throw err;
            }
            console.log(entitlementPath + " written successfully");
        });
    });
}

module.exports.removeAPNSinEntitlements = (entitlementPath) => {
    fs.readFile(entitlementPath, "utf8", function(err, data) {
        if (err) {
            throw err;
        }

        console.log("Reading entitlements file asynchronously");

        let re1 = new RegExp('<key>aps-environment<\/key>(.|[\r\n])*<string>.*<\/string>');
        let matched = data.match(re1);
        let result;
        if (matched != null) {
            result = data.replace(re1, "");
        }

        // write result to entitlements file
        fs.writeFile(entitlementPath, result, {"encoding": 'utf8'}, function(err) {
            if (err) {
                throw err;
            }
            console.log(entitlementPath + " written successfully");
        });
    });
}

module.exports.getXcodeProjName = (searchPath) => {
    if(searchPath == null || searchPath == undefined) {
        searchPath = './';
    }
    let resultFolderName = null;
    let folderNames = fs.readdirSync(searchPath).filter(file => fs.lstatSync(path.join(searchPath, file)).isDirectory());
    let folderNamesReg = new RegExp('.*\.xcodeproj', 'g')  // get filder name like `*.xcodeproj`
    for(let folderName of folderNames) {
        if(folderName.match(folderNamesReg)) {
            resultFolderName = folderName;
            break;
        }
    }
    return resultFolderName.substr(0, resultFolderName.length - 10);
}
