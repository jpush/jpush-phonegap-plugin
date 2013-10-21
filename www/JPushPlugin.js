var JPushPlugin = function(){
	
};
JPushPlugin.prototype.error_callback = function (msg) {
  console.log("Javascript Callback Error: " + msg)
}
JPushPlugin.prototype.call_native = function (callback, name, args) {
  if(arguments.length == 2) {
    args = []
  }
  ret = cordova.exec(
  callback, 
  this.error_callback, 
  'JPushPlugin', 
  name, 
  args); 
  return ret;
}

JPushPlugin.prototype.setTags = function (tags, callback) {
  this.call_native(callback, "setTags", [tags])
}

JPushPlugin.prototype.setAlias = function (alias, callback) {
  this.call_native(callback, "setAlias", [alias])
}

JPushPlugin.prototype.pushCallback = function (data) {
	var strArr = [data]
	var str = strArr[0].message
  document.getElementById('tarea').value=str
  
}

JPushPlugin.prototype.getIncoming = function (callback) {
  this.call_native(callback, "getIncoming");
}

JPushPlugin.prototype.setBasicPushNotificationBuilder = function(callback){
	this.call_native(callback,"setBasicPushNotificationBuilder");
}

JPushPlugin.prototype.setCustomPushNotificationBuilder = function(callback){
	this.call_native(callback,"setCustomPushNotificationBuilder");
}

JPushPlugin.prototype.stopPush = function(callback){
	this.call_native(callback,"stopPush");
}

JPushPlugin.prototype.resumePush = function(callback){
	this.call_native(callback,"resumePush");
}

JPushPlugin.prototype.clearAllNoticication = function(callback){
	this.call_native(callback,"clearAllNotification");
}

JPushPlugin.prototype.setLatestNotificationNum = function(num,callback){
	this.call_native(callback,"setLatestNotificationNum",[num]);
}

JPushPlugin.prototype.isPushStopped = function(callback){
	this.call_native(callback,"isPushStopped")
}

JPushPlugin.prototype.init = function(callback){
	this.call_natvie(callback,"init");
}

JPushPlugin.prototype.setDebugable = function(mode,callback){
	this.call_native(callback,"setDebugable",[mode]);
}



if(!window.plugins) {
	window.plugins = {};
}
if(!window.plugins.jPushPlugin){
	window.plugins.jPushPlugin = new JPushPlugin();
}