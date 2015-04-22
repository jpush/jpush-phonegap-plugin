## JPush PhoneGap Plugin ##


###准备工作

1. cordova create 文件夹名字 包名 应用名字

		cordova create Myproj com.myproj.jpush MyTestProj
		
2. 添加平台

		cd Myproj 
		cordova platform add android  
		cordova platform add ios

3. 添加插件

		cordova -d plugin add https://github.com/qdsang/jpush-phonegap-plugin.git --variable JPUSH_APPKEY=appkey --variable JPUSH_CHANNEL=channel --variable APS_FOR_PRODUCTION=0
		cordova plugin add org.apache.cordova.device

4. 在js中调用函数,初始化jpush sdk

		 window.plugins.jPushPlugin.init();
		 window.plugins.jPushPlugin.setDebugMode(true);


### Android 手工安装

[Android 手工安装文档地址](document/Android_handle_install.md)
	

### IOS手工安装

[IOS手工安装文档地址](document/iOS_handle_install.md)
>>>>>>> bob/master


###示例

1. "$JPUSH_PLUGIN_DIR/example"文件夹内找到并拷贝以下文件

		src/example/index.html to www/index.html
		src/example/css/* to www/css
		src/example/js/* to www/js

###关于'phonegap build'云服务

该项目基于cordova实现，目前无法使用'phonegap build'云服务进行打包，建议使用本地环境进行打包

###常见错误
1. androd

		eclipse中phonegap工程import之后出现:`Type CallbackContext cannot be resolved to a type`
		解决方案：eclipse中右键单击工程名，Build Path->Config Build Path->Projects->选中 工程名称－CordovaLib->点击 add

### API说明

插件的API集中在JPushPlugin.js文件中,这个文件的位置如下

*  android:[YOUR__ANDROID_PROJECT]/assets/www/plugins/cn.jpush.phonegap.JPushPlugin/www
*  iOS:[YOUR_iOS_PROJEcT]/www/plugins/cn.jpush.phonegap.JPushPlugin/www

具体的API请参考这里

#### iOS和adnroid通用API简介

+ 停止与恢复推送服务 API
		
		window.plugins.jPushPlugin.init()
		window.plugins.jPushPlugin.stopPush()
		window.plugins.jPushPlugin.resumePush()
		window.plugins.jPushPlugin.isPushStopped(callback)


+ 获取 RegistrationID API

		window.plugins.jPushPlugin.getRegistrationID(callback)
		
+ 别名与标签 API
	
		window.plugins.jPushPlugin.setTagsWithAlias(tags,alias)
		window.plugins.jPushPlugin.setTags(tags)
		window.plugins.jPushPlugin.setAlias(alias)
+ 获取通知内容
		
		event - jpush.openNotification

+ 获取自定义消息推送内容

		event - jpush.receiveMessage


[通用API详细说明](document/Common_detail_api.md)

#### iOS API简介
+ 获取 APNs（通知） 推送内容

		event - jpush.receiveNotification

+ 获取自定义消息推送内容

		event - jpush.receiveMessage
		//推荐使用事件的方式传递，但同时保留了receiveMessageIniOSCallback的回调函数，兼容以前的代码
		window.plugins.jPushPlugin.receiveMessageIniOSCallback(data)
		
+ 页面的统计
	
		window.plugins.jPushPlugin.startLogPageView (pageName)
		window.plugins.jPushPlugin.stopLogPageView (pageName)
		window.plugins.jPushPlugin.beginLogPageView (pageName,duration)
+ 设置Badge

		window.plugins.jPushPlugin.setBadge(value)
		window.plugins.jPushPlugin.resetBadge()
		window.plugins.jPushPlugin.setApplicationIconBadgeNumber(badge)
+ 本地通知

	+ 后续版本加入
		
+ 日志等级设置
	
		window.plugins.jPushPlugin.setDebugModeFromIos ()
		window.plugins.jPushPlugin.setLogOFF()
		
		
[iOS API详细说明](document/iOS_detail_api.md)


#### adnroid API简介
		
+ 获取集成日志
		window.plugins.jPushPlugin.setDebugMode(mode)

+ 接收推送消息Receiver
		
		//推荐使用event jpush.Message和jpush.openNotification，
		//下面这两个api 是兼容旧有的代码
		window.plugins.jPushPlugin.receiveMessageInAndroidCallback(data)
		window.plugins.jPushPlugin.openNotificationInAndroidCallback(data)

+ 统计分析 API

		onResume / onPause(java api)
			
+ 清除通知 API

		window.plugins.jPushPlugin.clearAllNotification()

+ 通知栏样式定制 API

		window.plugins.jPushPlugin.setBasicPushNotificationBuilder = function()
		window.plugins.jPushPlugin.setCustomPushNotificationBuilder = function()

+ 设置保留最近通知条数 API
		
		window.plugins.jPushPlugin.setLatestNotificationNum(num)
		
+ 本地通知API
		
		window.plugins.jPushPlugin.addLocalNotification(builderId,
												    content,
												    title,
												    notificaitonID,
												    broadcastTime,
											 	    extras)
		window.plugins.jPushPlugin.removeLocalNotification(notificationID)
		window.plugins.jPushPlugin.clearLocalNotifications()

[Android API详细说明](document/Android_detail_api.md)

###更多
 [JPush官网文档](http://docs.jpush.io/)