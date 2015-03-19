## JPush PhoneGap Plugin ##
###创建项目###
1. cordova create 文件夹名字 包名 应用名字

		cordova create Myproj com.myproj.jpush MyTestProj
		
2. 添加平台

		cd Myproj :不进入项目会出现[RangeError:Maximum call stack size exceeded]
		cordova platform add android  
		cordova platform add ios

### Android使用PhoneGap/Cordova CLI自动安装

1. 使用git命令将jpush phonegap插件下载的本地,将这个目录标记为`$JPUSH_PLUGIN_DIR`
		
		git clone https://github.com/jpush/jpush-phonegap-plugin.git
		
2. 将`$JPUSH_PLUGIN_DIR/plugin.xml`文件中的AppKey替换为在Portal上注册该应用的的Key,例如（9fed5bcb7b9b87413678c407）
		
		<meta-data android:name="JPUSH_APPKEY" android:value="your appkey"/>

3. 在`$JPUSH_PLUGIN_DIR/src/android/JPushPlugin.java` 文件`import your.package.name.R`替换为在Portal上注册该应用的包名，例如(com.thi.pushtest)


4. cordova cli 添加jpush phonegap插件和依赖的device插件: 

		cordova plugin add $JPUSH_PLUGIN_DIR
		cordova plugin add org.apache.cordova.device


5. 在js中调用函数,初始化jpush sdk

		 window.plugins.jPushPlugin.init();
		 window.plugins.jPushPlugin.setDebugMode(true);


###IOS使用PhoneGap/Cordova CLI自动安装

1. 使用PhoneGap/Cordova CLI命令安装

		cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git
		cordova build ios

2. 修改Resources/PushConfig.plist文件

在APP_KEY和CHANNLE字段 分别添加您的appkey和channle

3. 在AppDelegate.m中包含头文件

		#import "APService.h"
	    #import "JPushPlugin.h"


4. 在AppDelegate.m文件中，调用 JPush SDK 提供的 API 来实现功能


		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		    #if __has_feature(objc_arc)
		      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		    #else
		      self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
		    #endif
		    self.window.backgroundColor = [UIColor whiteColor];
		    [self.window makeKeyAndVisible];
		    // Required
		#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
		   if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		    //可以添加自定义categories
		    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
		                                                   UIUserNotificationTypeSound |
		                                                   UIUserNotificationTypeAlert)
		                                       categories:nil];
		  } else {
		    //categories 必须为nil
		    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
		                                                   UIRemoteNotificationTypeSound |
		                                                   UIRemoteNotificationTypeAlert)
		                                       categories:nil];
		  }
		#else
		    //categories 必须为nil
		  [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
		                                                 UIRemoteNotificationTypeSound |
		                                                 UIRemoteNotificationTypeAlert)
		                                     categories:nil];
		#endif
		    // Required
		    [APService setupWithOption:launchOptions];
		    return YES;
		}
		- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
		    // Required
		    [APService registerDeviceToken:deviceToken];
		}
		- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
		    // Required
		    [APService handleRemoteNotification:userInfo];
    		[[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification
                                                                object:userInfo];

		}

