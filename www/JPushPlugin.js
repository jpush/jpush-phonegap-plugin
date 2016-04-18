

var JPushPlugin = function(){
};

//private plugin function

JPushPlugin.prototype.receiveMessage = {}
JPushPlugin.prototype.openNotification = {}
JPushPlugin.prototype.receiveNotification = {}


JPushPlugin.prototype.isPlatformIOS = function() {
	var isPlatformIOS = device.platform == "iPhone"
		|| device.platform == "iPad"
		|| device.platform == "iPod touch"
		|| device.platform == "iOS";
	return isPlatformIOS;
}

JPushPlugin.prototype.error_callback = function(msg) {
	console.log("Javascript Callback Error: " + msg);
}

JPushPlugin.prototype.call_native = function(name, args, callback) {
	ret = cordova.exec(callback, this.error_callback, 'JPushPlugin', name, args);
	return ret;
}

// public methods
JPushPlugin.prototype.init = function() {
	if(this.isPlatformIOS()) {
		var data = [];
		this.call_native("initial", data, null);
	} else {
		data = [];
		this.call_native("init", data, null);
	}
}

JPushPlugin.prototype.getRegistrationID = function(callback) {
	try {
	  	var data = [];
		this.call_native("getRegistrationID", [data], callback);
	} catch(exception) {
		console.log(exception);
	}
}

JPushPlugin.prototype.stopPush = function() {
	data = [];
	this.call_native("stopPush", data, null);
}

JPushPlugin.prototype.resumePush = function() {
	data = [];
	this.call_native("resumePush", data, null);
}

JPushPlugin.prototype.isPushStopped = function(callback) {
	data = [];
	this.call_native("isPushStopped", data, callback);
}

// iOS methods
JPushPlugin.prototype.setTagsWithAlias = function(tags, alias) {
	try {
  		if(tags == null) {
  			this.setAlias(alias);
      		return;
  		}
  		if(alias == null) {
  			this.setTags(tags);
			return;
		}
		var arrayTagWithAlias = [tags];
		arrayTagWithAlias.unshift(alias);
		this.call_native("setTagsWithAlias", arrayTagWithAlias, null);
	} catch(exception) {
    	console.log(exception);
	}
}

JPushPlugin.prototype.setTags = function(tags) {
	try {
		this.call_native("setTags", tags, null);
	} catch(exception) {
		console.log(exception);
	}
}

JPushPlugin.prototype.setAlias = function(alias) {
	try {
		this.call_native("setAlias", [alias], null);
	} catch(exception) {
		console.log(exception);
	}
}

JPushPlugin.prototype.setBadge = function(value) {
	if(this.isPlatformIOS()) {
		try {
			this.call_native("setBadge", [value], null);
		} catch(exception) {
			console.log(exception);
		}
	}
}

JPushPlugin.prototype.resetBadge = function() {
	if(this.isPlatformIOS()) {
		try {
			var data = [];
			this.call_native("resetBadge", [data], null);
		} catch(exception) {
			console.log(exception);
		}
	}
}

JPushPlugin.prototype.setDebugModeFromIos = function() {
	if(this.isPlatformIOS()) {
		var data = [];
    	this.call_native("setDebugModeFromIos", [data], null);
	}
}

JPushPlugin.prototype.setLogOFF = function() {
	if(this.isPlatformIOS()) {
  		var data = [];
    	this.call_native("setLogOFF", [data], null);
	}
}

JPushPlugin.prototype.setCrashLogON = function() {
    if (this.isPlatformIOS()) {
        var data = [];
        this.call_native("crashLogON", [data], null);
    }
}

JPushPlugin.prototype.addLocalNotificationForIOS = function(delayTime, content,
	badge, notificationID, extras) {
    if (this.isPlatformIOS()) {
        var data = [delayTime, content, badge, notificationID, extras];
        this.call_native("setLocalNotification", data, null);
    }
}

JPushPlugin.prototype.deleteLocalNotificationWithIdentifierKeyInIOS = function(
	identifierKey) {
    if (this.isPlatformIOS()) {
        var data = [identifierKey];
        this.call_native("deleteLocalNotificationWithIdentifierKey", data, null);
    }
}

JPushPlugin.prototype.clearAllLocalNotifications = function(){
    if (this.isPlatformIOS()) {
        var data = [];
        this.call_native("clearAllLocalNotifications", data, null);
    }
}

JPushPlugin.prototype.setLocation = function(latitude, longitude){
    if (this.isPlatformIOS()) {
        var data = [latitude, longitude];
        this.call_native("setLocation", data, null);
    }
}

JPushPlugin.prototype.receiveMessageIniOSCallback = function(data) {
	try {
		console.log("JPushPlugin:receiveMessageIniOSCallback--data:" + data);
		var bToObj = JSON.parse(data);
		var content = bToObj.content;
    	console.log(content);
	} catch(exception) {
		console.log("JPushPlugin:receiveMessageIniOSCallback" + exception);
	}
}

JPushPlugin.prototype.startLogPageView = function(pageName) {
	if(this.isPlatformIOS()) {
		this.call_native("startLogPageView", [pageName], null);
  	}
}

JPushPlugin.prototype.stopLogPageView = function(pageName) {
  	if(this.isPlatformIOS()) {
		this.call_native("stopLogPageView", [pageName], null);
	}
}

