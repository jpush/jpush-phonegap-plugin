# Android API 简介

- [注册成功事件](#注册成功事件)
- [接收通知时获得通知的内容](#接收通知时获得通知的内容)
- [打开通知时获得通知的内容](#打开通知时获得通知的内容)
- [收到自定义消息时获取消息的内容](#收到自定义消息时获取消息的内容)
- [获取集成日志（同时适用于 iOS）](#获取集成日志同时适用于-ios)
- [接收消息和点击通知事件](#接收消息和点击通知事件)
- [统计分析](#统计分析)
- [清除通知](#清除通知)
- [设置允许推送时间](#设置允许推送时间)
- [设置通知静默时间](#设置通知静默时间)
- [通知栏样式定制](#通知栏样式定制)
- [设置保留最近通知条数](#设置保留最近通知条数)
- [本地通知](#本地通知)
- [富媒体页面 JavaScript 回调 API](#富媒体页面-javascript-回调-api)

## 注册成功事件
### jpush.receiveRegistrationId
集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。
就会触发这个事件（注意只有第一次会触发该事件，之后如果想要取到 registrationId，可以直接调用 *getRegistrationID* 方法）。

#### 代码示例
```Javascript
document.addEventListener('jpush.receiveRegistrationId', function (event) {
    console.log(event.registrationId)
}, false)
```

## 接收通知时获得通知的内容

- 内容:
    window.plugins.jPushPlugin.receiveNotification.alert
- 标题:
    window.plugins.jPushPlugin.receiveNotification.title
- 附加字段:
    window.plugins.jPushPlugin.receiveNotification.extras.yourKey

## 打开通知时获得通知的内容

- 内容:
    window.plugins.jPushPlugin.openNotification.alert
- 标题:
    window.plugins.jPushPlugin.openNotification.title
- 附加字段
    window.plugins.jPushPlugin.openNotification.extras.yourKey

## 收到自定义消息时获取消息的内容

- 内容:
    window.plugins.jPushPlugin.receiveMessage.message
- 附加字段:
    window.plugins.jPushPlugin.receiveMessage.extras.yourKey

## 获取集成日志（同时适用于 iOS）

### API - setDebugMode

用于开启调试模式，可以查看集成 JPush 过程中的 Log，如果集成失败，可方便定位问题所在。

#### 接口定义

	window.plugins.jPushPlugin.setDebugMode(mode)

#### 参数说明

- mode:
	- true  显示集成日志。
	- false 不显示集成日志。

##  接收消息和点击通知事件
### API - receiveMessageInAndroidCallback

用于 Android 收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用。

#### 接口定义

	window.plugins.jPushPlugin.receiveMessageInAndroidCallback(data)

#### 参数说明

- data: 接收到的 js 字符串，包含的 key:value 请进入该函数体查看。


### API - openNotificationInAndroidCallback

当点击 Android 手机的通知栏进入应用程序时，会调用这个函数，这个函数不需要主动调用，是作为回调函数来用的。

#### 接口定义

	window.plugins.jPushPlugin.openNotificationInAndroidCallback(data)

#### 参数说明

- data: js 字符串。

##  统计分析

### API - onResume / onPause

这是一个 Android Local API，不是 js 的 API，请注意。
本 API 用于“用户使用时长”，“活跃用户”，“用户打开次数”的统计，并上报到服务器，在 Portal 上展示给开发者。

#### 接口定义

	public static void onResume(final Activity activity)
	public static void onPause(final Activity activity)

#### 参数说明

 - Activity: 当前所在的 Activity。

#### 调用说明

应在所有的 Activity 的 onResume / onPause 方法里调用。

#### 代码示例

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

### API - setStatisticsOpen

用于在 js 中控制是否打开应用的统计分析功能，但如果已经添加了上面的 onResume / onPause 方法，
就不能再通过这个方法来控制统计分析功能了。

#### 接口定义

	window.plugins.jPushPlugin.setStatisticsOpen(boolean)

#### 参数说明

- boolean:
	- true: 打开统计分析功能。
	- false: 关闭统计分析功能。

### API - reportNotificationOpened

用于上报用户的通知栏被打开，或者用于上报用户自定义消息被展示等客户端需要统计的事件。

#### 接口定义

	window.plugins.jPushPlugin.reportNotificationOpened(msgID)

#### 参数说明

- msgID: 收到的通知或者自定义消息的 id。


##  清除通知

### API - clearAllNotification

推送通知到客户端时，由 JPush SDK 展现通知到通知栏上。

此 API 提供清除通知的功能，包括：清除所有 JPush 展现的通知（不包括非 JPush SDK 展现的）。

#### 接口定义

	window.plugins.jPushPlugin.clearAllNotification()

### API - clearNotificationById
根据通知 Id 清除通知（包括本地通知）。

#### 接口定义

    window.plugins.jPushPlugin.clearNotificationById(notificationId)

#### 参数说明
- notificationId：int，通知的 id。

#### 代码示例

    window.plugins.jPushPlugin.clearNotificationById(1)

## 设置允许推送时间

### API - setPushTime
默认情况下用户在任何时间都允许推送。即任何时候有推送下来，客户端都会收到，并展示。
开发者可以调用此 API 来设置允许推送的时间。
如果不在该时间段内收到消息，当前的行为是：推送到的通知会被扔掉。

#### 接口定义

    window.plugins.jPushPlugin.setPushTime(days, startHour, endHour)

#### 参数说明
- days: 数组，0 表示星期天，1 表示星期一，以此类推（7天制，数组中值的范围为 0 到 6 ）。
数组的值为 null, 表示任何时间都可以收到消息和通知，数组的 size 为 0，则表示任何时间都收不到消息和通知。
- startHour: 整形，允许推送的开始时间 （24 小时制：startHour 的范围为 0 到 23）。
- endHour: 整形，允许推送的结束时间 （24 小时制：endHour 的范围为 0 到 23）。

##  设置通知静默时间

### API - setSilenceTime
默认情况下用户在收到推送通知时，客户端可能会有震动，响铃等提示。
但用户在睡觉、开会等时间点希望为 "免打扰" 模式，也是静音时段的概念。
开发者可以调用此 API 来设置静音时段。如果在该时间段内收到消息，则：不会有铃声和震动。

#### 接口定义

    window.plugins.jPushPlugin.setSilenceTime(startHour, startMinute, endHour, endMinute)

#### 参数说明

- startHour: 整形，静音时段的开始时间 - 小时 （24小时制，范围：0~23 ）。
- startMinute: 整形，静音时段的开始时间 - 分钟（范围：0~59 ）。
- endHour: 整形，静音时段的结束时间 - 小时 （24小时制，范围：0~23 ）。
- endMinute: 整形，静音时段的结束时间 - 分钟（范围：0~59 ）。


##  通知栏样式定制

### API - setBasicPushNotificationBuilder, setCustomPushNotificationBuilder

当用户需要定制默认的通知栏样式时，则可调用此方法。
需要用户去自定义 ../JPushPlugin.java 中的同名方法代码，然后再在 js 端 调用该方法。

具体用法可参考[官方文档](http://docs.jiguang.cn/jpush/client/Android/android_api/#api_6)。

JPush SDK 提供了 2 个用于定制通知栏样式的构建类：

- setBasicPushNotificationBuilder:
    Basic 用于定制 Android Notification 里的 defaults / flags / icon 等基础样式（行为）。
- setCustomPushNotificationBuilder:
    继承 Basic 进一步让开发者定制 Notification Layout。

如果不调用此方法定制，则极光 Push SDK 默认的通知栏样式是 Android 标准的通知栏。

#### 接口定义

	window.plugins.jPushPlugin.setBasicPushNotificationBuilder()
	window.plugins.jPushPlugin.setCustomPushNotificationBuilder()


##  设置保留最近通知条数

### API - setLatestNotificationNum

通过极光推送，推送了很多通知到客户端时，如果用户不去处理，就会有很多保留在那里。

默认为保留最近 5 条通知，开发者可通过调用此 API 来定义为不同的数量。

#### 接口定义

	window.plugins.jPushPlugin.setLatestNotificationNum(num)

#### 参数说明

- num: 保存的条数。


##  本地通知
### API - addLocalNotification, removeLocalNotification, clearLocalNotifications
本地通知 API 不依赖于网络，无网条件下依旧可以触发。

本地通知与网络推送的通知是相互独立的，不受保留最近通知条数上限的限制。

本地通知的定时时间是自发送时算起的，不受中间关机等操作的影响。

三个接口的功能分别为：添加一个本地通知，清除一个本地通知，清除所有的本地通知。

#### 接口定义

	window.plugins.jPushPlugin.addLocalNotification(builderId, content, title,
         notificaitonID, broadcastTime, extras)
	window.plugins.jPushPlugin.removeLocalNotification(notificationID)
	window.plugins.jPushPlugin.clearLocalNotifications() // 同时适用于 iOS

#### 参数说明

- builderId: 设置本地通知样式。
- content: 设置本地通知的 content。
- title: 设置本地通知的 title。
- notificaitonID: 设置本地通知的 ID（不要为 0）。
- broadcastTime: 设置本地通知触发时间，为距离当前时间的数值，单位是毫秒。
- extras: 设置额外的数据信息 extras 为 json 字符串。


## 富媒体页面 JavaScript 回调 API
富媒体推送通知时，用户可以用自定义的Javascript 函数来控制页面，如关闭当前页面，点击按钮跳转到指定的 Activity，通知应用程序做一些指定的动作等。

此 API 提供的回调函数包括：关闭当前页面、打开应用的主 Activity、根据 Activity 名字打开对应的 Activity、以广播的形式传递页面参数到应用程序等功能。

### API - 关闭当前页面

    JPushWeb.close();   // 在富文本 HTML 页面中调用后会关闭当前页面。

### API - 打开主 Activity

    JPushWeb.startMainActivity(String params);

在HTML中调用此函数后,会打开程序的主Activity， 并在对应的 Intent 传入参数 ”params“ ，Key 为 JPushInterface.EXTRA_EXTRA。

对应 Activity 获取 params 示例代码：

    Intent intent = getIntent();
    if (null != intent ) {
        String params = intent.getStringExtra(JPushInterface.EXTRA_EXTRA);
    }

### API - 触发应用中的操作

    JPushWeb.triggerNativeAction(String params);

调用了该方法后需要在 MyReceiver.java 中实现后面的业务逻辑：

    if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
        Log.d(TAG, "用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
        //在这里根据 JPushInterface.EXTRA_EXTRA 的内容触发客户端动作，比如打开新的Activity 、打开一个网页等。
    }

#### 代码示例

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
     <head>
      <title>JPush Webview Test</title>
      <script>
           function clickButton() {
             JPushWeb.close();
           }

          function openUrl() {
             var json = "{'action':'open', 'url':'www.jpush.cn'}";
             JPushWeb.triggerNativeAction(json);
             JPushWeb.close(); //客服端在广播中收到json 后，可以打开对应的URL。
          }
     </script>
     </head>
     <body>
         <button onclick="javascript:clickButton(this);return false;">Close</button>
         <button onclick="javascript:JPushWeb.startMainActivity('test - startMainActivity');return false;">StartMainActivity</button>
         <button onclick="javascript:JPushWeb.triggerNativeAction('test - triggerNativeAction');Javascript:JPushWeb.close();">triggerNativeAction and Close current webwiew</button>
         <button onclick="javascript:JPushWeb.startActivityByName('com.example.jpushdemo.TestActivity','test - startActivityByName');">startActivityByName</button>
         <button onclick="javascript:openUrl();">open a url</button>
     </body>
    </html>
