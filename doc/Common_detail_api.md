# 通用 API 说明（同时适用于 Android 和 iOS 系统）

- [停止与恢复推送服务](#停止与恢复推送服务)
- [获取 RegistrationID](#获取-registrationid)
- [设置别名与标签](#设置别名与标签)
- [获取点击通知内容](#获取点击通知内容)
- [获取通知内容](#获取通知内容)
- [获取自定义消息推送内容](#获取自定义消息推送内容)
- [判断系统设置中是否允许当前应用推送](#判断系统设置中是否允许当前应用推送)

## 停止与恢复推送服务
### API - init

调用此 API，用来开启 JPush SDK 提供的推送服务。

开发者 App 可以通过调用停止推送服务 API 来停止极光推送服务。当又需要使用极光推送服务时，则必须要调用恢复推送服务 API。

本功能是一个完全本地的状态操作，也就是说：停止推送服务的状态不会保存到服务器上。

如果停止推送服务后，开发者 App 被重新安装，或者被清除数据，JPush SDK 会恢复正常的默认行为（因为保存在本地的状态数据被清除掉了）。

本功能其行为类似于网络中断的效果，即：推送服务停止期间推送的消息，恢复推送服务后，如果推送的消息还在保留的时长范围内，则客户端是会收到离线消息。

#### 接口定义

	window.plugins.jPushPlugin.init()

### API - stopPush
+ Android 平台:

	+ 开发者 App 可以通过调用停止推送服务 API 来停止极光推送服务，当又需要使用极光推送服务时，则必须要调用恢复推送服务 API。

	+ 调用了本 API 后，JPush 推送服务完全被停止，具体表现为：

		+ JPush Service 不在后台运行。
		+ 收不到推送消息。
		+ 不能通过 JPushInterface.init 恢复，需要调用 resumePush 恢复。
		+ 极光推送所有的其他 API 调用都无效。

+ iOS 平台:

	+ 不推荐调用，因为这个 API 只是让你的 DeviceToken 失效，在 设置－通知 中您的应用程序没有任何变化。**建议设置一个 UI 界面， 提醒用户在 设置－通知 中关闭推送服务**。

#### 接口定义

    window.plugins.jPushPlugin.stopPush()

### API - resumePush

恢复推送服务。调用了此 API 后:

+ Android 平台:

	+ 极光推送完全恢复正常工作。

+ iOS 平台:

	+ 重新去 APNS 注册。

#### 接口定义

	window.plugins.jPushPlugin.resumePush()

### API - isPushStopped

+ Android 平台:

	+ 用来检查 Push Service 是否已经被停止。

+ iOS 平台:

	+ 平台检查推送服务是否注册。

#### 接口定义

    window.plugins.jPushPlugin.isPushStopped(callback)

#### 参数说明

+ callback: 回调函数，用来通知 JPush 的推送服务是否开启。

#### 代码示例

	window.plugins.jPushPlugin.isPushStopped(function (result) {
	   if (result == 0) {
		    // 开启
		 } else {
		    // 关闭
		 }
    })

## 开启 Debug 模式
### API - setDebugMode
用于开启 Debug 模式，显示更多的日志信息。

#### 接口定义

		JPushPlugin.prototype.setDebugMode(isOpen)

#### 参数说明
- isOpen: true，开启 Debug 模式；false，关闭 Debug 模式，不显示错误信息之外的日志信息。

#### 代码示例

		window.plugins.jPushPlugin.setDebugMode(true)

## 获取 RegistrationID

### API - getRegistrationID

RegistrationID 定义:

集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。
JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。

应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知。

#### 接口定义

	JPushPlugin.prototype.getRegistrationID(callback)

#### 返回值

调用此 API 来取得应用程序对应的 RegistrationID。 只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串。

#### 代码示例

     window.plugins.jPushPlugin.getRegistrationID(function(data) {
       console.log("JPushPlugin:registrationID is " + data)
     })

## 设置别名与标签

### API - setTagsWithAlias, setTags, setAlias

提供几个相关 API 用来设置别名（alias）与标签（tags）。

这几个 API 可以在 App 里任何地方调用。

**别名 Alias**:

为安装了应用程序的用户，取个别名来标识。以后给该用户 Push 消息时，就可以用此别名来指定。

每个用户只能指定一个别名。

同一个应用程序内，对不同的用户，建议取不同的别名。这样，尽可能根据别名来唯一确定用户。

系统不限定一个别名只能指定一个用户。如果一个别名被指定到了多个用户，当给指定这个别名发消息时，服务器端 API 会同时给这多个用户发送消息。

举例：在一个用户要登录的游戏中，可能设置别名为 userId。游戏运营时，发现该用户 3 天没有玩游戏了，则根据 userId 调用服务器端 API 发通知到客户端提醒用户。

**标签 Tag**:

为安装了应用程序的用户，打上标签。其目的主要是方便开发者根据标签，来批量下发 Push 消息。

可为每个用户打多个标签。

不同应用程序、不同的用户，可以打同样的标签。

举例： game, old_page, women。

#### 接口定义

```js
JPushPlugin.prototype.setTagsWithAlias(tags, alias, successCallback, errorCallback)
JPushPlugin.prototype.setTags(tags, successCallback, errorCallback)
JPushPlugin.prototype.setAlias(alias, successCallback, errorCallback)
```

#### 参数说明
* tags:
	* 参数类型为数组。
	* nil 此次调用不设置此值。
	* 空集合表示取消之前的设置。
	* 每次调用至少设置一个 tag，覆盖之前的设置，不是新增。
	* 有效的标签组成：字母（区分大小写）、数字、下划线、汉字。
	* 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 100 个 tag，但总长度不得超过1K字节（判断长度需采用 UTF-8 编码）。
	* 单个设备最多支持设置 100 个 tag，App 全局 tag 数量无限制。
* alias:
	* 参数类型为字符串。
	* nil 此次调用不设置此值。
	* 空字符串 （""）表示取消之前的设置。
	* 有效的别名组成：字母（区分大小写）、数字、下划线、汉字。
	* 限制：alias 命名长度限制为 40 字节（判断长度需采用 UTF-8 编码）。

#### 代码示例

```js
window.plugins.jPushPlugin.setTagsWithAlias([tag1, tag2], alias1, function () {
  // success callback.
}, function (errorMsg) {
  // errorMsg 格式为 'errorCode: error message'.
})
```

#### 错误码定义

|Code|描述                   		       |详细解释 |
|----|:----------------------------------------|:--------|
|6001|无效的设置，tag / alias 不应参数都为 null。  |   	 |
|6002|设置超时。			       	       |建议重试。|
|6003|alias 字符串不合法。	               |有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6004|alias超长。			       |最多 40个字节，中文 UTF-8 是 3 个字节。|
|6005|某一个 tag 字符串不合法。		       |有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6006|某一个 tag 超长。			       |一个 tag 最多 40个字节，中文 UTF-8 是 3 个字节。|
|6007|tags 数量超出限制，最多 100 个。	       |这是一台设备的限制，一个应用全局的标签数量无限制。|
|6008|tag / alias 超出总长度限制。	       	       |总长度最多 1K 字节。|
|6011|10s内设置 tag 或 alias 大于 3 次。	       |短时间内操作过于频繁。|


## 获取点击通知内容

### event - jpush.openNotification

点击通知进入应用程序时会出发改事件。

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

        document.addEventListener("jpush.openNotification", function (event) {
	      var alertContent
          if(device.platform == "Android") {
            alertContent = event.alert
          } else {
            lertContent = event.aps.alert
          }
	    }, false)

> ps：点击通知后传递的 json object 保存在 window.plugins.jPushPlugin.openNotification，直接访问即可，字段示例，根据实际推送情况，可能略有差别，请注意。

+ Android:

		{
			"title": "title",
			"alert":"ding",
			"extras":{
				"yourKey": "yourValue",
			    "cn.jpush.android.MSG_ID": "1691785879",
			    "app": "com.thi.pushtest",
			    "cn.jpush.android.ALERT": "ding",
			    "cn.jpush.android.EXTRA": {},
			    "cn.jpush.android.PUSH_ID": "1691785879",
			    "cn.jpush.android.NOTIFICATION_ID": 1691785879,
			    "cn.jpush.android.NOTIFICATION_TYPE": "0"
			}
		}

+ iOS:

		{
			"aps":{
			  	"badge": 1,
			  	"sound": "default",
			  	"alert": "今天去哪儿"
			 },
			"key1": "value1",
			"key2": "value2",
			"_j_msgid": 154604475
		}

## 获取通知内容

### event - jpush.receiveNotification

收到通知时会触发该事件。

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

		  document.addEventListener("jpush.receiveNotification", function (event) {
		    var alertContent
	        if(device.platform == "Android") {
	          alertContent = event.alert
	        } else {
	          alertContent = event.aps.alert
	        }
	        alert("open Notificaiton:" + alertContent)
		  }, false)


> ps：点击通知后传递的 json object 保存在 window.plugins.jPushPlugin.receiveNotification，直接访问即可，字段示例，根据实际推送情况，可能略有差别，请注意。

+ Android:

		{
			"title": "title",
			"alert":"ding",
			"extras":{
				"yourKey": "yourValue",
			    "cn.jpush.android.MSG_ID":"1691785879",
			    "app":"com.thi.pushtest",
			    "cn.jpush.android.ALERT":"ding",
			    "cn.jpush.android.EXTRA":{},
			    "cn.jpush.android.PUSH_ID":"1691785879",
			    "cn.jpush.android.NOTIFICATION_ID":1691785879,
			 	"cn.jpush.android.NOTIFICATION_TYPE":"0"
			}
		}

+ iOS:

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


## 获取自定义消息推送内容

### event - jpush.receiveMessage

收到自定义消息时触发这个事件，推荐使用事件的方式传递。

但同时保留了 receiveMessageIniOSCallback 的回调函数，兼容以前的代码。

#### 代码示例

- 在你需要接收通知的的 js 文件中加入:

	    document.addEventListener("jpush.receiveMessage", function (event) {
	      var message
          if(device.platform == "Android") {
            message = event.message;
          } else {
            message = event.content;
          }      
	    }, false)

> ps：点击通知后传递的 json object 保存在 window.plugins.jPushPlugin.receiveMessage，直接访问即可，字段示例，根据实际推送情况，可能略有差别，请注意。

+ Android:

		{
			"message":"今天去哪儿",
			"extras"{
				"yourKey": "yourValue",
				"cn.jpush.android.MSG_ID":"154378013",
				"cn.jpush.android.CONTENT_TYPE":"",
				"cn.jpush.android.EXTRA":{"key":"不添没有"}
			}
		}

+ iOS：

		{
			 "content":"今天去哪儿",
			 "extras":{"key":"不填写没有"}
		}

## 判断系统设置中是否允许当前应用推送
### API - getUserNotificationSettings
判断系统设置中是否允许当前应用推送。

在 Android 中，返回值为 0 时，代表系统设置中关闭了推送；为 1 时，代表打开了推送（目前仅适用于Android 4.4+）。

在 iOS 中，返回值为 0 时，代表系统设置中关闭了推送；大于 0 时，代表打开了推送，且能够根据返回值判断具体通知形式：

	UIRemoteNotificationTypeNone    = 0,		// 0
	UIRemoteNotificationTypeBadge   = 1 << 0,	// 1
	UIRemoteNotificationTypeSound   = 1 << 1,	// 2
	UIRemoteNotificationTypeAlert   = 1 << 2,	// 4
	UIRemoteNotificationTypeNewsstandContentAvailability = 1 << 3	// 8

#### 代码示例

	window.plugins.jPushPlugin.getUserNotificationSettings(function(result) {
		if(result == 0) {
			// 系统设置中已关闭应用推送。
		} else if(result > 0) {
			// 系统设置中打开了应用推送。
		})