JPushPlugin.prototype.beginLogPageView = function(pageName, duration) {
  	if(this.isPlatformIOS()) {
		this.call_native("beginLogPageView", [pageName, duration], null);
	}
}

JPushPlugin.prototype.setApplicationIconBadgeNumber = function(badge) {
  	if(this.isPlatformIOS()) {
		this.call_native("setApplicationIconBadgeNumber", [badge], null);
	}
}

JPushPlugin.prototype.getApplicationIconBadgeNumber = function(callback) {
	if(this.isPlatformIOS()) {
		this.call_native("getApplicationIconBadgeNumber", [], callback);
	}
}

// Android methods
JPushPlugin.prototype.setDebugMode = function(mode) {
	if(device.platform == "Android") {
		this.call_native("setDebugMode", [mode], null);
	}
}

JPushPlugin.prototype.setBasicPushNotificationBuilder = function() {
	if(device.platform == "Android") {
		data = [];
		this.call_native("setBasicPushNotificationBuilder", data, null);
	}
}

JPushPlugin.prototype.setCustomPushNotificationBuilder = function() {
	if(device.platform == "Android") {
		data = [];
		this.call_native("setCustomPushNotificationBuilder", data, null);
	}
}

JPushPlugin.prototype.receiveMessageInAndroidCallback = function(data) {
	try {
		console.log("JPushPlugin:receiveMessageInAndroidCallback");
		data = JSON.stringify(data);
		var bToObj = JSON.parse(data);
		this.receiveMessage = bToObj
		cordova.fireDocumentEvent('jpush.receiveMessage', null);
	} catch(exception) {
		console.log("JPushPlugin:pushCallback " + exception);
	}
}

JPushPlugin.prototype.openNotificationInAndroidCallback = function(data) {
	try {
		console.log("JPushPlugin:openNotificationInAndroidCallback");
		data = JSON.stringify(data);
		var bToObj = JSON.parse(data);
		this.openNotification = bToObj;
		cordova.fireDocumentEvent('jpush.openNotification', null);
	} catch(exception) {
		console.log(exception);
	}
}

JPushPlugin.prototype.receiveNotificationInAndroidCallback = function(data) {
	try{
		console.log("JPushPlugin:receiveNotificationInAndroidCallback");
		data = JSON.stringify(data);
		var bToObj = JSON.parse(data);
		this.receiveNotification = bToObj;
		cordova.fireDocumentEvent('jpush.receiveNotification', null);
	} catch(exception) {
		console.log(exception);
	}
}

JPushPlugin.prototype.clearAllNotification = function() {
	if(device.platform == "Android") {
		data = [];
		this.call_native("clearAllNotification", data, null);
	}
}

JPushPlugin.prototype.clearNotificationById = function(notificationId) {
	if(device.platform == "Android") {
		data = [];
		this.call_native("clearNotificationById", [notificationId], null);
	}
}

JPushPlugin.prototype.setLatestNotificationNum = function(num) {
	if(device.platform == "Android") {
		this.call_native("setLatestNotificationNum", [num], null);
	}
}

JPushPlugin.prototype.setDebugMode = function(mode) {
	if(device.platform == "Android") {
		this.call_native("setDebugMode", [mode], null);
	}
}

JPushPlugin.prototype.addLocalNotification = function(builderId, content, title,
	notificationID, broadcastTime, extras) {
	if(device.platform == "Android") {
		data = [builderId, content, title, notificationID, broadcastTime, extras];
		this.call_native("addLocalNotification", data, null);
	}
}

JPushPlugin.prototype.removeLocalNotification = function(notificationID) {
	if(device.platform == "Android") {
		this.call_native("removeLocalNotification", [notificationID], null);
	}
}

JPushPlugin.prototype.clearLocalNotifications = function() {
	if(device.platform == "Android") {
		data = [];
		this.call_native("clearLocalNotifications", data, null);
	}
}

JPushPlugin.prototype.reportNotificationOpened = function(msgID) {
	if(device.platform == "Android") {
		this.call_native("reportNotificationOpened", [msgID], null);
	}
}

/**
 *是否开启统计分析功能，用于“用户使用时长”，“活跃用户”，“用户打开次数”的统计，并上报到服务器上，
 *在 Portal 上展示给开发者。
 */
JPushPlugin.prototype.setStatisticsOpen = function(mode) {
	if(device.platform == "Android") {
		this.call_native("setStatisticsOpen", [mode], null);
	}
}

/**
* 用于在 Android 6.0 及以上系统，申请一些权限
* 具体可看：http://docs.jpush.io/client/android_api/#android-60
*/
JPushPlugin.prototype.requestPermission = function() {
	if(device.platform == "Android") {
		this.call_native("requestPermission", [], null);
	}
}

JPushPlugin.prototype.setSilenceTime = function(startHour, startMinute, endHour, endMinute) {
	if (device.platform == "Android") {
		this.call_native("setSilenceTime", [startHour, startMinute, endHour, endMinute], null);
	}
}

JPushPlugin.prototype.setPushTime = function(weekdays, startHour, endHour) {
	if (device.platform == "Android") {
		this.call_native("setPushTime", [weekdays, startHour, endHour], null);
	}
}

if(!window.plugins) {
	window.plugins = {};
}

if(!window.plugins.jPushPlugin) {
	window.plugins.jPushPlugin = new JPushPlugin();
}

module.exports = new JPushPlugin();
