
var JPushPlugin = function(){

    this.noticeData = null;
    this.noticeCallBack = function (data) {
    
    	//关闭APP状态下响应打开notice获取参数
        console.log("关闭APP状态下响应打开notice ====" + JSON.stringify(data));
        
    };

};

JPushPlugin.prototype.isPlatformIOS = function(){
	return device.platform == "iPhone" || device.platform == "iPad" || device.platform == "iPod touch" || device.platform == "iOS"
}

JPushPlugin.prototype.error_callback = function(msg){
	console.log("Javascript Callback Error: " + msg)
}

JPushPlugin.prototype.call_native = function(name, args, callback){ 

	ret = cordova.exec(callback,this.error_callback,'JPushPlugin',name,args);
	return ret;
}
//public plugin function

JPushPlugin.prototype.startLogPageView = function(pageName){  
    if(this.isPlatformIOS()){
		this.call_native( "startLogPageView",[pageName],null); 
    }      
}

JPushPlugin.prototype.stopLogPageView = function(pageName){
    if(this.isPlatformIOS()){
		this.call_native( "stopLogPageView",[pageName],null);   
	}
}

JPushPlugin.prototype.beginLogPageView = function(pageName,duration){
    if(this.isPlatformIOS()){
		this.call_native( "beginLogPageView",[pageName,duration],null);   
	}
}
JPushPlugin.prototype.setApplicationIconBadgeNumber = function(badge){
    if(this.isPlatformIOS()){
		this.call_native( "setApplicationIconBadgeNumber",[badge],null);   
	}
}

JPushPlugin.prototype.setTagsWithAlias = function(tags,alias){
	try{
    	if(tags==null){
    		this.setAlias(alias);
        	return;
    	}
    	if(alias==null){
    		this.setTags(tags);
			return;
		}
		var arrayTagWithAlias=[tags];
		arrayTagWithAlias.unshift(alias);
		this.call_native( "setTagsWithAlias", arrayTagWithAlias,null);
	}
	catch(exception){
    	console.log(exception);
	}

}
JPushPlugin.prototype.setTags = function(tags){
        
	try{
		this.call_native("setTags",tags,null);
	}
	catch(exception){
		console.log(exception);
	}
}

JPushPlugin.prototype.setAlias = function(alias){
	try{             
		this.call_native("setAlias",[alias],null);
	}
	catch(exception){             
		console.log(exception);
	}
}
JPushPlugin.prototype.getRegistrationID = function(callback){
        
	try{
	    var data=[];
		this.call_native("getRegistrationID",[data],callback);
	}
	catch(exception){
		console.log(exception);
	}
}

JPushPlugin.prototype.setBadge = function(value){
               
   if(this.isPlatformIOS()){     
       try{
       this.call_native("setBadge",[value],null);
       }
       catch(exception){
       console.log(exception);
       }

   }
}
JPushPlugin.prototype.resetBadge = function(){
               
    if(this.isPlatformIOS()){
       try{
           var data=[];
           this.call_native("resetBadge",[data],null);
       }
       catch(exception){
           console.log(exception);
       }
    }
}
JPushPlugin.prototype.setDebugModeFromIos = function(){
	if(this.isPlatformIOS()){
		   var data=[];
           this.call_native("setDebugModeFromIos",[data],null);
	}

}
JPushPlugin.prototype.setLogOFF = function(){
	if(this.isPlatformIOS()){
        	var data=[];
            this.call_native("setLogOFF",[data],null);
	}
}
JPushPlugin.prototype.receiveMessageIniOSCallback = function(data){
	try{
		console.log("JPushPlugin:receiveMessageIniOSCallback--data:"+data);
		var bToObj = JSON.parse(data);
		var content = bToObj.content;
        console.log(content);
	}
	catch(exception){               
		console.log("JPushPlugin:receiveMessageIniOSCallback"+exception);
	}
}
JPushPlugin.prototype.receiveMessageInAndroidCallback = function(data){
	try{
		console.log("JPushPlugin:receiveMessageInAndroidCallback");
		console.log();
		//ecvar bToObj=JSON.parse(data);
		//var message  = bToObj.message;
		//var extras  = bToObj.extras;

		//console.log(message);
		//console.log(extras['cn.jpush.android.MSG_ID']);
		//console.log(extras['cn.jpush.android.CONTENT_TYPE']);
		//console.log(extras['cn.jpush.android.EXTRA']);
	}
	catch(exception){               
		console.log("JPushPlugin:pushCallback "+exception);
	}
}

