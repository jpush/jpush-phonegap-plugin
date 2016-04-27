# iOS API

- [开始与停止推送服务](#开始与停止推送服务)
- [获取 RegistrationID](#获取-registrationid)
- [别名与标签](#别名与标签)
- [获取 APNS 推送内容](#获取-apns-推送内容)
	- [点击推送通知](#点击推送通知)
	- [前台收到推送](#前台收到推送)
	- [后台收到推送](#后台收到推送)
- [获取自定义消息内容](#获取自定义消息内容)
- [设置Badge](#设置badge)
- [本地通知](#本地通知)
- [页面的统计](#页面的统计)
- [日志等级设置](#日志等级设置)
- [地理位置上报](#地理位置上报)
- [设备平台判断](#设备平台判断)

## 开始与停止推送服务

### API - init

调用此 API,用来开启 JPush SDK 提供的推送服务。

开发者 App 可以通过调用停止推送服务 API 来停止极光推送服务，当又需要使用极光推送服务时，则必须要调用恢复推送服务 API。

```
本功能是一个完全本地的状态操作。也就是说：停止推送服务的状态不会保存到服务器上。
如果停止推送服务后，开发者 App 被重新安装，或者被清除数据，
JPush SDK 会恢复正常的默认行为。（因为保存在本地的状态数据被清除掉了）。
本功能其行为类似于网络中断的效果，即：推送服务停止期间推送的消息，
恢复推送服务后，如果推送的消息还在保留的时长范围内，则客户端是会收到离线消息。
```

#### 接口定义

	window.plugins.jPushPlugin.init()


### API - stopPush

- 不推荐调用，因为这个 API 只是让你的 DeviceToken 失效，在 设置－通知 中您的应用程序没有任何变化。
- 推荐：设置一个 UI 界面，提醒用户在 设置－通知 中关闭推送服务。

#### 接口定义

    window.plugins.jPushPlugin.stopPush()


### API - resumePush

恢复推送服务。调用了此 API 后，iOS平台，重新去APNS注册。

#### 接口定义

	window.plugins.jPushPlugin.resumePush()


### API - isPushStopped

iOS平台，检查推送服务是否注册。

#### 接口定义

	window.plugins.jPushPlugin.isPushStopped(callback)


#### 参数说明

- callback 回调函数，用来通知 JPush 的推送服务是否开启。

#### 代码示例
	window.plugins.jPushPlugin.resumePush(callback)
	var onCallback = function(data) {
		if(data > 0) {
		    // 开启
		} else {
		    // 关闭
		}
	}


## 获取 RegistrationID

### API - getRegistrationID

RegistrationID 定义:

集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。
JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。

应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知。

#### 接口定义

	JPushPlugin.prototype.getRegistrationID(callback)

#### 返回值

调用此 API 来取得应用程序对应的 RegistrationID。只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串。

#### 调用示例

 	window.plugins.jPushPlugin.getRegistrationID(onGetRegistradionID);
	var onGetRegistradionID = function(data) {
		try {
			console.log("JPushPlugin:registrationID is " + data);
		} catch(exception) {
			console.log(exception);
		}
	}

## 别名与标签

### API - setTagsWithAlias, setTags, setAlias

提供几个相关 API 用来设置别名（alias）与标签（tags）。

这几个 API 可以在 App 里任何地方调用。

**别名 Alias**

为安装了应用程序的用户，取个别名来标识。以后给该用户 Push 消息时，就可以用此别名来指定。

每个用户只能指定一个别名。

同一个应用程序内，对不同的用户，建议取不同的别名。这样，尽可能根据别名来唯一确定用户。

系统不限定一个别名只能指定一个用户。如果一个别名被指定到了多个用户，当给指定这个别名发消息时，服务器端 API 会同时给这多个用户发送消息。

举例：在一个用户要登录的游戏中，可能设置别名为 userid。游戏运营时，发现该用户 3 天没有玩游戏了，则根据 userid 调用服务器端 API 发通知到客户端提醒用户。

**标签 Tag**

为安装了应用程序的用户，打上标签。其目的主要是方便开发者根据标签，来批量下发 Push 消息。

可为每个用户打多个标签。

不同应用程序、不同的用户，可以打同样的标签。

举例: game, old_page, women。

#### 接口定义

	JPushPlugin.prototype.setTagsWithAlias(tags, alias)
	JPushPlugin.prototype.setTags(tags)
	JPushPlugin.prototype.setAlias(alias)

#### 参数说明
* tags:
	* 参数类型为数组。
	* nil 此次调用不设置此值。
	* 空集合表示取消之前的设置。
	* 每次调用至少设置一个 tag，覆盖之前的设置，不是新增。
	* 有效的标签组成：字母（区分大小写）、数字、下划线、汉字。
	* 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 100 个 tag，但总长度不得超过1K字节（判断长度需采用UTF-8编码）。
	* 单个设备最多支持设置 100 个 tag，App 全局 tag 数量无限制。
* alias:
	* 参数类型为字符串。
	* nil 此次调用不设置此值。
	* 空字符串 （""）表示取消之前的设置。
	* 有效的别名组成：字母（区分大小写）、数字、下划线、汉字。
	* 限制：alias 命名长度限制为 40 字节（判断长度需采用 UTF-8 编码）。

#### 返回值说明

函数本身无返回值，但需要注册 `jpush.setTagsWithAlias` 事件来监听设置结果。

	document.addEventListener("jpush.setTagsWithAlias", onTagsWithAlias, false);
    var onTagsWithAlias = function(event) {
        try {
           console.log("onTagsWithAlias");    
           var result = "result code:"+event.resultCode + " ";
           result += "tags:" + event.tags + " ";
           result += "alias:" + event.alias + " ";
           $("#tagAliasResult").html(result);
        } catch(exception) {
           console.log(exception)
        }
   	}

#### 错误码定义

|Code|描述                   		       |详细解释 |
|----|:----------------------------------------|:--------|
|6001|无效的设置，tag/alias 不应参数都为 null  |   	 |
|6002|设置超时			       	       |建议重试。|
|6003|alias 字符串不合法	               |有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6004|alias超长			       |最多 40个字节	中文 UTF-8 是 3 个字节。|
|6005|某一个 tag 字符串不合法		       |有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6006|某一个 tag 超长			       |一个 tag 最多 40个字节	中文 UTF-8 是 3 个字节。|
|6007|tags 数量超出限制(最多 100 个)	       |这是一台设备的限制。一个应用全局的标签数量无限制。|
|6008|tag/alias 超出总长度限制	       	       |总长度最多 1K 字节。|
|6011|10s内设置tag或alias大于3次	       |短时间内操作过于频繁。|


## 获取 APNS 推送内容

### 点击推送通知

#### event - jpush.openNotification

点击通知启动或唤醒应用程序时会出发该事件

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

		document.addEventListener("jpush.openNotification", onOpenNotification, false);

- onOpenNotification 需要这样写：

		var onOpenNotification = function(event) {
			var alertContent;
			alertContent = event.aps.alert;
			alert("open Notificaiton:" + alertContent);
		}

- event 举例:

		{
			"aps":{
				  "badge":1,
				  "sound":"default",
				  "alert":"今天去哪儿"
			},
			"key1":"value1",
			"key2":"value2",
			"_j_msgid":154604475
		}

### 前台收到推送

#### event - jpush.receiveNotification

应用程序处于前台时收到推送会触发该事件

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

		document.addEventListener("jpush.receiveNotification", onReceiveNotification, false);

- onReceiveNotification 需要这样写：

		var onReceiveNotification = function(event) {
			var alertContent;
			alertContent = event.aps.alert;
			alert("open Notificaiton:" + alertContent);
		}

- event 举例

		{
			"aps":{
				  "badge":1,
				  "sound":"default",
				  "alert":"今天去哪儿"
			},
			"key1":"value1",
			"key2":"value2",
			"_j_msgid":154604475
		}

### 后台收到推送

#### event - jpush.backgroundNotification

应用程序处于后台时收到推送会触发该事件，可以在后台执行一段代码。具体配置参考 [iOS 7 Background Remote Notification](http://docs.jpush.io/client/ios_tutorials/#ios-7-background-remote-notification)

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

		document.addEventListener("jpush.backgroundNotification", onBackgroundNotification, false);

- onBackgroundNotification 需要这样写：

		var onBackgroundNotification = function(event) {
			var alertContent;
			alertContent = event.aps.alert;
			alert("open Notificaiton:" + alertContent);
		}

+ event 举例

		{
			"aps":{
				  "badge":1,
				  "sound":"default",
				  "alert":"今天去哪儿"
			},
			"key1":"value1",
			"key2":"value2",
			"_j_msgid":154604475
		}

#### API - receiveMessageIniOSCallback

用于 iOS 收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用
不推荐使用回调函数

##### 接口定义

	JPushPlugin.prototype.receiveMessageIniOSCallback(data)

##### 参数说明

- data: 是一个 js 字符串使用如下代码解析，js 具体 key 根据应用内消息来确定:

	var bToObj = JSON.parse(data);


## 获取自定义消息内容


### event - jpush.receiveMessage

收到应用内消息时触发这个事件, 推荐使用事件的方式传递，但同时保留了 receiveMessageIniOSCallback 的回调函数，兼容以前的代码。


#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

		document.addEventListener("jpush.receiveMessage", onReceiveMessage, false);

- onReceiveMessage 需要这样写：

		var onReceiveMessage = function(event) {
			try{
				var message;
				message = event.content;      
				$("#messageResult").html(message);
			}catch(exception) {
				console.log("JPushPlugin:onReceiveMessage-->" + exception);
			}
		}


- event 举例:

		{
			"content":"今天去哪儿",
			"extras":
			{
				"key":"不填写没有"
			}
		}

## 设置Badge
### API - setBadge, resetBadge

 JPush 封装 badge 功能，允许应用上传 badge 值至 JPush 服务器，
 由 JPush 后台帮助管理每个用户所对应的推送 badge 值，简化了设置推送 badge 的操作。
（本接口不会直接改变应用本地的角标值. 要修改本地 badege 值，使用 setApplicationIconBadgeNumber）

实际应用中，开发者可以直接对 badge 值做增减操作，无需自己维护用户与 badge 值之间的对应关系。
#### 接口定义

	window.plugins.jPushPlugin.prototype.setBadge(value)
	window.plugins.jPushPlugin.prototype.reSetBadge()

resetBadge相当于setBadge(0)。

#### 参数说明
value 取值范围：[0,99999]。

#### 返回值
无，控制台会有 log 打印设置结果。

#### 代码示例

	window.plugins.jPushPlugin.setBadge(5);
	window.plugins.jPushPlugin.reSetBadge();

### API - setApplicationIconBadgeNumber

本接口直接改变应用本地的角标值，设置 iOS 的角标，当设置 badge ＝ 0 时为清除角标。

#### 接口定义

	window.plugins.jPushPlugin.prototype.setApplicationIconBadgeNumber(badge)

#### 参数说明

- badge: 整形，例如 0，1，2（当 badge 为 0 时，角标被清除）。

#### 代码示例

	window.plugins.jPushPlugin.setApplicationIconBadgeNumber(0);

### API - getApplicationIconBadgeNumber

获取 iOS 的角标值。

#### 接口定义

	window.plugins.jPushPlugin.prototype.getApplicationIconBadgeNumber(callback)

#### 参数说明

- callback: 回调函数。

#### 代码示例

	window.plugins.jPushPlugin.getApplicationIconBadgeNumber(function(data) {
	     console.log(data);               
	});


## 本地通知

### API - addLocalNotificationForIOS

用于注册本地通知，最多支持64个。

#### 接口定义

	window.plugins.jPushPlugin.prototype.addLocalNotificationForIOS(delayTime, content, badge, notificationID, extras)

#### 参数说明

- delayTime: 本地推送延迟多长时间后显示，数值类型或纯数字的字符型均可。
- content: 本地推送需要显示的内容。
- badge: 角标的数字。如果不需要改变角标传-1。数值类型或纯数字的字符型均可。
- notificationID: 本地推送标识符,字符串。
- extras: 自定义参数，可以用来标识推送和增加附加信息。字典类型。

#### 代码示例

	window.plugins.jPushPlugin.addLocalNotificationForIOS(6*60*60, "本地推送内容", 1, "notiId", {"key":"value"});

### API - deleteLocalNotificationWithIdentifierKeyInIOS

删除本地推送定义。

#### 接口定义

	window.plugins.jPushPlugin.prototype.deleteLocalNotificationWithIdentifierKeyInIOS(identifierKey)

#### 参数说明

- identifierKey: 本地推送标识符。

#### 代码示例

        window.plugins.jPushPlugin.deleteLocalNotificationWithIdentifierKeyInIOS("identifier");

### API - clearAllLocalNotifications

清除所有本地推送对象。

#### 接口定义

	window.plugins.jPushPlugin.prototype.clearAllLocalNotifications()

#### 代码示例

    window.plugins.jPushPlugin.clearAllLocalNotifications();


## 页面的统计

### API - startLogPageView, stopLogPageView, beginLogPageView

用于“用户指定页面使用时长”的统计，并上报到服务器，在 Portal 上展示给开发者。
页面统计集成正确，才能够获取正确的页面访问路径、访问深度（PV）的数据。

#### 接口定义

	window.plugins.jPushPlugin.prototype.startLogPageView(pageName)
	window.plugins.jPushPlugin.prototype.stopLogPageView(pageName)
	window.plugins.jPushPlugin.prototype.beginLogPageView(pageName, duration)

#### 参数说明

- pageName: 需要统计页面自定义名称
- duration: 自定义的页面时间

#### 调用说明
应在所有的需要统计得页面得 viewWillAppear 和 viewWillDisappear 加入 startLogPageView 和 stopLogPageView 来统计当前页面的停留时间。

或者直接使用 beginLogPageView 来自定义加入页面和时间信息。

#### 代码示例

	window.plugins.jPushPlugin.beginLogPageView("newPage", 5);
	window.plugins.jPushPlugin.startLogPageView("onePage");
	window.plugins.jPushPlugin.stopLogPageView("onePage");


## 日志等级设置

### API - setDebugModeFromIos

用于开启 Debug 模式，显示更多的日志信息。

建议调试时开启这个选项，不调试的时候注释这句代码，这个函数 setLogOFF 是相反的一对。

#### 接口定义

	window.plugins.jPushPlugin.prototype.setDebugModeFromIos()

#### 代码示例

	window.plugins.jPushPlugin.setDebugModeFromIos();

### API - setLogOFF

用来关闭日志信息（除了必要的错误信息）。

不需要任何调试信息的时候，调用此 API（发布时建议调用此 API，用来屏蔽日志信息，节省性能消耗)。

#### 接口定义

	window.plugins.jPushPlugin.prototype.setLogOFF()

#### 代码示例

	window.plugins.jPushPlugin.setLogOFF();

### API - setCrashLogON

用于统计用户应用崩溃日志。

如果需要统计 Log 信息，调用该接口。当你需要自己收集错误信息时，切记不要调用该接口。

#### 接口定义

	window.plugins.jPushPlugin.prototype.setCrashLogON()

#### 代码示例

	window.plugins.jPushPlugin.setCrashLogON();

## 地理位置上报

### API - setLocation

用于统计用户地理信息。

#### 接口定义

	window.plugins.jPushPlugin.prototype.setLocation(latitude, longitude)

#### 参数说明

- latitude: 地理位置纬度，数值类型或纯数字的字符型均可。
- longitude: 地理位置精度，数值类型或纯数字的字符型均可。

#### 代码示例

	window.plugins.jPushPlugin.setLocation(39.26,115.25);

## 设备平台判断

### API - isPlatformIOS

用于区分 iOS, Android 平台，以便不同设置。

#### 接口定义

	window.plugins.jPushPlugin.prototype.isPlatformIOS()

#### 代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()) {
		// iOS
	} else {
		// Android
	}
