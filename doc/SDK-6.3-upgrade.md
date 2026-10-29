# Cordova 6.3.0 / Core 5.6.0 升级说明

JPush Android/iOS6.2.0→6.3.0、JCore5.5.0→5.6.0。主插件要求配套 cordova-plugin-jcore >=5.6.0 <6.0.0，升级时请同时检查两包版本。

| API/载荷 | 旧版与目标差分 | 本版契约 |
| --- | --- | --- |
| Android requestSubscribeChannels(Activity,List) | 本次真正新增；旧requestSubscribeChannel及2012保留 | 新方法channels:string[1..3]唯一非空，success/error回调；需前台有焦点Activity，success只表示派发，最终jpush.onCommandResult command=2013；commandData/channels递归保留数组/对象/布尔/数/null/原生JSON字符串，不影响旧commandExtra和2012 |
| Android UPS turnOff/turnOn | 目标区间能力/语义更新，旧SDK已有但插件未桥 | 新turnOffPush(success,error)返回{code}；turnOnPush返回Android{code,dispatched:true}/iOS{dispatched:true}。非0原生业务码经success保留，桥接错误经error，不把恢复派发当连接成功 |
| Android initCrashHandler/stopCrashHandler | 公开相关旧缺口补齐 | 成对显式方法，success表示调用完成；不在初始化中启用，不人为崩溃 |
| Android VoIP voipSupportStatus | 本次公开新字段 | 旧jpush.receiveVoipMessage事件新增整数原样保留，messageId字符串，不猜bool，不日志VoIP载荷 |
| iOS turnOffPush/turnOnPush | 6.2.2起新增，6.2.0基线缺 | 同上回调契约，不改变旧stopPush/resumePush的APNs语义 |
| iOS setLiveActivityTokenReportEnabled | 本次新增 | 严格true/false，显式开关；仅诊断Token链路埋点，客户端/服务端任一开启可能上报，不控制Token绑定解绑，不自动启用 |
| iOS registerLiveActivity pushToken/pushToStartToken | 6.2.0已存在的相关旧缺口 | registerLiveActivityPushToken({activityId,token,sequence},success,error) / registerLiveActivityPushToStartToken({activityAttributes,token,sequence},success,error)。token偶数长hex或null解绑；seq为32位整数；iOS16.1/17.2保护。成功返回{code,activityId,token:hex或null,sequence}，原生非0业务码保留；参数/平台/系统/异常走error |
| JCore Android/iOS公开门面 | 5.5→5.6无新增业务门面 | 仅升级依赖，不将内部SPI/协议暴露 |

新接口非支持平台均error('UNSUPPORTED_PLATFORM')；旧接口签名及事件保持。每调用独立Callback，重复原生回调只完成一次，Android reset/destroy与iOS reset/dispose释放待回调避免迟到污染。现有旧getPushStatus单回调历史结构未在本次扩展重构；新UPS不复用该存储。

原生权限/Manifest与最低平台声明保持；实际部署系统需同时满足所用 Cordova 平台及原生 SDK 的要求。本文 JS API 适用于本 Cordova 插件；独立 Ionic wrapper 具有独立版本，使用时应核对其实际提供的接口。

```js
JPush.requestSubscribeChannels(['your_channel'], function () {
  // 仅请求派发成功，监听 jpush.onCommandResult command===2013
}, function (code) {});
JPush.turnOnPush(function (result) { /* iOS仅dispatched，Android另有code */ }, function (code) {});
// iOS业务在取得LiveActivity token后显式调用；null解绑，勿记录Token。
JPush.registerLiveActivityPushToken({activityId:'activity', token:null, sequence:1}, function(result){}, function(code){});
```

回退需要主/Core原版本整组与依赖一起还原，不混用旧Core。升级及回退时请同时满足两包的依赖约束。

## Cordova构建兼容

为支持纯 Objective-C 宿主使用 SDK 所需的 Swift 兼容库，本插件 after_prepare 向 Cordova 原生 include 的 build-extras.xcconfig 添加可识别块：保留宿主（含条件）LIBRARY_SEARCH_PATHS和inherited，附TOOLCHAIN_DIR/SDKROOT平台Swift路径、标准Swift库嵌入YES。重复prepare幂等，卸载仅移除自己的标记块并恢复原文件，不修改其它宿主配置、不提高部署目标、不增加假Swift源。

两插件的 podspec 使用空 config 结构以兼容 cordova-ios 7 的卸载流程，不增加 Pod source。卸载只移除本插件写入的配置，保留宿主自有内容。
