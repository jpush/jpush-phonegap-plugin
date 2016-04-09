#Android 手动安装

下载 JPush PhoneGap 插件，并解压缩，标记插件目录为：`$JPUSH_PLUGIN_DIR`

1. 复制：$JPUSH_PLUGIN_DIR/src/android/*.java 到 cn/jpush/phonega/ 目录下(即：cn.jpush.phonegap 的包下)
2. 复制：$JPUSH_PLUGIN_DIR/src/android/armeabi/libjpush.so 到 lib/armeabi/
3. 复制：$JPUSH_PLUGIN_DIR/src/android/jpush-sdk-release2.0.6.jar 到 lib/
4. 复制：$JPUSH_PLUGIN_DIR/src/android/test_notification_layout.xml 到 res/layout/
5. 复制：$JPUSH_PLUGIN_DIR/src/android/jpush_notification_icon.png 到 res/drawable/
6. 复制：$JPUSH_PLUGIN_DIR/www/JPushPlugin.js 到 assets/www/plugins/cn.jpush.phonegap.JPushPlugin.www/
   和 platform_www/plugins/cn.jpush.phonegap.JPushPlugin/www/
   并在 JPushPlugin.js 文件的代码外添加:

        cordova.define("cn.jpush.phonegap.JPushPlugin.JPushPlugin", function(require, exports, module) {
            // 代码
        });

7. 修改 AndroidManifest.xml 在 manifest 节点下添加以下权限

		<!-- Required 一些系统要求的权限，如访问网络等-->
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

7. 修改 AndroidManifest.xml 在 manifest/application 节点下添加SDK相关组件声明

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

		<!-- Required  SDK 核心功能-->
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

		<!-- Required SDK 核心功能-->
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

				<!-- Required  用户注册 SDK 的intent -->
				<action android:name="cn.jpush.android.intent.UNREGISTRATION"/>
				<action android:name="cn.jpush.android.intent.MESSAGE_RECEIVED"/>

				<!-- Required  用户接收 SDK 消息的intent -->
				<action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED"/>

				<!-- Required  用户接收 SDK 通知栏信息的intent -->
				<action android:name="cn.jpush.android.intent.NOTIFICATION_OPENED"/>

				<!-- Required  用户打开自定义通知栏的intent -->
				<action android:name="cn.jpush.android.intent.ACTION_RICHPUSH_CALLBACK"/>

				<!-- Optional 用户接受 Rich Push Javascript 回调函数的intent -->
				<category android:name="$PACKAGE_NAME"/>
			</intent-filter>
		</receiver>

		<!-- Required SDK核心功能-->
		<receiver
			android:name="cn.jpush.android.service.AlarmReceiver"/>

		<!-- Required. Enable it you can get statistics data with channel -->
		<meta-data
	 		android:name="JPUSH_CHANNEL" android:value="developer-default"/>

		<meta-data
			android:name="JPUSH_APPKEY" android:value="299d0fee887820e7d90a68b2"/>
