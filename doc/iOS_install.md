## iOS 手动安装

> **不建议使用手动安装，请参照 README.md 进行自动安装。**



1. 下载 JPush PhoneGap Plugin 插件，并解压
2. 将 [/src/ios](/src/ios) 文件夹及内容在 xcode 中拖到你的工程里，并配置 [/src/ios/PushConfig.plist](/src/ios/PushConfig.plist) 中相应参数：

   Appkey：      应用标识 
   Channel：     渠道标识
   IsProduction：是否生产环境
   IsIDFA：      是否使用 IDFA 启动 sdk
3. 打开 xcode，点击工程目录中顶部的 工程，选择(Target -> Build Phases -> Link Binary With Libraries)，添加以下框架：

   CFNetwork.framework
   CoreFoundation.framework
   CoreTelephony.framework
   SystemConfiguration.framework
   CoreGraphics.framework
   Foundation.framework
   UIKit.framework
   AdSupport.framework
   libz.tbd(若存在 libz.dylib 则替换为 libz.tbd)
   UserNotifications.framework
   libresolv.tbd
4. 修改 phonegap config.xml 文件以添加 JPushPlugin 插件

```xml
<feature name="JPushPlugin">
    <param name="ios-package" value="JPushPlugin" />
    <param name="onload" value="true" />
</feature>
```
5. 将 [/www/JPushPlugin.js](/www/JPushPlugin.js) 在 xcode 中拖到工程的 www 目录下面  
6. 在需要使用插件处加入以下代码，并根据 [iOS API](/doc/iOS_API.md) 文档说明调用相应接口

```xml
<script type="text/javascript" src="JPushPlugin.js"></script>
```

