## iOS API简介

### 获取 APNs（通知） 推送内容

#### event - jpush.receiveNotification

当iOS收到的通知时会触发这个事件


#####代码示例

- 在你需要接收通知的的js文件中加入:
	           
		document.addEventListener("jpush.receiveNotification", onReceiveNotification, false);

- onOpenNotification需要这样写：
		
            var onReceiveNotification = function(event){
                try{
                    var alert   = event.aps.alert;
                    console.log("JPushPlugin:onReceiveNotification key aps.alert:"+alert);
                }
                catch(exeption){
                    console.log(exception)
                }
            }
 



#### API - receiveMessageIniOSCallback

用于iOS收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用
不推荐使用回调函数

##### 接口定义

	JPushPlugin.prototype.receiveMessageIniOSCallback = function(data)

#####参数说明

- data 	是一个js字符串使用如下代码解析，js具体key根据应用内消息来确定
	
		var bToObj = JSON.parse(data);
		
#####返回值
无

#####  代码示例


### 页面的统计
#### API - startLogPageView,stopLogPageView,beginLogPageView

本 API 用于“用户指定页面使用时长”的统计，并上报到服务器，在 Portal 上展示给开发者。页面统计集成正确，才能够获取正确的页面访问路径、访问深度（PV）的数据。

##### 接口定义
	window.plugins.jPushPlugin.startLogPageView = function(pageName)
	window.plugins.jPushPlugin.stopLogPageView = function(pageName)
	window.plugins.jPushPlugin.beginLogPageView = function(pageName,duration)
#####参数说明
pageName 需要统计页面自定义名称
duration 自定义的页面时间
#####调用说明
应在所有的需要统计得页面得 viewWillAppear 和 viewWillDisappear 加入 startLogPageView 和 stopLogPageView 来统计当前页面的停留时间。

	或者直接使用 beginLogPageView 来自定义加入页面和时间信息。
#####返回值说明
无
#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.beginLogPageView("newPage",5);
		window.plugins.jPushPlugin.startLogPageView("onePage");
		window.plugins.jPushPlugin.stopLogPageView("onePage");
	}
### 设置Badge
#### API - setBadge,resetBadge

badge是iOS用来标记应用程序状态的一个数字，出现在程序图标右上角。 JPush封装badge功能，允许应用上传badge值至JPush服务器，由JPush后台帮助管理每个用户所对应的推送badge值，简化了设置推送badge的操作。

实际应用中，开发者可以直接对badge值做增减操作，无需自己维护用户与badge值之间的对应关系。
##### 接口定义

	window.plugins.jPushPlugin.setBadge(value)
	window.plugins.jPushPlugin.reSetBadge()

`resetBadge相当于setBadge(0)`
##### 参数说明
value 取值范围：[0,99999]
##### 返回值
无，控制台会有log打印设置结果
#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setBadge(5);
		window.plugins.jPushPlugin.reSetBadge();
	}

#### API - setApplicationIconBadgeNumber

设置iOS的角标，当设置badge＝0时为清除角标

##### 接口定义

	window.plugins.jPushPlugin.reSetBadge.setApplicationIconBadgeNumber(badge)
	
##### 参数说明

- badge 整形,例如0，1，2
- 当badge为0时，角标被清除

#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.reSetBadge.setApplicationIconBadgeNumber(0);
	}


### 本地通知

### 日志等级设置
#### API - setDebugModeFromIos
API 用于开启Debug模式，显示更多的日志信息

建议调试时开启这个选项，不调试的时候注释这句代码，这个函数setLogOFF是相反的一对
##### 接口定义

	window.plugins.jPushPlugin.reSetBadge.setDebugModeFromIos()
	
#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setDebugModeFromIos();
	}

#### API - setLogOFF

API用来关闭日志信息（除了必要的错误信息）

不需要任何调试信息的时候，调用此API （发布时建议调用此API，用来屏蔽日志信息，节省性能消耗)

##### 接口定义 

	window.plugins.jPushPlugin.reSetBadge.setLogOFF ()

#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setLogOFF();
	}

