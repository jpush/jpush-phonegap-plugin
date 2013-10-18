var JPushPlugin = function(){
	
};
JPushPlugin.prototype.failure = function (msg) {
  console.log("Javascript Callback Error: " + msg)
}
JPushPlugin.prototype.call_native = function (callback, name, args) {
  if(arguments.length == 2) {
    args = []
  }
  ret = cordova.exec(
  callback, // called when signature capture is successful
  this.failure, // called when signature capture encounters an error
  'JPushPlugin', // Tell cordova that we want to run "JPushPlugin"
  name, // Tell the plugin the action we want to perform
  args); // List of arguments to the plugin
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
// Register the plugin
if(!window.plugins) {
	window.plugins = {};
}
if(!window.plugins.jPushPlugin){
	window.plugins.jPushPlugin = new JPushPlugin();
}