### IOS手工安装

下载jpush phonegap插件，并解压缩，标记插件目录为：`$JPUSH_PLUGIN_DIR`


1. 用xcode打开iOS工程 将`$JPUSH_PLUGIN_DIR`/src/ios/Plugins/拖到project中  
2. 将`$JPUSH_PLUGIN_DIR`/src/ios/lib/拖到project中  

4. 添加以下框架，打开xocode，点击project，选择(Target -> Build Phases -> Link Binary With Libraries)

		CFNetwork.framework
		CoreFoundation.framework
		CoreTelephony.framework
		SystemConfiguration.framework
		CoreGraphics.framework
		Foundation.framework
		UIKit.framework


5. 在你的工程中创建一个新的Property List文件

		并将其命名为PushConfig.plist，填入Portal为你的应用提供的APP_KEY等参数

10. 在AppDelegate.m中包含头文件

		#import "APService.h"
	    #import "JPushPlugin.h"

6. 调用代码,监听系统事件，相应地调用 JPush SDK 提供的 API 来实现功能

		- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		   //原内容保持不变
		   //Required add 
		   [JPushPlugin setLaunchOptions:launchOptions];
		    return YES;
		}
		- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken   {
		    //原内容保持不变
		    // Required add
		    [APService registerDeviceToken:deviceToken];
		}
		- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
		    //原内容保持不变
		    // Required
		    [APService handleRemoteNotification:userInfo];
    		[[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification
                                                               object:userInfo];
		}

7. 修改phonegap config.xml文件用来包含Plugin/内的插件


		<feature name="JPushPlugin">
		    <param name="ios-package" value="JPushPlugin" />
		    <param name="onload" value="true" />
		</feature>


8. 复制`$JPUSH_PLUGIN_DIR`/www/PushNotification.js到工程的www目录下面  
9. 在需要使用插件处加入

		<script type="text/javascript" src="JPushPlugin.js"></script>