###Android 手工安装###
1. 复制src/android/*.java 到cn/jpush/phonega/目录下(即：cn.jpush.phonegap的包下)
2. 复制src/android/armeabi/libjpush.so 到lib/armeabi/
3. 复制src/android/jpush-sdk-release1.5.0.jar 到lib/
4. 复制src/android/test_notification_layout.xml到res/layout/
5. 复制src/android/jpush_notification_icon.png 到res/drawable/
6. 修改 AndroidManifest.xml 在 manifest 节点下添加以下权限

		<!-- Required  一些系统要求的权限，如访问网络等-->
		<uses-permission android:name="$PACKAGE_NAME.permission.JPUSH_MESSAGE"/>
		<uses-permission android:name="android.permission.RECEIVE_USER_PRESENT"/>
		<uses-permission android:name="android.permission.INTERNET"/>
		<uses-permission android:name="android.permission.WAKE_LOCK"/>
		<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
		<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
		<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
		<uses-permission android:name="android.permission.VIBRATE"/>
		<uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/>
		<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
		<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
		<permission
		      android:name="$PACKAGE_NAME.permission.JPUSH_MESSAGE"
		      android:protectionLevel="signature"/>

7. 修改AndroidManifest.xml 在 manifest/application 节点下添加SDK相关组件声明

		<activity
			android:name="cn.jpush.android.ui.PushActivity"
			android:theme="@android:style/Theme.Translucent.NoTitleBar"
			android:configChanges="orientation|keyboardHidden">
			<intent-filter>
			<action android:name="cn.jpush.android.ui.PushActivity"/>
			<category android:name="android.intent.category.DEFAULT"/>
			<category android:name="$PACKAGE_NAME"/>
			</intent-filter>
		</activity>
		<!-- Required  SDK核心功能-->
		<service
			android:name="cn.jpush.android.service.DownloadService"
			android:enabled="true"
			android:exported="false">
		</service>
		<!-- Required SDK 核心功能-->
		<service
			android:name="cn.jpush.android.service.PushService"
			android:enabled="true"
			android:exported="false">
			<intent-filter>
				<action android:name="cn.jpush.android.intent.REGISTER"/>
				<action android:name="cn.jpush.android.intent.REPORT"/>
				<action android:name="cn.jpush.android.intent.PushService"/>
				<action android:name="cn.jpush.android.intent.PUSH_TIME"/>
			
			</intent-filter>
		</service>
		<!-- Required SDK核心功能-->
		<receiver
		android:name="cn.jpush.android.service.PushReceiver"
		android:enabled="true">
			<intent-filter android:priority="1000">
				<action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED_PROXY"/>
				<!--Required  显示通知栏 -->
				<category android:name="$PACKAGE_NAME"/>
			</intent-filter>
			<intent-filter>
				<action android:name="android.intent.action.USER_PRESENT"/>
				<action android:name="android.net.conn.CONNECTIVITY_CHANGE"/>
			</intent-filter>
			<!-- Optional -->
			<intent-filter>
				<action android:name="android.intent.action.PACKAGE_ADDED"/>
				<action android:name="android.intent.action.PACKAGE_REMOVED"/>
				<data android:scheme="package"/>
			</intent-filter>
		</receiver>
		
		<!-- User defined.  For test only  用户自定义的广播接收器 -->
		<receiver
		android:name="cn.jpush.phonegap.MyReceiver"
		android:enabled="true">
			<intent-filter android:priority="1000">
				<action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED_PROXY"/>
				<!-- Required  显示通知栏 -->
				<category android:name="$PACKAGE_NAME"/>
				</intent-filter>
			<intent-filter>
			<action android:name="cn.jpush.android.intent.REGISTRATION"/>
			<!-- Required  用户注册SDK的intent -->
			<action android:name="cn.jpush.android.intent.UNREGISTRATION"/>
			<action android:name="cn.jpush.android.intent.MESSAGE_RECEIVED"/>
			<!-- Required  用户接收SDK消息的intent -->
			<action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED"/>
			<!-- Required  用户接收SDK通知栏信息的intent -->
			<action android:name="cn.jpush.android.intent.NOTIFICATION_OPENED"/>
			<!-- Required  用户打开自定义通知栏的intent -->
			<action android:name="cn.jpush.android.intent.ACTION_RICHPUSH_CALLBACK"/>
			<!-- Optional 用户接受Rich Push Javascript 回调函数的intent -->
			<category android:name="$PACKAGE_NAME"/>
			</intent-filter>
		</receiver>
		<!-- Required SDK核心功能-->
		<receiver android:name="cn.jpush.android.service.AlarmReceiver"/>
		<!-- Required  . Enable it you can get statistics data with channel -->
		<meta-data android:name="JPUSH_CHANNEL" android:value="developer-default"/>
		<meta-data android:name="JPUSH_APPKEY" android:value="299d0fee887820e7d90a68b2"/>


### IOS手工安装

1. 添加src/ios/Plugins/到project中  
2. 添加src/ios/lib/到project中  
3. 设置 Search Paths 下的 User Header Search Paths 和 Library Search Paths  

比如SDK文件夹（默认为lib）与工程文件在同一级目录下，则都设置为"$(SRCROOT)/[文件夹名称]"即可。

4. 确认一下的框架是存在的(Target -> Build Phases -> Link Binary With Libraries)

		CFNetwork.framework
		CoreFoundation.framework
		CoreTelephony.framework
		SystemConfiguration.framework
		CoreGraphics.framework
		Foundation.framework
		UIKit.framework


5. 在你的工程中创建一个新的Property List文件

		并将其命名为PushConfig.plist，填入Portal为你的应用提供的APP_KEY等参数


6. 调用代码,监听系统事件，相应地调用 JPush SDK 提供的 API 来实现功能

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
		{
		    #if __has_feature(objc_arc)
		      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		    #else
		      self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
		    #endif
		    self.window.backgroundColor = [UIColor whiteColor];
		    [self.window makeKeyAndVisible];
		 
		    // Required
		    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
		                                                    UIRemoteNotificationTypeSound |
		                                                    UIRemoteNotificationTypeAlert)];
		    // Required
		    [APService setupWithOption:launchOptions];
		     
		    return YES;
		}
		 
		- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
		     
		    // Required
		    [APService registerDeviceToken:deviceToken];
		}
		 
		- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
		     
		    // Required
		    [APService handleRemoteNotification:userInfo];
		}


7. 修改phonegap config.xml文件用来包含Plugin/内的插件


		<feature name="JPushPlugin">
		    <param name="ios-package" value="JPushPlugin" />
		    <param name="onload" value="true" />
		</feature>


8. 复制www/PushNotification.js到工程的www目录下面  
9. 在需要使用插件处加入

		<script type="text/javascript" src="JPushPlugin.js"></script>

###示例

1. 完整的示例可以点击网页右侧的"Download Zip"下载，下载完成后在文件的"src/ios/example"文件夹内找到并拷贝以下文件

		src/ios/example/index.html to www/index.html
		src/ios/example/css/* to www/css
		src/ios/example/js/* to www/js

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

这里只说明public的函数


#### API - setTagsWithAlias,setTags,setAlias

提供几个相关 API 用来设置别名（alias）与标签（tags）。

这几个 API 可以在 App 里任何地方调用。

别名 alias

为安装了应用程序的用户，取个别名来标识。以后给该用户 Push 消息时，就可以用此别名来指定。

每个用户只能指定一个别名。

同一个应用程序内，对不同的用户，建议取不同的别名。这样，尽可能根据别名来唯一确定用户。

系统不限定一个别名只能指定一个用户。如果一个别名被指定到了多个用户，当给指定这个别名发消息时，服务器端API会同时给这多个用户发送消息。

举例：在一个用户要登录的游戏中，可能设置别名为 userid。游戏运营时，发现该用户 3 天没有玩游戏了，则根据 userid 调用服务器端API发通知到客户端提醒用户。

标签 tag

为安装了应用程序的用户，打上标签。其目的主要是方便开发者根据标签，来批量下发 Push 消息。

可为每个用户打多个标签。

不同应用程序、不同的用户，可以打同样的标签。

举例： game, old_page, women

##### 接口定义

	JPushPlugin.prototype.setTagsWithAlias = function(tags,alias)
	JPushPlugin.prototype.setTags = function(tags)
	JPushPlugin.prototype.setAlias = function(alias)

#####使用平台
android iOS


##### 参数说明
* tags
	* 参数类型为数组	
	* nil 此次调用不设置此值
	* 空集合表示取消之前的设置 
	* 每次调用至少设置一个 tag，覆盖之前的设置，不是新增
	* 有效的标签组成：字母（区分大小写）、数字、下划线、汉字
	* 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 100 个 tag，但总长度不得超过1K字节。（判断长度需采用UTF-8编码）
	* 单个设备最多支持设置 100 个 tag。App 全局 tag 数量无限制。
* alias 
	* 参数类型为字符串
	* nil 此次调用不设置此值
	* 空字符串 （""）表示取消之前的设置
	* 有效的别名组成：字母（区分大小写）、数字、下划线、汉字。
	* 限制：alias 命名长度限制为 40 字节。（判断长度需采用UTF-8编码）
	
##### 返回值说明

函数本身无返回值，但需要注册`jpush.setTagsWithAlias	`事件来监听设置结果
	
	document.addEventListener("jpush.setTagsWithAlias", onTagsWithAlias, false);
    var onTagsWithAlias = function(event){
       try{
           console.log("onTagsWithAlias");    
           var result="result code:"+event.resultCode+" ";
           result+="tags:"+event.tags+" ";
           result+="alias:"+event.alias+" ";
           $("#tagAliasResult").html(result);
       }
       catch(exception){
           console.log(exception)
       }
   }

	 	 	
#####错误码定义


|Code|描述|详细解释|
|-|-|-|
|6001|	无效的设置，tag/alias 不应参数都为 null||	
|6002|	设置超时|	建议重试|
|6003|	alias| 字符串不合法	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6004|	alias超长。最多 40个字节	中文 UTF-8 是 3 个字节|
|6005|	某一个 tag 字符串不合法|	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。|
|6006|	某一个 tag 超长。|一个 tag 最多 40个字节	中文 UTF-8 是 3 个字节|
|6007|	tags 数量超出限制。最多 100个|	这是一台设备的限制。一个应用全局的标签数量无限制。|
|6008|	tag/alias 超出总长度限制。|总长度最多 1K 字节|
|6011|	10s内设置tag或alias大于3次|	短时间内操作过于频繁|


#### API - startLogPageView,stopLogPageView,beginLogPageView

本 API 用于“用户指定页面使用时长”的统计，并上报到服务器，在 Portal 上展示给开发者。页面统计集成正确，才能够获取正确的页面访问路径、访问深度（PV）的数据。

##### 接口定义
	JPushPlugin.prototype.startLogPageView = function(pageName)
	JPushPlugin.prototype.stopLogPageView = function(pageName)
	JPushPlugin.prototype.beginLogPageView = function(pageName,duration)

#####平台
iOS

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
	


#### API - setBadge,resetBadge

badge是iOS用来标记应用程序状态的一个数字，出现在程序图标右上角。 JPush封装badge功能，允许应用上传badge值至JPush服务器，由JPush后台帮助管理每个用户所对应的推送badge值，简化了设置推送badge的操作。

实际应用中，开发者可以直接对badge值做增减操作，无需自己维护用户与badge值之间的对应关系。

##### 接口定义

	JPushPlugin.prototype.setBadge = function(value)
	JPushPlugin.prototype.resetBadge = function()

`resetBadge相当于setBadge(0)`

##### 平台
iOS

##### 参数说明

value 取值范围：[0,99999]

##### 返回值

无，控制台会有log打印设置结果


#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setBadge(5);
		window.plugins.jPushPlugin.reSetBadge();
	}
#### API - setDebugModeFromIos

API 用于开启Debug模式，显示更多的日志信息

建议调试时开启这个选项，不调试的时候注释这句代码，这个函数setLogOFF是相反的一对

##### 接口定义

	JPushPlugin.prototype.setDebugModeFromIos = function()
	
##### 平台
iOS

#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setDebugModeFromIos();
	}

#### API - setLogOFF

API用来关闭日志信息（除了必要的错误信息）

不需要任何调试信息的时候，调用此API （发布时建议调用此API，用来屏蔽日志信息，节省性能消耗)

##### 平台
iOS

##### 接口定义 

	JPushPlugin.prototype.setLogOFF = function()

#####代码示例

	if(window.plugins.jPushPlugin.isPlatformIOS()){
		window.plugins.jPushPlugin.setLogOFF();
	}

#### API - receiveMessageIniOSCallback

用于iOS收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用

##### 接口定义

	JPushPlugin.prototype.receiveMessageIniOSCallback = function(data)


#####平台
iOS

#####参数说明

- data 	是一个js字符串使用如下代码解析，js具体key根据应用内消息来确定
	
		var bToObj = JSON.parse(data);
		
#####返回值
无

#### event - jpush.receiveNotification

当iOS收到的通知时会触发这个事件

##### 事件定义

	cordova.fireDocumentEvent('jpush.receiveNotification',json)

#####平台
iOS

#####使用说明

- 在你需要接收通知的的js文件中加入:
	           
		document.addEventListener("jpush.receiveNotification", onNotification, false);

- onOpenNotification需要这样写：
		
	    var onNotification = function(event){
          	try{
          		var alert   = event.alert;
			var extras  = event.extras;
	           console.log(alert);
	           //console.log(extras);
          	}
          	catch(exeption){
          		console.log(exception)
          	}
	   }
		
#####返回值
无


#### API - init

调用此API,用来
JPush SDK 提供的推送服务是默认开启的。


##### 接口定义

	JPushPlugin.prototype.init = function()

##### 参数说明
无
##### 返回值
无


#### API - setDebugMode

用于开启调试模式，可以查看集成JPush过程中的log，如果集成失败，可方便定位问题所在

##### 接口定义

	JPushPlugin.prototype.setDebugMode = function(mode)

##### 参数说明

- num 保存的条数

##### 返回值
无



#### API - stopPush


开发者App可以通过调用停止推送服务API来停止极光推送服务。当又需要使用极光推送服务时，则必须要调用恢复推送服务 API。

调用了本 API 后，JPush 推送服务完全被停止。具体表现为：

－ JPush Service 不在后台运行
－ 收不到推送消息
－ 不能通过 JPushInterface.init 恢复，需要调用resumePush恢复
－ 极光推送所有的其他 API 调用都无效



##### 接口定义 

	JPushPlugin.prototype.stopPush = function()
	
#####平台
android

	
##### 参数说明
无
##### 返回值
无

#### API - resumePush

恢复推送服务。
调用了此 API 后，极光推送完全恢复正常工作。

##### 接口定义

	JPushPlugin.prototype.resumePush = function()

##### 参数说明
无
##### 返回值
无

#### API - isPushStopped

用来检查 Push Service 是否已经被停止

##### 接口定义

	JPushPlugin.prototype.isPushStopped = function(callback)


#####平台
android

##### 参数说明

+ callback 回调函数，用来通知JPush的推送服务是否开启

		var onCallback = function(data) {
		    if(data>0){
		    	//开启
		    }else{
		    	//关闭
		    }
		}

##### 返回值
无



#### API - setBasicPushNotificationBuilder,setCustomPushNotificationBuilder

当用户需要定制默认的通知栏样式时，则可调用此方法。
极光 Push SDK 提供了 2 个用于定制通知栏样式的构建类：

- setBasicPushNotificationBuilder 
	- Basic 用于定制 Android Notification 里的 defaults / flags / icon 等基础样式（行为）
- setCustomPushNotificationBuilder
	- 继承 Basic 进一步让开发者定制 Notification Layout
	
如果不调用此方法定制，则极光Push SDK 默认的通知栏样式是：Android标准的通知栏提示。

#####平台
android

##### 接口定义 

	JPushPlugin.prototype.setBasicPushNotificationBuilder = function()
	JPushPlugin.prototype.setCustomPushNotificationBuilder = function()

#### 参数说明

无

##### 返回值

无

#### API - clearAllNotification

推送通知到客户端时，由 JPush SDK 展现通知到通知栏上。

此 API 提供清除通知的功能，包括：清除所有 JPush 展现的通知（不包括非 JPush SDK 展现的）


##### 接口定义

	JPushPlugin.prototype.clearAllNotification = function()

#####平台
android

##### 参数说明
无
##### 返回值
无

#### API - setLatestNotificationNum

通过极光推送，推送了很多通知到客户端时，如果用户不去处理，就会有很多保留在那里。

新版本 SDK (v1.3.0) 增加此功能，限制保留的通知条数。默认为保留最近 5 条通知。

开发者可通过调用此 API 来定义为不同的数量。



##### 接口定义

	JPushPlugin.prototype.setLatestNotificationNum = function(num)
	
	
#####平台
android

##### 参数说明

- num 保存的条数

##### 返回值
无


#### API - addLocalNotification,removeLocalNotification,clearLocalNotifications


本地通知API不依赖于网络，无网条件下依旧可以触发

本地通知与网络推送的通知是相互独立的，不受保留最近通知条数上限的限制

本地通知的定时时间是自发送时算起的，不受中间关机等操作的影响


三个接口的功能分别为：添加一个本地通知，删除一个本地通知，删除所有的本地通知

#####接口定义

	JPushPlugin.prototype.addLocalNotification = function(builderId,
											    content,
												title,
												notificaitonID,
												broadcastTime,
												extras)
	JPushPlugin.prototype.removeLocalNotification = function(notificationID)
	JPushPlugin.prototype.clearLocalNotifications = function()

#####平台
android

##### 参数说明

- builderId 设置本地通知样式
- content 设置本地通知的content
- title 设置本地通知的title
- notificaitonID 设置本地通知的ID
- broadcastTime 设置本地通知触发时间，为距离当前时间的数值，单位是毫秒
- extras 设置额外的数据信息extras为json字符串

##### 返回值说明

无


#### API - receiveMessageInAndroidCallback

用于android收到应用内消息的回调函数(请注意和通知的区别)，该函数不需要主动调用

##### 接口定义

	JPushPlugin.prototype.receiveMessageInAndroidCallback = function(data)

#####平台
android

##### 参数说明
- data 接收到的js字符串，包含的key:value请进入该函数体查看

##### 返回值
无


#### API - reportNotificationOpened

用于上报用户的通知栏被打开，或者用于上报用户自定义消息被展示等客户端需要统计的事件。


##### 接口定义

	JPushPlugin.prototype.reportNotificationOpened = function(msgID)
	
#####平台
android

##### 参数说明
- 无

##### 返回值
无

#### API - openNotificationInAndroidCallback

当点击android手机的通知栏进入应用程序时,会调用这个函数，这个函数不需要主动调用，是作为回调函数来用的


##### 接口定义

	JPushPlugin.prototype.openNotificationInAndroidCallback = function(data)
	
#####平台
android

##### 参数说明
- data js字符串

##### 返回值
无




