cordova.define("cn.jpush.phonegap.JPushPlugin.JPushPlugin", function(require, exports, module) { 
var JPushPlugin = function(){
};

JPushPlugin.prototype.isPlatformIOS = function(){
	return device.platform == "iPhone" || device.platform == "iPad" || device.platform == "iPod touch" || device.platform == "iOS"
}

JPushPlugin.prototype.error_callback = function(msg){
	console.log("Javascript Callback Error: " + msg)
}

JPushPlugin.prototype.call_native = function(name, args, callback){ 
	console.log("start JPushPlugin.prototype.call_native");
	ret = cordova.exec(callback,this.error_callback,'JPushPlugin',name,args);
	console.log("end JPushPlugin.prototype.call_native");

	return ret;
}

JPushPlugin.prototype.startLogPageView = function(data){        
	this.call_native( "startLogPageView",[data],null); 
}

JPushPlugin.prototype.stopLogPageView = function(data){
	this.call_native( "stopLogPageView",[data],null);   
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

JPushPlugin.prototype.getRegistrationID = function(callback){
        
	try{
	    var data=[];
		this.call_native("getRegistrationID",[data],callback);
	}
	catch(exception){
		console.log(exception);
	}
}
JPushPlugin.prototype.setTags = function(data){
        
	try{
		this.call_native("setTags",data,null);
	}
	catch(exception){
		console.log(exception);
	}
}

JPushPlugin.prototype.setAlias = function(data){
	try{             
		this.call_native("setAlias",[data],null);
	}
	catch(exception){             
		console.log(exception);
	}
}

JPushPlugin.prototype.pushCallback = function(data){
	try{
		console.log(data);
		var bToObj=JSON.parse(data);
		var code  = bToObj.resultCode;
		var tags  = bToObj.resultTags;
		var alias = bToObj.resultAlias;
		console.log("JPushPlugin:callBack--code is "+code+" tags is "+tags + " alias is "+alias);
	}
	catch(exception){               
		console.log(exception);
	}
}
//android
//ios 

JPushPlugin.prototype.initNotificationCenter = function(){
	this.call_native( "initNotifacationCenter", null,null);              
}

if(!window.plugins){
	window.plugins = {};
}

if(!window.plugins.jPushPlugin){
	window.plugins.jPushPlugin = new JPushPlugin();
}  

module.exports = new JPushPlugin(); 

});
