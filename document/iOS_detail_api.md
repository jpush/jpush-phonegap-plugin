## iOS API简介

### 获取 APNs（通知） 推送内容


#### API - receiveMessageIniOSCallback

用于iOS收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用
不推荐使用回调函数

##### 接口定义

	JPushPlugin.prototype.receiveMessageIniOSCallback = function(data)

#####参数说明

- data 	是一个js字符串使用如下代码解析，js具体key根据应用内消息来确定
	
		var bToObj = JSON.parse(data)
		
#####返回值
无

#####  代码示例


### 页面的统计
#### API - startLogPageView,stopLogPageView,beginLogPageView

本 API 用于“用户指定页面使用时长”的统计，并上报到服务器，在 Portal 上展示给开发者。页面统计集成正确，才能够获取正确的页面访问路径、访问深度（PV）的数据。

##### 接口定义
	window.plugins.jPushPlugin.prototype.startLogPageView = function(pageName)
	window.plugins.jPushPlugin.prototype.stopLogPageView = function(pageName)
	window.plugins.jPushPlugin.prototype.beginLogPageView = function(pageName,duration)
#####参数说明
pageName 需要统计页面自定义名称
duration 自定义的页面时间
#####调用说明
应在所有的需要统计得页面得 viewWillAppear 和 viewWillDisappear 加入 startLogPageView 和 stopLogPageView 来统计当前页面的停留时间。

	或者直接使用 beginLogPageView 来自定义加入页面和时间信息。
#####返回值说明
无
#####代码示例

	window.plugins.jPushPlugin.beginLogPageView("newPage",5);
	window.plugins.jPushPlugin.startLogPageView("onePage");
	window.plugins.jPushPlugin.stopLogPageView("onePage");

### 设置Badge
#### API - setBadge,resetBadge

 JPush封装badge功能，允许应用上传badge值至JPush服务器，由JPush后台帮助管理每个用户所对应的推送badge值，简化了设置推送badge的操作。
（本接口不会直接改变应用本地的角标值. 要修改本地badege值，使用 setApplicationIconBadgeNumber）

实际应用中，开发者可以直接对badge值做增减操作，无需自己维护用户与badge值之间的对应关系。
##### 接口定义

	window.plugins.jPushPlugin.prototype.setBadge(value)
	window.plugins.jPushPlugin.prototype.reSetBadge()

`resetBadge相当于setBadge(0)`
##### 参数说明
value 取值范围：[0,99999]
##### 返回值
无，控制台会有log打印设置结果
#####代码示例

	window.plugins.jPushPlugin.setBadge(5);
	window.plugins.jPushPlugin.reSetBadge();

#### API - setApplicationIconBadgeNumber

本接口直接改变应用本地的角标值.
设置iOS的角标，当设置badge＝0时为清除角标

##### 接口定义

	window.plugins.jPushPlugin.prototype.setApplicationIconBadgeNumber(badge)
	
##### 参数说明

- badge 整形,例如0，1，2
- 当badge为0时，角标被清除

#####代码示例

	window.plugins.jPushPlugin.setApplicationIconBadgeNumber(0);


#### API - getApplicationIconBadgeNumber

获取iOS的角标值

##### 接口定义

	window.plugins.jPushPlugin.prototype.getApplicationIconBadgeNumber(callback)
	
##### 参数说明

- callback 回调函数

#####代码示例
```			    	

window.plugins.jPushPlugin.getApplicationIconBadgeNumber(function(data){
     console.log(data);               
 });
 
``` 

### 本地通知
#### API - addLocalNotificationForIOS

API用于注册本地通知

最多支持64个

##### 接口定义 

	window.plugins.jPushPlugin.prototype.addLocalNotificationForIOS(delayTime,content,badge,notificationID,extras)

##### 参数说明

- delayTime 本地推送延迟多长时间后显示，数值类型或纯数字的字符型均可
- content 本地推送需要显示的内容
- badge 角标的数字。如果不需要改变角标传-1。数值类型或纯数字的字符型均可
- notificationID 本地推送标识符,字符串。
- extras 自定义参数，可以用来标识推送和增加附加信息。字典类型。

#####代码示例

	window.plugins.jPushPlugin.addLocalNotificationForIOS(6*60*60,"本地推送内容",1,"notiId",{"key":"value"});

#### API - deleteLocalNotificationWithIdentifierKeyInIOS

API删除本地推送定义

##### 接口定义 

	window.plugins.jPushPlugin.prototype.deleteLocalNotificationWithIdentifierKeyInIOS(identifierKey)

##### 参数说明

- identifierKey 本地推送标识符

#####代码示例

        window.plugins.jPushPlugin.deleteLocalNotificationWithIdentifierKeyInIOS("identifier");
        
#### API - clearAllLocalNotifications

API清除所有本地推送对象

##### 接口定义 

	window.plugins.jPushPlugin.prototype.clearAllLocalNotifications()

#####代码示例

        window.plugins.jPushPlugin.clearAllLocalNotifications();
        
### 日志等级设置
#### API - setDebugModeFromIos
API 用于开启Debug模式，显示更多的日志信息

建议调试时开启这个选项，不调试的时候注释这句代码，这个函数setLogOFF是相反的一对
##### 接口定义

	window.plugins.jPushPlugin.prototype.setDebugModeFromIos()
	
#####代码示例

	window.plugins.jPushPlugin.setDebugModeFromIos();

#### API - setLogOFF

API用来关闭日志信息（除了必要的错误信息）

不需要任何调试信息的时候，调用此API （发布时建议调用此API，用来屏蔽日志信息，节省性能消耗)

##### 接口定义 

	window.plugins.jPushPlugin.prototype.setLogOFF()

#####代码示例

	window.plugins.jPushPlugin.setLogOFF();

#### API - setCrashLogON

API用于统计用户应用崩溃日志

如果需要统计Log信息，调用该接口。当你需要自己收集错误信息时，切记不要调用该接口。


##### 接口定义 

	window.plugins.jPushPlugin.prototype.setCrashLogON()

#####代码示例

	window.plugins.jPushPlugin.setCrashLogON();
	
### 地理位置上报
#### API - setLocation
API 用于统计用户地理信息

##### 接口定义

window.plugins.jPushPlugin.prototype.setLocation(latitude,longitude)

##### 参数说明

- latitude 地理位置纬度，数值类型或纯数字的字符型均可
- longitude 地理位置精度，数值类型或纯数字的字符型均可

#####代码示例

window.plugins.jPushPlugin.setLocation(39.26,115.25);

### 设备平台判断
#### API - isPlatformIOS
API 用于区分iOS、Android平台，以便不同设置

##### 接口定义

	window.plugins.jPushPlugin.prototype.isPlatformIOS()
	
#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		//iOS
	}else{
		//Android
	}