//
JPushPlugin.prototype.openNotificationInAndroidCallback = function(data){
	try{
		console.log("JPushPlugin:openNotificationInAndroidCallback");	
		
		//开启APP状态下响应打开notice获取参数
        	console.log("开启APP状态下响应打开notice ====" + JSON.stringify(data));
		//console.log(data);
		//var bToObj  = JSON.parse(data);
		//var alert   = bToObj.alert;
		//var extras  = bToObj.extras;
		//console.log(alert);

		//console.log(extras['cn.jpush.android.MSG_ID']);
		//console.log(extras['app']);
		//console.log(extras['cn.jpush.android.NOTIFICATION_CONTENT_TITLE']);
		//console.log(extras['cn.jpush.android.EXTRA']);
		//console.log(extras['cn.jpush.android.PUSH_ID']);
		//console.log(extras['cn.jpush.android.NOTIFICATION_ID']);
		//console.log("JPushPlugin:openNotificationCallback is ready");
	}
	catch(exception){               
		console.log(exception);
	}
}
//android single

JPushPlugin.prototype.setBasicPushNotificationBuilder = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("setBasicPushNotificationBuilder",data,null);
	}
}

JPushPlugin.prototype.setCustomPushNotificationBuilder = function(){
	if(device.platform == "Android") {
		data=[];
		this.call_native("setCustomPushNotificationBuilder",data,null);
	}
}

JPushPlugin.prototype.stopPush = function(){
	data=[];
	this.call_native("stopPush",data,null);
}

JPushPlugin.prototype.resumePush = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("resumePush",data,null);
	}
}
JPushPlugin.prototype.setDebugMode = function(mode){
	if(device.platform == "Android") {
		this.call_native("setDebugMode",[mode],null);
	}
}
//setDebugMode
JPushPlugin.prototype.clearAllNotification = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("clearAllNotification",data,null);
	}
}

JPushPlugin.prototype.setLatestNotificationNum = function(num){
   	if(device.platform == "Android") {
		this.call_native("setLatestNotificationNum",[num],null);
	}
}

JPushPlugin.prototype.isPushStopped = function(callback){
	if(device.platform == "Android") {
	    data=[];
		this.call_native("isPushStopped",data,callback)
	}
}

JPushPlugin.prototype.init = function(){
    if(device.platform == "Android") {
        var self = this;
        data=[];
        this.call_native("init",data,null);

        // 从应用关闭时候打开需要触发
        this.getNoticeData(this.noticeCallBack);
        return this;
    }
}

JPushPlugin.prototype.setDebugMode = function(mode){
	if(device.platform == "Android") {
		this.call_native("setDebugMode",[mode],null);
	}
}
JPushPlugin.prototype.addLocalNotification = function(builderId,content,title,notificaitonID,broadcastTime,extras){
	if(device.platform == "Android") {
		data=[builderId,content,title,notificaitonID,broadcastTime,extras];
		this.call_native("addLocalNotification",data,null);
	}
}
JPushPlugin.prototype.removeLocalNotification = function(notificationID){
	if(device.platform == "Android") {
		this.call_native("removeLocalNotification",[notificationID],null);
	}
}
JPushPlugin.prototype.clearLocalNotifications = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("clearLocalNotifications",data,null);
	}
}
JPushPlugin.prototype.onResume = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("onResume",data,null);
	}
}
JPushPlugin.prototype.onPause = function(){
	if(device.platform == "Android") {
		data=[]
		this.call_native("onPause",data,null);
	}
}

JPushPlugin.prototype.reportNotificationOpened = function(msgID){
	if(device.platform == "Android") {
	
		this.call_native("reportNotificationOpened",[msgID],null);
	}
}

/**
 * 主动获取通知
 * @returns {*}
 */
JPushPlugin.prototype.getNoticeData = function (callback) {
    if(device.platform == "Android") {
        this.call_native("getNoticeData", [], callback);
        return this;
    }
};

/**
 * 给 js 调用指向对应的回调方法
 * @param noticeCallBack
 * @returns {*}
 */
JPushPlugin.prototype.setNoticeCallBack = function (noticeCallBack) {
    this.noticeCallBack = noticeCallBack;
    return this;
};

//iOS  single


if(!window.plugins){
	window.plugins = {};
}

if(!window.plugins.jPushPlugin){
	window.plugins.jPushPlugin = new JPushPlugin();
}  

module.exports = new JPushPlugin(); 

