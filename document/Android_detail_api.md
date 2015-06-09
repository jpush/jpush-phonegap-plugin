## adnroid API简介



### 获取集成日志

#### API - setDebugMode

用于开启调试模式，可以查看集成JPush过程中的log，如果集成失败，可方便定位问题所在

##### 接口定义

	window.plugins.jPushPlugin.setDebugMode (mode)

##### 参数说明

- mode的值

	- true  显示集成日志
	- false 不显示集成日志


###  接收消息和点击通知事件
#### API - receiveMessageInAndroidCallback

用于android收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用

##### 接口定义

	window.plugins.jPushPlugin.receiveMessageInAndroidCallback = function(data)
	
##### 参数说明
- data 接收到的js字符串，包含的key:value请进入该函数体查看

##### 代码示例

#### API - openNotificationInAndroidCallback

当点击android手机的通知栏进入应用程序时,会调用这个函数，这个函数不需要主动调用，是作为回调函数来用的


##### 接口定义

	window.plugins.jPushPlugin.openNotificationInAndroidCallback = function(data)
	
##### 参数说明
- data js字符串

##### 代码示例

###  统计分析 API

#### API - onResume / onPause
这是一个 android local api，不是js的api，请注意
本 API 用于“用户使用时长”，“活跃用户”，“用户打开次数”的统计，并上报到服务器，在 Portal 上展示给开发者。



####接口定义

		public static void onResume(final Activity activity)
		public static void onPause(final Activity activity)
####参数说明

 ＋ Activity activity 当前所在的Activity。
####调用说明

应在所有的 Activity 的 onResume / onPause 方法里调用。

####代码示例

	@Override
	protected void onResume() {
	    super.onResume();
	    JPushInterface.onResume(this);
	}
	@Override
	protected void onPause() {
	    super.onPause();
	    JPushInterface.onPause(this);
	}


#### API - reportNotificationOpened

用于上报用户的通知栏被打开，或者用于上报用户自定义消息被展示等客户端需要统计的事件。


##### 接口定义

	window.plugins.jPushPlugin.reportNotificationOpened(msgID)
	
##### 参数说明
- msgID
	-收到的通知或者自定义消息的id 	


###  清除通知 API

#### API - clearAllNotification

推送通知到客户端时，由 JPush SDK 展现通知到通知栏上。

此 API 提供清除通知的功能，包括：清除所有 JPush 展现的通知（不包括非 JPush SDK 展现的）


##### 接口定义

	window.plugins.jPushPlugin.clearAllNotification = function()

###  设置允许推送时间 API
###  设置通知静默时间 API
###  通知栏样式定制 API

#### API - setBasicPushNotificationBuilder,setCustomPushNotificationBuilder

当用户需要定制默认的通知栏样式时，则可调用此方法。
极光 Push SDK 提供了 2 个用于定制通知栏样式的构建类：

- setBasicPushNotificationBuilder 
	- Basic 用于定制 Android Notification 里的 defaults / flags / icon 等基础样式（行为）
- setCustomPushNotificationBuilder
	- 继承 Basic 进一步让开发者定制 Notification Layout
	
如果不调用此方法定制，则极光Push SDK 默认的通知栏样式是：Android标准的通知栏提示。

##### 接口定义 

	window.plugins.jPushPlugin.setBasicPushNotificationBuilder = function()
	window.plugins.jPushPlugin.setCustomPushNotificationBuilder = function()


###  设置保留最近通知条数 API

#### API - setLatestNotificationNum

通过极光推送，推送了很多通知到客户端时，如果用户不去处理，就会有很多保留在那里。

新版本 SDK (v1.3.0) 增加此功能，限制保留的通知条数。默认为保留最近 5 条通知。

开发者可通过调用此 API 来定义为不同的数量。

##### 接口定义

	window.plugins.jPushPlugin.setLatestNotificationNum(num)
	
##### 参数说明

- num 保存的条数


###  本地通知API
#### API - addLocalNotification,removeLocalNotification,clearLocalNotifications


本地通知API不依赖于网络，无网条件下依旧可以触发

本地通知与网络推送的通知是相互独立的，不受保留最近通知条数上限的限制

本地通知的定时时间是自发送时算起的，不受中间关机等操作的影响


三个接口的功能分别为：添加一个本地通知，删除一个本地通知，删除所有的本地通知

#####接口定义

	window.plugins.jPushPlugin.addLocalNotification = function(builderId,
											    content,
												title,
												notificaitonID,
												broadcastTime,
												extras)
	window.plugins.jPushPlugin.removeLocalNotification = function(notificationID)
	window.plugins.jPushPlugin.clearLocalNotifications = function()

##### 参数说明

- builderId 设置本地通知样式
- content 设置本地通知的content
- title 设置本地通知的title
- notificaitonID 设置本地通知的ID
- broadcastTime 设置本地通知触发时间，为距离当前时间的数值，单位是毫秒
- extras 设置额外的数据信息extras为json字符串


