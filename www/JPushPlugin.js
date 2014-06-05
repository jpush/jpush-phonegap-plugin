cordova.define("cn.jpush.phonegap.JPushPlugin.JPushPlugin", function(require, exports, module) { 
var JPushPlugin = function(){
        
};
JPushPlugin.prototype.call_native = function ( name, args) {
         
         ret = cordova.exec(null,
                            null,
                           'JPushPlugin',
                            name,
                            args);
         return ret;
}
JPushPlugin.prototype.getRegistrationID = function () {
    
      this.call_native( "getRegistrationID", null);

}
JPushPlugin.prototype.startLogPageView = function (data) {
    if (data==null || typeof(data)=="undefined" || data==""){
               console.log("argument is null");

    }
    else{
               this.call_native( "startLogPageView", [data]);

    }
}
JPushPlugin.prototype.stopLogPageView = function (data) {
    if (data==null || typeof(data)=="undefined" || data==""){
               console.log("argument is null");

    }
    else{
               this.call_native( "stopLogPageView", [data]);

    }
}
JPushPlugin.prototype.initNotificationCenter = function () {
               
   this.call_native( "initNotifacationCenter", null);
               
}
JPushPlugin.prototype.parseEvent = function (data) {
               try{
                  var parament=""
                  var count=1;
                  var start=false;
                  for(var i in data){

                     if(data[i]=='['){
                        if (count==1&&start==false) {
                            start=true;
                            continue;
                        }
                        count++;
                     }
                     if (data[i]==']') {
                        if(count==1)
                        {
                            break;
                        }
                        count--;
                     }

                    parament+=data[i]
                     
                  }
                  return parament;
               }
               catch(exception){
                    alert(exception);
               }
}

JPushPlugin.prototype.setTagsWithAlias = function (tags,alias) {
         
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
         this.call_native( "setTagsWithAlias", arrayTagWithAlias);
}
JPushPlugin.prototype.setTags = function (data) {
        
         try{
            this.call_native("setTags", [data]);
         }
         catch(exception){
            alert(exception);
         }
}
JPushPlugin.prototype.setAlias = function (data) {
        
         try{
             
            this.call_native("setAlias", [data]);
         }
         catch(exception){
             
            alert(exception);
         }
}
JPushPlugin.prototype.pushCallback = function (data) {
         try{
            var bToObj=JSON.parse(data);
            var code  = bToObj.resultCode;
            var tags  = bToObj.resultTags;
            var alias = bToObj.resultAlias;
            console.log("JPushPlugin:callBack--code is "+code+" tags is "+tags + " alias is "+alias);
         }
         catch(exception){
               
            alert(exception);
         }
}
JPushPlugin.prototype.registrationCallback = function (data) {
        try{
             console.log("registrationCallback--registraionID is "+data);
        }
        catch(exception){
            alert(exception);
        }
}
if(!window.plugins) {
        window.plugins = {};
}
if(!window.plugins.jPushPlugin){
        window.plugins.jPushPlugin = new JPushPlugin();
}               
module.exports = new JPushPlugin();
       
});
