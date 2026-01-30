
使用方法：修改需求里的内容，将需求和步骤内容作为指令让cursor进行执行。


需求：
1. 更新iOS JPush SDK 到 x.x.x 版本, JPush SDK 包的路径是：xxx
2. 更新Android JPush SDK 到 x.x.x 版本, JPush SDK 包的路径是：xxx
3. 将原生iOS、Android SDK 新增的方法，封装在插件中。
   原生SDK新增方法一：
   iOS:
   ```
   ```
   
   Android:
   ```
   ```
   
    统一封装为 方法名为 "" 的对外方法。
    

请按照以下步骤完成：

1. iOS 使用 CocoaPods 集成：在 plugin.xml 的 iOS 平台下修改 `<pod name="JPush" spec="x.x.x" />` 中的版本号（固定版本，如 6.0.0）即可。
2. Android 使用 Maven 集成：在 plugin.xml 的 Android 平台下修改 `<framework src="cn.jiguang.sdk:jpush:x.x.x" />` 中的版本号即可。
3. 封装新增的方法。(如果没有新增的方法就不用执行这一步)
4. 在 plugin.xml 中更新插件版本号，使用安卓 SDK 包的版本号。
5. 在 package.json 中更新插件版本号，使用安卓 SDK 包的版本号。



