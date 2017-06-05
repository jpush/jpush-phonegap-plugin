/* 
 * Author: Derek Chia <snipking@gmail.com>
 * Cordova plugin after hook to disable `Push Notification` capability for XCode 8
 */

const fs = require('fs');
const path = require('path');
let commonFuncs = require('./common');

/**
 * remove APNS env from cordova project Entitlements-Debug.plist and Entitlements-Release.plist
 * This two file will work when xcode archive app
 */
let disablePushNotificationForCI = (basePath, xcodeprojName) => {
    commonFuncs.removeAPNSinEntitlements(basePath + xcodeprojName + '/Entitlements-Debug.plist');
    commonFuncs.removeAPNSinEntitlements(basePath + xcodeprojName + '/Entitlements-Release.plist');
}

/**
 * remove APNS env to entitlement file; disable Push Notification capability in .pbxproj file
 * This two file will work when xcode archive app
 */
let disablePushNotificationForXCode = (entitlementsPath, pbxprojPath) => {
    /**
     * remove APNS env to entitlement file
     */
    if( fs.existsSync(entitlementsPath) ) {
        commonFuncs.removeAPNSinEntitlements(entitlementsPath);
    }
    
    /**
     * disable Push Notification capability in .pbxproj file
     * equally disable "Push Notification" switch in xcode
     */
    fs.readFile(pbxprojPath, "utf8", function(err, data) {
        if (err) {
            throw err;
        }
        console.log("Reading pbxproj file asynchronously");
        
        // turn off Push Notification Capability
        let re4rep = new RegExp('isa = PBXProject;(.|[\r\n])*TargetAttributes(.|[\r\n])*SystemCapabilities(.|[\r\n])*com\.apple\.Push = {(.|[\r\n])*enabled = [01]');
        let parts = re4rep.exec(data);
        result = data.replace(re4rep, parts[0].substr(0, parts[0].length - 1) + '0');
        
        // write result to project.pbxproj
        fs.writeFile(pbxprojPath, result, {"encoding": 'utf8'}, function(err) {
            if (err) {
                throw err;
            }
            console.log(pbxprojPath + " written successfully");
        });
    });
}

let basePath = './platforms/ios/';
let buildType = 'dev';
let xcodeprojName = commonFuncs.getXcodeProjName(basePath);
let pbxprojPath = basePath + xcodeprojName + '.xcodeproj/project.pbxproj';
let entitlementsPath = basePath + xcodeprojName + '/' + xcodeprojName + '.entitlements';

disablePushNotificationForCI(basePath, xcodeprojName);

disablePushNotificationForXCode(entitlementsPath, pbxprojPath);