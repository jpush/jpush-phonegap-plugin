# Android API 简介

- [清除通知](#清除通知)
- [设置允许推送时间](#设置允许推送时间)
- [设置通知静默时间](#设置通知静默时间)
- [通知栏样式定制](#通知栏样式定制)
- [设置保留最近通知条数](#设置保留最近通知条数)
- [本地通知](#本地通知)
- [获取推送连接状态](#获取推送连接状态)
- [地理围栏](#地理围栏)

## 获取集成日志（同时适用于 iOS）

### API - setDebugMode

用于开启调试模式，可以查看集成 JPush 过程中的 Log，如果集成失败，可方便定位问题所在。

#### 接口定义

```js
window.JPush.setDebugMode(mode)
```

#### 参数说明

- mode:
  - true  显示集成日志。
  - false 不显示集成日志。

### API - reportNotificationOpened

用于上报用户的通知栏被打开，或者用于上报用户自定义消息被展示等客户端需要统计的事件。

#### 接口定义

```js
window.JPush.reportNotificationOpened(msgID)
```

#### 参数说明

- msgID: 收到的通知或者自定义消息的 id。

##  清除通知

### API - clearAllNotification

推送通知到客户端时，由 JPush SDK 展现通知到通知栏上。

此 API 提供清除通知的功能，包括：清除所有 JPush 展现的通知（不包括非 JPush SDK 展现的）。

#### 接口定义

```js
window.JPush.clearAllNotification()
```

### API - clearNotificationById
根据通知 Id 清除通知（包括本地通知）。

#### 接口定义

```js
window.JPush.clearNotificationById(notificationId)
```

#### 参数说明
- notificationId：int，通知的 id。

#### 代码示例

```js
window.JPush.clearNotificationById(1)
```

## 设置允许推送时间

### API - setPushTime

默认情况下用户在任何时间都允许推送。即任何时候有推送下来，客户端都会收到，并展示。
开发者可以调用此 API 来设置允许推送的时间。
如果不在该时间段内收到消息，当前的行为是：推送到的通知会被扔掉。

#### 接口定义

```js
window.JPush.setPushTime(days, startHour, endHour)
```

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

```js
window.JPush.setSilenceTime(startHour, startMinute, endHour, endMinute)
```

#### 参数说明

- startHour: 整形，静音时段的开始时间 - 小时 （24小时制，范围：0~23 ）。
- startMinute: 整形，静音时段的开始时间 - 分钟（范围：0~59 ）。
- endHour: 整形，静音时段的结束时间 - 小时 （24小时制，范围：0~23 ）。
- endMinute: 整形，静音时段的结束时间 - 分钟（范围：0~59 ）。

##  通知栏样式定制

目前 REST API 与极光控制台均已支持「大文本通知栏样」、「文本条目通知栏样式」和「大图片通知栏样式」。可直接推送对应样式
的通知。

此外也能够通过设置 Notification 的 flag 来控制通知提醒方式，具体用法可参考 [后台 REST API](https://docs.jiguang.cn/jpush/server/push/rest_api_v3_push/#notification)。

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

```js
window.JPush.setBasicPushNotificationBuilder()
window.JPush.setCustomPushNotificationBuilder()
```

##  设置保留最近通知条数

### API - setLatestNotificationNum

通过极光推送，推送了很多通知到客户端时，如果用户不去处理，就会有很多保留在那里。

默认为保留最近 5 条通知，开发者可通过调用此 API 来定义为不同的数量。

#### 接口定义

```js
window.JPush.setLatestNotificationNum(num)
```

#### 参数说明

- num: 保存的条数。

##  本地通知
### API - addLocalNotification, removeLocalNotification, clearLocalNotifications
本地通知 API 不依赖于网络，无网条件下依旧可以触发。

本地通知与网络推送的通知是相互独立的，不受保留最近通知条数上限的限制。

本地通知的定时时间是自发送时算起的，不受中间关机等操作的影响。

三个接口的功能分别为：添加一个本地通知，清除一个本地通知，清除所有的本地通知。

#### 接口定义

```js
window.JPush.addLocalNotification(builderId, content, title, notificationID, broadcastTime, extras)
window.JPush.removeLocalNotification(notificationID)
window.JPush.clearLocalNotifications() // 同时适用于 iOS
```

#### 参数说明

- builderId: 设置本地通知样式。
- content: 设置本地通知的 content。
- title: 设置本地通知的 title。
- notificationID: 设置本地通知的 ID（不要为 0）。
- broadcastTime: 设置本地通知触发时间，为距离当前时间的数值，单位是毫秒。
- extras: 设置额外的数据信息 extras 为 json 字符串。

## 获取推送连接状态

### API - getConnectionState

开发者可以使用此功能获取当前 Push 服务的连接状态

#### 接口定义

```js
window.JPush.getConnectionState(callback)
```

#### 参数说明

- callback: 回调函数，用来通知 JPush 的推送服务是否开启。

#### 代码示例

```js
window.JPush.getConnectionState(function (result) {
  if (result == 0) {
    // 链接状态
  } else {
    // 断开状态
  }
})
```

## 地理围栏

### API - setGeofenceInterval

设置地理围栏监控周期，最小3分钟，最大1天。默认为15分钟，当距离地理围栏边界小于1000米周期自动调整为3分钟。设置成功后一直使用设置周期，不会进行调整。

#### 接口定义

```js
window.JPush.setGeofenceInterval(interval)
```

#### 参数说明

- interval: 监控周期，单位是毫秒。

### API - setMaxGeofenceNumber

设置最多允许保存的地理围栏数量，超过最大限制后，如果继续创建先删除最早创建的地理围栏。默认数量为10个，允许设置最小1个，最大100个。

#### 接口定义

```js
window.JPush.setMaxGeofenceNumber(maxNumber)
```

#### 参数说明

- maxNumber: 最多允许保存的地理围栏个数