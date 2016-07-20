# JPush PhoneGap / Cordova Plugin

[![Build Status](https://travis-ci.org/jpush/jpush-phonegap-plugin.svg?branch=master)](https://travis-ci.org/jpush/jpush-phonegap-plugin)
[![QQ Group](https://img.shields.io/badge/QQ%20Group-413602425-red.svg)]()
[![release](https://img.shields.io/badge/release-2.2.4-blue.svg)](https://github.com/jpush/jpush-phonegap-plugin/releases)
[![platforms](https://img.shields.io/badge/platforms-iOS%7CAndroid-lightgrey.svg)](https://github.com/jpush/jpush-phonegap-plugin)
[![weibo](https://img.shields.io/badge/weibo-JPush-blue.svg)](http://weibo.com/jpush?refer_flag=1001030101_&is_all=1)

支持 iOS, Android 的 Cordova 推送插件。
> 如需要 IM 功能的插件，可关注 [JMessage PhoneGap Plugin](https://github.com/jpush/jmessage-phonegap-plugin)。

> 如需要短信验证码功能的插件，可关注 [JSMS Cordova Plugin](https://github.com/jpush/cordova-plugin-jsms)。

> QQ 交流群：413602425。

## 集成步骤

- 先安装 cordova-plugin-device 插件：

        cordova plugin add cordova-plugin-device

- 安装本插件
  - 通过 Cordova Plugins 安装，要求 Cordova CLI 5.0+：

    	   cordova plugin add jpush-phonegap-plugin --variable API_KEY=your_jpush_appkey

  - 或者直接通过 url 安装：

          cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git --variable API_KEY=your_jpush_appkey  

  - 或下载到本地安装：

          cordova plugin add Your_Plugin_Path  --variable API_KEY=your_jpush_appkey


## Demo
插件项目中包含一个简单的 Demo。若想参考，可以在 */example* 文件夹内找到并拷贝以下文件:

	src/example/index.html -> www/index.html
	src/example/css/* -> www/css
	src/example/js/* -> www/js

## 关于 PhoneGap build 云服务

该项目基于 Cordova 实现，目前无法使用 PhoneGap build 云服务进行打包，建议使用本地环境进行打包。

## API 说明

插件的 API 在 JPushPlugin.js 文件中，该文件的具体位置如下：
### Android
	[Project]/assets/www/plugins/cn.jpush.phonegap.JPushPlugin/www

### iOS
	[Project]/www/plugins/cn.jpush.phonegap.JPushPlugin/www

### 具体的 API 请参考：

- [公共 API](/doc/Common_detail_api.md)。

- [iOS API](/doc/iOS_API.md)。

- [Android API](/doc/Android_detail_api.md)。


## 常见问题

若要使用 CLI 来编译项目，注意应使用 cordova compile 而不是 cordova build 命令，因为如果修改了插件安装时默认写入到 AndroidManifest.xml
中的代码，cordova build 可能会导致对 AndroidManifest.xml 的修改。
Cordova CLI 的具体用法可参考 [Cordova CLI 官方文档](https://cordova.apache.org/docs/en/latest/reference/cordova-cli/index.html)。

### Android

- Eclipse 中 import PhoneGap 工程之后出现：*Type CallbackContext cannot be resolved to a type*。

  解决方案：Eclipse 中右键单击工程名，Build Path -> Config Build Path -> Projects -> 选中工程名称 -> CordovaLib -> 点击 add。

### iOS

- 设置 PushConfig.plist：
	- APP_KEY：应用标识。
	- CHANNEL：渠道标识。
	- IsProduction：是否生产环境。
	- IsIDFA：是否使用 IDFA 启动 SDK。


- 收不到推送：
	请首先按照正确方式再次配置证书、描述文件，具体可参考 [iOS 证书设置指南](http://docs.jpush.io/client/ios_tutorials/#ios_1)。


## 更多
- QQ 群：413602425；
- [JPush 官网文档](http://docs.jpush.io/)；
- 如有问题可访问[极光社区](http://community.jiguang.cn/)。
