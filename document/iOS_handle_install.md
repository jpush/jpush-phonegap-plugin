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
