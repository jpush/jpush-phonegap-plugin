## Android API简介


### 接收通知时获得通知的信息

- 内容
    window.plugins.jPushPlugin.receiveNotification.alert;
- 标题
    window.plugins.jPushPlugin.receiveNotification.title;
- 附加字段
    window.plugins.jPushPlugin.receiveNotification.extras.yourKey;

### 打开通知时获得通知的信息

- 内容
    window.plugins.jPushPlugin.openNotification.alert;
- 标题
    window.plugins.jPushPlugin.openNotification.title;
- 附加字段
    window.plugins.jPushPlugin.openNotification.extras.yourKey;

### 收到自定义消息时获得通知的信息

- 内容
    window.plugins.jPushPlugin.receiveMessage.message;
- 附加字段
    window.plugins.jPushPlugin.receiveMessage.extras.yourKey;

### 获取集成日志

#### API - setDebugMode

用于开启调试模式，可以查看集成 JPush 过程中的 Log，如果集成失败，可方便定位问题所在。

##### 接口定义

	window.plugins.jPushPlugin.setDebugMode(mode)

##### 参数说明

- mode的值

	- true  显示集成日志
	- false 不显示集成日志


###  接收消息和点击通知事件
#### API - receiveMessageInAndroidCallback

用于 Android 收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用。

##### 接口定义

	window.plugins.jPushPlugin.receiveMessageInAndroidCallback = function(data)

##### 参数说明

- data 接收到的 js 字符串，包含的 key:value 请进入该函数体查看。

##### 代码示例

#### API - openNotificationInAndroidCallback

当点击 Android 手机的通知栏进入应用程序时,会调用这个函数，这个函数不需要主动调用，是作为回调函数来用的。

##### 接口定义

	window.plugins.jPushPlugin.openNotificationInAndroidCallback = function(data)

##### 参数说明

- data js字符串

##### 代码示例

###  统计分析 API

#### API - onResume / onPause

这是一个 Android Local API，不是 js 的 API，请注意
本 API 用于“用户使用时长”，“活跃用户”，“用户打开次数”的统计，并上报到服务器，在 Portal 上展示给开发者。


####接口定义

	public static void onResume(final Activity activity)
	public static void onPause(final Activity activity)

####参数说明

 ＋ Activity 当前所在的 Activity。

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

#### API - setStatisticsOpen(boolean)

用于在 js 中控制是否打开应用的统计分析功能，但如果已经添加了上面的 onResume / onPause 方法，
就不能再通过这个方法来控制统计分析功能了。

#### 接口定义

	window.plugins.jPushPlugin.setStatisticsOpen(boolean)

#### 参数说明

- boolean
	- true : 打开统计分析功能
	- false: 关闭统计分析功能

#### API - reportNotificationOpened

用于上报用户的通知栏被打开，或者用于上报用户自定义消息被展示等客户端需要统计的事件。

##### 接口定义

	window.plugins.jPushPlugin.reportNotificationOpened(msgID)

##### 参数说明
- msgID
	- 收到的通知或者自定义消息的 id 	


###  清除通知 API

#### API - clearAllNotification

推送通知到客户端时，由 JPush SDK 展现通知到通知栏上。

此 API 提供清除通知的功能，包括：清除所有 JPush 展现的通知（不包括非 JPush SDK 展现的）。


##### 接口定义

	window.plugins.jPushPlugin.clearAllNotification()

###  设置允许推送时间 API

#### API - setPushTime
默认情况下用户在任何时间都允许推送。即任何时候有推送下来，客户端都会收到，并展示。
开发者可以调用此 API 来设置允许推送的时间。
如果不在该时间段内收到消息，当前的行为是：推送到的通知会被扔掉。

##### 接口定义

    window.plugins.jPushPlugin.setPushTime(days, startHour, endHour)

##### 参数说明
- days: 数组 0表示星期天，1表示星期一，以此类推。 （7天制，数组中的int范围为0到6）set的值为null, 表示任何时间都可以收到消息和通知，set的size为0，则表示任何时间都收不到消息和通知.
- startHour: int 允许推送的开始时间 （24小时制：startHour的范围为0到23）
- endHour: int 允许推送的结束时间 （24小时制：endHour的范围为0到23）

###  设置通知静默时间 API

#### API - setSilenceTime
默认情况下用户在收到推送通知时，客户端可能会有震动，响铃等提示。但用户在睡觉、开会等时间点希望为 "免打扰" 模式，也是静音时段的概念。
开发者可以调用此 API 来设置静音时段。如果在该时间段内收到消息，则：不会有铃声和震动。

##### 接口定义

    window.plugins.jPushPlugin.setSilenceTime(startHour, startMinute, endHour, endMinute)

##### 参数说明

- startHour: int 静音时段的开始时间 - 小时 （24小时制，范围：0~23 ）
- startMinute: int 静音时段的开始时间 - 分钟（范围：0~59 ）
- endHour: 静音时段的结束时间 - 小时 （24小时制，范围：0~23 ）
- endMinute: 静音时段的结束时间 - 分钟（范围：0~59 ）


###  通知栏样式定制 API


#### API - setBasicPushNotificationBuilder, setCustomPushNotificationBuilder

当用户需要定制默认的通知栏样式时，则可调用此方法。
极光 Push SDK 提供了 2 个用于定制通知栏样式的构建类：

- setBasicPushNotificationBuilder
	- Basic 用于定制 Android Notification 里的 defaults / flags / icon 等基础样式（行为）。
- setCustomPushNotificationBuilder
	- 继承 Basic 进一步让开发者定制 Notification Layout。

如果不调用此方法定制，则极光 Push SDK 默认的通知栏样式是：Android 标准的通知栏提示。

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


###  本地通知 API
#### API - addLocalNotification,removeLocalNotification,clearLocalNotifications


本地通知 API 不依赖于网络，无网条件下依旧可以触发。

本地通知与网络推送的通知是相互独立的，不受保留最近通知条数上限的限制。

本地通知的定时时间是自发送时算起的，不受中间关机等操作的影响。


三个接口的功能分别为：添加一个本地通知，删除一个本地通知，删除所有的本地通知。

#####接口定义

	window.plugins.jPushPlugin.addLocalNotification = function(builderId,
			content, title, notificaitonID, broadcastTime, extras)
	window.plugins.jPushPlugin.removeLocalNotification = function(notificationID)
	window.plugins.jPushPlugin.clearLocalNotifications = function()

##### 参数说明

- builderId 设置本地通知样式。
- content 设置本地通知的 content。
- title 设置本地通知的 title。
- notificaitonID 设置本地通知的 ID。
- broadcastTime 设置本地通知触发时间，为距离当前时间的数值，单位是毫秒。
- extras 设置额外的数据信息 extras 为 json 字符串。
