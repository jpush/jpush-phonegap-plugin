## JPush PhoneGap Plugin ##

JPush-PhoneGap-Plugin 支持 iOS, Android 的推送插件。

**功能特性：**
+ 发送推送通知
+ 发送推送自定义消息
+ 设置推送标签和别名
+ 设置角标（iOS）

*如需要 IM 功能插件，请关注 [jmessage-phonegap-plugin](https://github.com/jpush/jmessage-phonegap-plugin)*


## 安装 ##
###准备工作

1. cordova create 文件夹名字 包名 应用名字

		cordova create Myproj com.myproj.jpush MyTestProj

2. 添加平台

		cd Myproj
		cordova platform add android  
		cordova platform add ios

		ps:这里请注意iOS平台，必须先执行 `cordova platform add ios`,
		然后再执行 `cordova plugin add xxxxx` 命令，不然有一些必须要的链接库需要手动添加


###Cordova CLI / PhoneGap 安装 Android & iOS

1). 安装 JPush PhoneGap Plugin, 有两种方法：

方法一：在线安装

    cordova plugin add  https://github.com/jpush/jpush-phonegap-plugin.git --variable API_KEY=your_jpush_appkey  

方法二：下载到本地再安装

使用 git 命令将 JPush PhoneGap 插件下载的本地,将这个目录标记为 `$JPUSH_PLUGIN_DIR`

    git clone https://github.com/jpush/jpush-phonegap-plugin.git
    cordova plugin add $JPUSH_PLUGIN_DIR  --variable API_KEY=your_jpush_appkey


2). 安装 org.apache.cordova.device

     cordova plugin add org.apache.cordova.device


3). 在 js 中调用函数,初始化 JPush SDK

    //由于 PhoneGap 插件采用了 Lazy load 的特性，所以建议在 js 文件能执行的最开始就添加
    window.plugins.jPushPlugin.init();


### Android 手工安装

[Android 手工安装文档地址](document/Android_handle_install.md)


### iOS 手工安装

[IOS手工安装文档地址](document/iOS_handle_install.md)


###示例

"$JPUSH_PLUGIN_DIR/example"文件夹内找到并拷贝以下文件

		src/example/index.html to www/index.html
		src/example/css/* to www/css
		src/example/js/* to www/js

###关于'PhoneGap build'云服务

该项目基于 cordova 实现，目前无法使用 'PhoneGap build' 云服务进行打包，建议使用本地环境进行打包

### API 说明

插件的 API 集中在 JPushPlugin.js 文件中,该文件的具体位置如下：

Android:

	[Project]/assets/www/plugins/cn.jpush.phonegap.JPushPlugin/www

iOS:

	[Project]/www/plugins/cn.jpush.phonegap.JPushPlugin/www

具体的 API 请参考下面：

#### iOS 和 Android 通用 API 简介

+ 停止与恢复推送服务

		window.plugins.jPushPlugin.init()
		window.plugins.jPushPlugin.stopPush()
		window.plugins.jPushPlugin.resumePush()
		window.plugins.jPushPlugin.isPushStopped(callback)

+ 获取 RegistrationID

		window.plugins.jPushPlugin.getRegistrationID(callback)

+ 别名与标签

		window.plugins.jPushPlugin.setTagsWithAlias(tags, alias)
		window.plugins.jPushPlugin.setTags(tags)
		window.plugins.jPushPlugin.setAlias(alias)

+ 获取点击通知内容

		event - jpush.openNotification

+ 获取通知内容

		event - jpush.receiveNotification

+ 获取自定义消息推送内容

		event - jpush.receiveMessage


	[通用 API 详细说明](document/Common_detail_api.md)

#### iOS API简介

+ 获取自定义消息推送内容

		event - jpush.receiveMessage
		//推荐使用事件的方式传递，但同时保留了 receiveMessageIniOSCallback 的回调函数，兼容以前的代码
		window.plugins.jPushPlugin.receiveMessageIniOSCallback(data)

+ 页面的统计

		window.plugins.jPushPlugin.startLogPageView(pageName)
		window.plugins.jPushPlugin.stopLogPageView(pageName)
		window.plugins.jPushPlugin.beginLogPageView(pageName, duration)

+ 设置 Badge

		window.plugins.jPushPlugin.setBadge(value)
		window.plugins.jPushPlugin.resetBadge()
		window.plugins.jPushPlugin.setApplicationIconBadgeNumber(badge)
		window.plugins.JPushPlugin.getApplicationIconBadgeNumber(callback)

+ 本地通知

		window.plugins.JPushPlugin.addLocalNotificationForIOS(delayTime, content, badge, notificationID, extras)
		window.plugins.JPushPlugin.deleteLocalNotificationWithIdentifierKeyInIOS()
		window.plugins.JPushPlugin.clearAllLocalNotifications()

+ 日志等级设置

		window.plugins.jPushPlugin.setDebugModeFromIos()
		window.plugins.jPushPlugin.setLogOFF()
		window.plugins.JPushPlugin.setCrashLogON()

+ 地理位置上报

		window.plugins.JPushPlugin.setLocation(latitude, longitude)

	[iOS API 详细说明](document/iOS_detail_api.md)


#### Android API简介

+ 获取集成日志

		window.plugins.jPushPlugin.setDebugMode(mode)

+ 接收推送消息和点击通知

		//下面这两个 API 是兼容旧有的代码
		window.plugins.jPushPlugin.receiveMessageInAndroidCallback(data)
		window.plugins.jPushPlugin.openNotificationInAndroidCallback(data)

+ 统计分析

		window.plugins.jPushPlugin.setStatisticsOpen(boolean)

	或在 MainActivity 中的 onPause() 和 onResume() 方法中分别调用
	JPushInterface.onPause(this) 和 JPushInterface.onResume(this) 来启用统计分析功能,
	如果使用这种方式启用统计分析功能，则 window.plugins.jPushPlugin.setStatisticsOpen(boolean)
	方法不再有效，建议不要同时使用。

+ 清除通知

		window.plugins.jPushPlugin.clearAllNotification()

+ 通知栏样式定制

		window.plugins.jPushPlugin.setBasicPushNotificationBuilder = function()
		window.plugins.jPushPlugin.setCustomPushNotificationBuilder = function()

+ 设置保留最近通知条数

		window.plugins.jPushPlugin.setLatestNotificationNum(num)

+ 本地通知

		window.plugins.jPushPlugin.addLocalNotification(builderId, content,
				title, notificaitonID, broadcastTime, extras)
		window.plugins.jPushPlugin.removeLocalNotification(notificationID)
		window.plugins.jPushPlugin.clearLocalNotifications()

	[Android API 详细说明](document/Android_detail_api.md)

###常见问题

####1. Android

	eclipse 中 PhoneGap 工程 import 之后出现：`Type CallbackContext cannot be resolved to a type`
	解决方案：eclipse 中右键单击工程名，Build Path -> Config Build Path -> Projects -> 选中工程名称 -> CordovaLib -> 点击 add

####2. iOS 设置 / 修改 APP_KEY

    在 PushConfig.plist 中修改。
	PushConfig.plist 其他值说明：
    	CHANNEL: 渠道标识
    	IsProduction: 是否生产环境（暂未启用）



###更多
 [ JPush 官网文档](http://docs.jpush.io/)
