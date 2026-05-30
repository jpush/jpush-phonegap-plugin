var JPushPlugin = function() {};

// private plugin function

JPushPlugin.prototype.receiveMessage = {};
JPushPlugin.prototype.openNotification = {};
JPushPlugin.prototype.receiveNotification = {};
JPushPlugin.prototype.notifyButtonClick = {};

JPushPlugin.prototype.isPlatformIOS = function() {
  return (
    device.platform === "iPhone" ||
    device.platform === "iPad" ||
    device.platform === "iPod touch" ||
    device.platform === "iOS"
  );
};

JPushPlugin.prototype.errorCallback = function(msg) {
  console.log("JPush Callback Error: " + msg);
};

JPushPlugin.prototype.callNative = function(
  name,
  args,
  successCallback,
  errorCallback
) {
  if (errorCallback) {
    cordova.exec(successCallback, errorCallback, "JPushPlugin", name, args);
  } else {
    cordova.exec(
      successCallback,
      this.errorCallback,
      "JPushPlugin",
      name,
      args
    );
  }
};

// Common methods
JPushPlugin.prototype.init = function() {
  if (this.isPlatformIOS()) {
    this.callNative("initial", [], null);
  } else {
    this.callNative("init", [], null);
  }
};

JPushPlugin.prototype.setDebugMode = function(mode) {
  if (device.platform === "Android") {
    this.callNative("setDebugMode", [mode], null);
  } else {
    if (mode === true) {
      this.setDebugModeFromIos();
    } else {
      this.setLogOFF();
    }
  }
};

JPushPlugin.prototype.setDataInsightsEnable = function(mode) {
  if (device.platform === "Android") {
    this.callNative("setDataInsightsEnable", [mode], null);
  } 
};

JPushPlugin.prototype.getRegistrationID = function(successCallback) {
  this.callNative("getRegistrationID", [], successCallback);
};

JPushPlugin.prototype.stopPush = function() {
  this.callNative("stopPush", [], null);
};

JPushPlugin.prototype.resumePush = function() {
  this.callNative("resumePush", [], null);
};

JPushPlugin.prototype.isPushStopped = function(successCallback) {
  this.callNative("isPushStopped", [], successCallback);
};

// New API: setKeepLongConnInBackground - Android only, added in JPush SDK 6.1.0
// This keeps the long connection alive when the app goes to background.
// @param {boolean} keep - true to keep the connection, false otherwise
JPushPlugin.prototype.setKeepLongConnInBackground = function(keep, successCallback, errorCallback) {
  if (device.platform === "Android") {
    this.callNative("setKeepLongConnInBackground", [keep], successCallback, errorCallback);
  } else {
    // iOS does not have this method; silently succeed
    if (typeof successCallback === 'function') {
      successCallback();
    }
  }
};

// Other existing methods remain unchanged...
