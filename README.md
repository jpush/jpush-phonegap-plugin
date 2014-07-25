## JPush PhoneGap Plugin ##
###创建项目###
1. cordova create 文件夹名字 包名 应用名字

		cordova create Myproj com.myproj.jpush MyTestProj
		
2. 添加平台

		cd Myproj :不进行这一步可能会出现[RangeError:Maximum call stack size exceeded]
		cordova platform add android  


### Android使用PhoneGap/Cordova CLI自动安装

1. 使用 phonegap 或者 cordova cli 添加插件(建议在git客户端下使用，在windows 的cmd界面下 该命令提示git command line tool 不可用): 

		cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git


2. 修改[your project]/plugins/android.json生成脚本的JPUSH_APPKEY字段

		"xml": "<meta-data android:name=\"JPUSH_APPKEY\" android:value=\"your appkey in JPush Portal\" />",

3. 执行 cordova build android 使修改的`JPUSH_APPKEY`写入AndroidManifest.xml文件

> 温馨提示：如果使用eclipse来生成安装包，步骤2与步骤3可省略。直接在AndroidManifest.xml文件中修改JPUSH_APPKEY即可


###IOS使用PhoneGap/Cordova CLI自动安装

1. 使用PhoneGap/Cordova CLI命令安装

		cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git
		cordova build ios

2. 修改Resources/PushConfig.plist文件

在APP_KEY和CHANNLE字段 分别添加您的appkey和channle

3. 添加监听系统事件，相应地调用 JPush SDK 提供的 API 来实现功能


		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
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
		    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
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
