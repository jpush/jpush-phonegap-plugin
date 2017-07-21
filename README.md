# JPush PhoneGap / Cordova Plugin

[![Build Status](https://travis-ci.org/jpush/jpush-phonegap-plugin.svg?branch=master)](https://travis-ci.org/jpush/jpush-phonegap-plugin)
[![release](https://img.shields.io/badge/release-3.2.3-blue.svg)](https://github.com/jpush/jpush-phonegap-plugin/releases)
[![platforms](https://img.shields.io/badge/platforms-iOS%7CAndroid-lightgrey.svg)](https://github.com/jpush/jpush-phonegap-plugin)
[![weibo](https://img.shields.io/badge/weibo-JPush-blue.svg)](http://weibo.com/jpush?refer_flag=1001030101_&is_all=1)

极光官方支持的 cordova 推送插件。

- 如需要 IM 功能的插件，可关注 [jmessage-phonegap-plugin](https://github.com/jpush/jmessage-phonegap-plugin)
- 如需要短信验证码功能插件，可关注 [cordova-plugin-jsms](https://github.com/jpush/cordova-plugin-jsms)
- 如需要统计分析功能插件，可关注 [cordova-plugin-janalytics](https://github.com/jpush/cordova-plugin-janalytics)

## Install

- 通过 Cordova Plugins 安装，要求 Cordova CLI 5.0+：

  ```shell
  cordova plugin add jpush-phonegap-plugin --variable APP_KEY=your_jpush_appkey
  ```

- 或直接通过 url 安装：

  ```shell
  cordova plugin add https://github.com/jpush/jpush-phonegap-plugin.git --variable APP_KEY=your_jpush_appkey
  ```

- 或下载到本地安装：

  ```shell
  cordova plugin add Your_Plugin_Path  --variable APP_KEY=your_jpush_appkey
  ```

> 在使用 Xcode 8 调试 iOS 项目时，需要先在项目配置界面的 Capabilities 中打开 Push Notifications 开关。

## Usage

### API

- [Common](/doc/Common_detail_api.md)
- [iOS](/doc/iOS_API.md)
- [Android](/doc/Android_detail_api.md)

### Demo

插件项目中包含一个简单的 Demo。若想参考，可以在 */example* 文件夹内找到并拷贝以下文件:

    example/index.html -> www/index.html
    example/css/* -> www/css
    example/js/* -> www/js

### 关于 PhoneGap build 云服务

该项目基于 Cordova 实现，目前无法使用 PhoneGap build 云服务进行打包，建议使用本地环境进行打包。

## FAQ

> 如果遇到了疑问，请优先参考 Demo 和 API 文档。若还无法解决，可到 [Issues](https://github.com/jpush/jpush-phonegap-plugin/issues) 提问。

### Android

#### 在 Eclipse 中 import 工程之后出现：*Type CallbackContext cannot be resolved to a type*

右键单击工程名 -> Build Path -> Config Build Path -> Projects -> 选中工程名称 -> CordovaLib -> 点击 add。

#### 如何自定义通知声音？

Android 因为各 Rom 的高度定制化，不像 iOS 一样能有一个统一的管理，如果在 Android 中想自定义通知铃声，推荐通过 JPush 推送自定义
消息，之后在 `jpush.receiveMessage` 事件监听中通过 [Cordova Local-Notification Plugin](https://github.com/katzer/cordova-plugin-local-notifications) 触发通知，再配合 [Cordova Background Plugin](https://github.com/katzer/cordova-plugin-background-mode) 插件保证应用的后台运行。

#### 关闭 App 后收不到通知

Android 的推送通过长连接的方式实现，只有在连接保持的情况下才能收到通知。而有的第三方 ROM 会限制一般应用服务的自启动，也就是
在退出应用后，应用的所有服务均被杀死，且无法自启动，所以就会收不到通知。

目前 JPush 是做了应用互相拉起机制的，也就是当用户打开其他集成了 JPush 的应用时，你的应用也能同时收到推送消息。

如果你的应用希望随时都能收到推送，官方推荐是通过文案的方式引导用户在设置中允许你的应用能够自启动，常见机型的设置方法可以参考[这里](https://docs.jiguang.cn/jpush/client/Android/android_faq/#_2)。

或者自己实现应用保活，网上有很多相关文章（不推荐）。

> 为什么 QQ、微信之类的应用退出后还能够收到通知？因为这些大厂应用，手机厂商默认都会加入自启动白名单中，也不会在应用退出后杀死它们的相关服务。
> 如果你多加留意，就会发现非大厂的应用如果你一段时间不用都是收不到推送的。

### iOS

#### 打包时遇到 i386 打包失败怎么办？

```shell
cordova platform update ios
```

#### ionic 2 如何调用 API？

[issue 179](https://github.com/jpush/jpush-phonegap-plugin/issues/179)

#### PushConfig.plist 文件中的字段都是什么意思？

- Appkey：应用标识。
- Channel：渠道标识。
- IsProduction：是否生产环境。
- IsIDFA：是否使用 IDFA 启动 SDK。

#### 刚集成完插件收不到推送怎么办？

请首先按照正确方式再次配置证书、描述文件，具体可参考 [iOS 证书设置指南](https://docs.jiguang.cn/jpush/client/iOS/ios_cer_guide/)。

#### iOS 集成插件白屏、或无法启动插件、或打包报错无法找到需要引入的文件怎么办？

按照以下步骤逐个尝试：

- 升级至最新版本 Xcode
- 删除插件、再重装插件（先使用 `cordova platform add ios`，后使用 `cordova plugin add`）

## Support

- QQ 群：413602425 / 524248013
- [JPush 官网文档](https://docs.jiguang.cn/jpush/guideline/intro/)
- [极光社区](http://community.jiguang.cn/)

## Contribute

Please contribute! [Look at the issues](https://github.com/jpush/jpush-phonegap-plugin/issues).

## License

MIT © [JiGuang](/license)
