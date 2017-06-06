/*
 * Author: Derek Chia <snipking@gmail.com>
 * Cordova plugin after hook to enable `Push Notification` capability for XCode 8
 */

const fs = require('fs');
const path = require('path');
let commonFuncs = require('./common');

/**
 * add APNS env to cordova project Entitlements-Debug.plist and Entitlements-Release.plist
 * This two file will work when xcode archive app
 */
let enablePushNotificationForCI = (basePath, xcodeprojName) => {
    commonFuncs.addAPNSinEntitlements(basePath + xcodeprojName + '/Entitlements-Debug.plist', false);
    commonFuncs.addAPNSinEntitlements(basePath + xcodeprojName + '/Entitlements-Release.plist', true);
}

/**
 * add APNS env to entitlement file; enable Push Notification capability in .pbxproj file
 * This two file will work when xcode archive app
 */
let enablePushNotificationForXCode = (entitlementsPath, pbxprojPath, cordovaBuildConfig) => {
    console.log('will enable push notification capability for XCode');
    let needAddEntitlementToPbxproj = false;
    /**
     * add APNS env to entitlement file
     * without this file will cause a worning in xcode
     */
    if( fs.existsSync(entitlementsPath) ) {
        commonFuncs.addAPNSinEntitlements(entitlementsPath, false);
    } else {
        // copy default entitlements file
        fs.readFile(__dirname + '/apns.entitlements', 'utf8', function(err, data) {
            if (err) {
                throw err;
            }

            fs.writeFileSync(entitlementsPath, data);
            console.log(entitlementsPath + " written successfully");
        });

        needAddEntitlementToPbxproj = true;
    }

    /**
     * enable Push Notification capability in .pbxproj file
     * equally enable "Push Notification" switch in xcode
     */
    fs.readFile(pbxprojPath, "utf8", function(err, data) {
        if (err) {
            throw err;
        }
        console.log("Reading pbxproj file asynchronously");

        // add Push Notification Capability
        let re1 = new RegExp('isa = PBXProject;(.|[\r\n])*TargetAttributes', 'g');
        let re1rep = new RegExp('isa = PBXProject;(.|[\r\n])*attributes = {', 'g');
        let re2 = new RegExp('(?:isa = PBXProject;(.|[\r\n])*TargetAttributes(.|[\r\n])*)SystemCapabilities', 'g');
        let re2rep = new RegExp('isa = PBXProject;(.|[\r\n])*TargetAttributes = {', 'g');
        let re3 = new RegExp('(?:isa = PBXProject;(.|[\r\n])*TargetAttributes(.|[\r\n])*SystemCapabilities(.|[\r\n])*)com\.apple\.Push', 'g');
        let re3rep = new RegExp('isa = PBXProject;(.|[\r\n])*TargetAttributes(.|[\r\n])*SystemCapabilities = {', 'g');
        let re4rep = new RegExp('isa = PBXProject;(.|[\r\n])*TargetAttributes(.|[\r\n])*SystemCapabilities(.|[\r\n])*com\.apple\.Push = {(.|[\r\n])*enabled = [01]');

        let matched = data.match(re1);
        let result;
        if (matched === null) {
            console.log('re1 not match, no TargetAttributes');
            result = data.replace(re1rep,   'isa = PBXProject;\n' +
                                            '\t\t\tattributes = {\n' +
                                            '\t\t\t\tTargetAttributes = {\n' +
                                            '\t\t\t\t\t1D6058900D05DD3D006BFB54 = {\n' +
                                            '\t\t\t\t\t\tDevelopmentTeam = ' + cordovaBuildConfig.ios.release.developmentTeam + ';\n' +
                                            '\t\t\t\t\t\tSystemCapabilities = {\n' +
                                            '\t\t\t\t\t\t\tcom.apple.Push = {\n' +
                                            '\t\t\t\t\t\t\t\tenabled = 1;\n' +
                                            '\t\t\t\t\t\t\t};\n' +
                                            '\t\t\t\t\t\t};\n' +
                                            '\t\t\t\t\t};\n' +
                                            '\t\t\t\t};');
        } else {
            matched = data.match(re2);
            if(matched === null) {
                console.log('re2 not match, nothing under TargetAttributes');
                let parts = re2rep.exec(data);
                result = data.replace(re2rep, parts[0] + '\n' + '\t\t\t\t\t1D6058900D05DD3D006BFB54 = {\n' +
                                                                '\t\t\t\t\t\tDevelopmentTeam = ' + cordovaBuildConfig.ios.release.developmentTeam + ';\n' +
                                                                '\t\t\t\t\t\tSystemCapabilities = {\n' +
                                                                '\t\t\t\t\t\t\tcom.apple.Push = {\n' +
                                                                '\t\t\t\t\t\t\t\tenabled = 1;\n' +
                                                                '\t\t\t\t\t\t\t};\n' +
                                                                '\t\t\t\t\t\t};\n' +
                                                                '\t\t\t\t\t};');
            } else {
                matched = data.match(re3);
                if(matched === null) {
                    console.log('re3 not match, no com.apple.Push defined');
                    let parts = re3rep.exec(data);
                    result = data.replace(re3rep, parts[0] + '\n' + '\t\t\t\t\t\t\tcom.apple.Push = {\n' +
                                                                    '\t\t\t\t\t\t\t\tenabled = 1;\n' +
                                                                    '\t\t\t\t\t\t\t};');
                } else {
                    console.log('just enable com.apple.Push');
                    let parts = re4rep.exec(data);
                    result = data.replace(re4rep, parts[0].substr(0, parts[0].length - 1) + '1');
                }
            }
        }

        // add entitlements
        if (needAddEntitlementToPbxproj) {

            let pathArray = entitlementsPath.split("/");
            let entitlementsFileName = pathArray[pathArray.length - 1];
            let projectFolderName = pathArray[pathArray.length - 2];

            result = result.replace(new RegExp('\\/\\* Begin PBXFileReference section \\*\\/'),  '/* Begin PBXFileReference section */\n' +
                                                                        '\t\tD7BB385F1E4DB54800345BF4 /* ' + entitlementsFileName + ' */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; name = "' + entitlementsFileName + '"; path = "' + projectFolderName + '/' + entitlementsFileName + '"; sourceTree = "<group>"; };');
            result = result.replace(new RegExp('\\/\\* CustomTemplate \\*\\/.*\n.*isa = PBXGroup;.*\n.*children = \\('), '/* CustomTemplate */ = {\n' +
                            '\t\t\tisa = PBXGroup;\n' +
                            '\t\t\tchildren = (\n' +
                            '\t\t\t\tD7BB385F1E4DB54800345BF4 /* ' + entitlementsFileName + ' */,');
            let re5rep = new RegExp('\\/\\* Debug \\*\\/.*\n.*isa = XCBuildConfiguration;.*\n.*\n.*buildSettings = {');
            let parts = result.match(re5rep);
            result = result.replace(re5rep, parts + '\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = "' + projectFolderName + '/' + entitlementsFileName + '";');

            let re6rep = new RegExp('\\/\\* Release \\*\\/.*\n.*isa = XCBuildConfiguration;.*\n.*\n.*buildSettings = {');
            parts = result.match(re6rep);
            result = result.replace(re6rep, parts + '\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = "' + projectFolderName + '/' + entitlementsFileName + '";');
        }

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

let cordovaBuildConfigPath = './build.json'
let cordovaBuildConfig = null;
let willEnablePushNotificationForXCode = true;
try { // try to read ios developmentTeam from build.json
    cordovaBuildConfig = JSON.parse(fs.readFileSync(cordovaBuildConfigPath, "utf8"));
} catch(e) {
    console.log("Do not detected 'build.json' to get ios developent team. \n" +
            "Will not enable XCode Push Notification Capability. \n" +
            "Will only enable Push Notification for CI by add config to '" + basePath + xcodeprojName + "/Entitlements-Debug.plist' and '" + basePath + xcodeprojName + "/Entitlements-Release.plist' \n" +
            "Please add 'build.json' to cordova project root folder to make after hook fullly functional. \n" +
            "Reference [1]https://cordova.apache.org/docs/en/latest/reference/cordova-cli/#cordova-build-command \n" +
            "Reference [2]https://cordova.apache.org/docs/en/latest/guide/platforms/ios/#signing-an-app");
    willEnablePushNotificationForXCode = false;
}

enablePushNotificationForCI(basePath, xcodeprojName);

if(willEnablePushNotificationForXCode) {
    enablePushNotificationForXCode(entitlementsPath, pbxprojPath, cordovaBuildConfig);
}
