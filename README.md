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

## Install

- 通过 Cordova Plugins 安装，要求 Cordova CLI 5.0+：

  	    cordova plugin add jpush-phonegap-plugin --variable API_KEY=your_jpush_appkey

- 或直接通过 url 安装：

        cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git --variable API_KEY=your_jpush_appkey  

- 或下载到本地安装：

        cordova plugin add Your_Plugin_Path  --variable API_KEY=your_jpush_appkey


## Usage
### API
- [公共 API](/doc/Common_detail_api.md)
- [iOS API](/doc/iOS_API.md)
- [Android API](/doc/Android_detail_api.md)

### Demo
插件项目中包含一个简单的 Demo。若想参考，可以在 */example* 文件夹内找到并拷贝以下文件:

	example/index.html -> www/index.html
	example/css/* -> www/css
	example/js/* -> www/js

### 关于 PhoneGap build 云服务
该项目基于 Cordova 实现，目前无法使用 PhoneGap build 云服务进行打包，建议使用本地环境进行打包。

## FAQ
> 如果遇到了疑问，请优先参考 Demo 和 API 文档。若还无法解决，可访问[极光社区](http://community.jiguang.cn/)或 [Issues](https://github.com/jpush/jpush-phonegap-plugin/issues) 提问。

### Android
#### 在 Eclipse 中 import 工程之后出现：*Type CallbackContext cannot be resolved to a type*。
右键单击工程名 -> Build Path -> Config Build Path -> Projects -> 选中工程名称 -> CordovaLib -> 点击 add。

### iOS
#### PushConfig.plist 文件中的字段都是什么意思？
- APP_KEY：应用标识。
- CHANNEL：渠道标识。
- IsProduction：是否生产环境。
- IsIDFA：是否使用 IDFA 启动 SDK。

#### 刚集成完插件收不到推送怎么办？
请首先按照正确方式再次配置证书、描述文件，具体可参考 [iOS 证书设置指南](http://docs.jpush.io/client/ios_tutorials/#ios_1)。

#### iOS 集成插件白屏、或无法启动插件、或打包报错无法找到需要引入的文件怎么办?
按照以下步骤逐个尝试：

- 升级至 Xcode 8
- 先删除插件、再重装插件
- 先使用 `cordova platform add ios`，后使用 `cordova plugin add`

## Support
- QQ 群：413602425
- [JPush 官网文档](http://docs.jpush.io/)
- [极光社区](http://community.jiguang.cn/)

## Contribute
Please contribute! [Look at the issues](https://github.com/jpush/jpush-phonegap-plugin/issues).

## License
MIT © [JiGuang](/license)
