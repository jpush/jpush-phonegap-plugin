### iOS手动安装

下载 JPush PhoneGap 插件，并解压缩，标记插件目录为：`$JPUSH_PLUGIN_DIR`


1. 用 xcode 打开 iOS 工程 将 `$JPUSH_PLUGIN_DIR`/src/ios/Plugins/ 拖到 project 中  
2. 将 `$JPUSH_PLUGIN_DIR`/src/ios/lib/ 拖到 project 中  

4. 添加以下框架，打开 xcode，点击 project，选择(Target -> Build Phases -> Link Binary With Libraries)

		CFNetwork.framework
		CoreFoundation.framework
		CoreTelephony.framework
		SystemConfiguration.framework
		CoreGraphics.framework
		Foundation.framework
		UIKit.framework


5. 在你的工程中创建一个新的 Property List 文件

		并将其命名为 PushConfig.plist，填入 Portal 为你的应用提供的 APP_KEY 等参数

10. 在 AppDelegate.m 中包含头文件

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

7. 修改 phonegap config.xml 文件用来包含 Plugin/ 内的插件


		<feature name="JPushPlugin">
		    <param name="ios-package" value="JPushPlugin" />
		    <param name="onload" value="true" />
		</feature>


8. 复制 `$JPUSH_PLUGIN_DIR`/www/PushNotification.js 到工程的 www 目录下面  
9. 在需要使用插件处加入

		<script type="text/javascript" src="JPushPlugin.js"></script>
