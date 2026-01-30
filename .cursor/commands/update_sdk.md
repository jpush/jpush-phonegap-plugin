# 更新 SDK

根据**输入的需要更新的 SDK 版本号**，同时更新本插件的 **iOS** 与 **Android** 依赖。本插件 Android 使用 Maven 集成、iOS 使用 CocoaPods 集成，无需下载或替换本地 SDK 包，只需在 `plugin.xml` 中修改两端的依赖版本号。

## 输入

执行本命令时请提供**目标 SDK 版本号**（如 `5.9.1`、`6.0.0`）。该版本号将用于：
- **iOS**：CocoaPods 的 JPush pod 版本（`plugin.xml` 中的 `spec`）
- **Android**：Maven 的 `cn.jiguang.sdk:jpush` 版本（`plugin.xml` 中的 `framework src`）

若 iOS 与 Android 官方发布的版本号不一致，请分别说明「iOS 目标版本」与「Android 目标版本」。

## 更新步骤

### 1. 更新 iOS SDK 版本（CocoaPods）

根据输入的版本号，在 `plugin.xml` 的 iOS 平台下修改 `<pod name="JPush" spec="..." />` 中的版本号。

**位置**：约第 51–55 行，`<podspec><pods>` 内。

**示例**：
```xml
<!-- 固定版本，如 6.0.0、6.0.1 -->
<pod name="JPush" spec="6.0.0" />
```

**说明**：CocoaPods 上 JPush 官方 pod 的版本以 [CocoaPods JPush](https://cocoapods.org/pods/jpush) 为准。修改后执行 `cordova build ios` 或进入 `platforms/ios` 执行 `pod install` 即可拉取对应版本。

### 2. 更新 Android SDK 版本（Maven）

根据输入的版本号，在 `plugin.xml` 的 Android 平台下修改 `<framework src="cn.jiguang.sdk:jpush:x.x.x" />` 中的版本号。

**位置**：约第 252–253 行。

**示例**：
```xml
<!-- 更新为 5.9.1 -->
<framework src="cn.jiguang.sdk:jpush:5.9.1" />
```

**说明**：依赖从 Maven Central 拉取，无需替换本地 jar。修改后执行 `cordova build android` 即可使用新版本。

### 3. 查找 SDK 新增 API

**⚠️ 重要：必须逐项查看更新日志，不要因为看到「更新各厂商 SDK」等描述就跳过新增 API 的检查。**

执行本步时按文末「文档内容获取方式」获取下方更新日志页面的内容，逐条阅读，不要仅依赖网页搜索。

#### Android SDK
- 访问 [极光推送 Android SDK 更新日志](https://docs.jiguang.cn/jpush/jpush_changelog/updates_Android) 查找目标版本的新增对外 API。
- **检查方法**：
  1. 找到目标版本（如 5.9.0）的更新内容。
  2. **逐条阅读**每一条，不要跳过。
  3. 重点看包含「新增」「新增接口」「新增 API」「新增方法」或 Java 方法签名的条目。
  4. 对每个疑似新增 API，记录：方法名、完整方法签名、功能说明。
- 在 [Android SDK API 文档](https://docs.jiguang.cn/jpush/client/Android/android_api) 中确认用法、参数和示例。

#### iOS SDK
- 访问 [极光推送 iOS SDK 更新说明](https://docs.jiguang.cn/jpush/jpush_changelog/updates_iOS) 查找目标版本的新增对外 API。
- **检查方法**：
  1. 找到目标版本的更新内容。
  2. **逐条阅读**每一条。
  3. 重点看包含「新增」「新增接口」「新增 API」或 Objective-C 方法签名的条目。
  4. 对每个疑似新增 API，记录：方法名、完整方法签名、功能说明。
- 在 [iOS SDK API 文档](https://docs.jiguang.cn/jpush/client/iOS/ios_api) 中确认用法、参数和示例。

**检查清单**（完成后勾选）：
- [ ] 已找到目标版本的更新日志
- [ ] 已逐条阅读所有更新内容（含次要更新）
- [ ] 已识别所有含「新增」「API」「接口」「方法」等的条目
- [ ] 已记录所有新增 API 的方法名和签名
- [ ] 已在对应平台 API 文档中确认每个新增 API 的用法
- [ ] 已区分「需在插件中封装的对外 API」与「仅内部实现、无需封装」的更新

**常见误区**：
- ❌ 看到「更新各厂商 SDK」就认为没有新增 API → ✅ 仍要逐条检查
- ❌ 只扫一眼主要更新 → ✅ 必须逐条检查
- ❌ 靠搜索判断有没有新增 API → ✅ 以官方更新日志为准
- ❌ 文档有缺字/错字时直接忽略 → ✅ 需到官方文档核实

### 4. 封装新增 API（如有）

**⚠️ 若无新增 API，需明确写「经检查，该版本无新增对外 API」，再跳过本步。**

若有新增 API，需在插件中封装：
- 在 `www/JPushPlugin.js` 中增加 JavaScript 接口
- 在 `src/android/JPushPlugin.java` 中实现 Android 逻辑
- 在 `src/ios/Plugins/JPushPlugin.m` 或 `AppDelegate+JPush.m` 中实现 iOS 逻辑

**封装原则**：
- Android 与 iOS 为同一功能时，封装为一个插件方法
- 不同功能分别封装
- **直接调用 SDK API，不要用反射**
- 若无新增 API，**必须写明「已检查并确认无新增 API」后跳过**

**封装步骤**：
1. 确认 API 的完整签名与参数类型
2. 确认调用时机（是否需在 init 之前调用）
3. 在对应平台实现
4. 在 JS 层增加方法，风格与现有 API 一致
5. 补充必要的错误处理与日志

### 5. 更新 API 文档

若新增了插件方法，需更新文档：
- `doc/Common_detail_api.md`：通用或跨平台方法
- `doc/Android_detail_api.md`：仅 Android 方法
- `doc/iOS_API.md`：仅 iOS 方法

若无新增方法，跳过此步。

### 6. 在 example/index.html 中添加示例（若有新增 API）

**若有新增插件方法**，需在示例工程中增加可操作示例，便于开发者验证与参考：

- 在 `example/index.html` 中为每个新增 API 增加：
  1. **按钮**：在合适位置的 `<div data-role="fieldcontain">` 中增加 `<input type="button" id="xxx" value="Xxx" />`（id 与 API 含义对应）。
  2. **点击逻辑**：在 `initiateUI` 内用 `$("#xxx").click(...)` 调用 `window.JPush.新方法(...)`，在回调中用 `alert` 或 `$("#某结果区").html(...)` 展示结果。
  3. 若有结果展示，可复用已有结果区域或新增 `<label id="xxxResult">` 等。

风格与现有示例保持一致（如 setTags、getAlias、setMobileNumber 等），便于用户对照文档在真机/模拟器上点击验证。

若无新增方法，跳过此步。

### 7. 更新插件版本号

**⚠️ 重要：`plugin.xml` 与 `package.json` 中的版本号需一致。**

本插件版本号与 **Android SDK 版本号** 对齐（如 SDK 5.9.0 → 插件 5.9.0）。

- 在 `plugin.xml` 根节点 `version` 中更新版本号（约第 5 行）
- 在 `package.json` 的 `version` 中更新为相同版本号

**示例**：
- 当前插件版本：5.9.0，本次升级 Android SDK 到 5.9.1 → 插件版本改为 **5.9.1**
- 若仅升级 CocoaPods 侧 JPush 版本、且希望插件版本与 Android 一致，可继续使用当前 Android SDK 版本作为插件版本

## 文档内容获取方式

文档中的链接（极光更新日志、API 文档、CocoaPods 等）需要获取内容时：用 **curl 拉取对应 URL**，在返回的 HTML 里用 **grep 或搜索** 定位所需段落（极光页面为服务端渲染，内容均在 HTML 中，无需执行 JS）。

## 注意事项

- **必须逐条检查更新日志，避免遗漏新增 API**
- 确保 Android（Maven）与 iOS（CocoaPods）使用的 SDK 版本符合预期
- 新增 API 的封装风格需与现有 API 一致
- 更新后建议做一次完整构建与功能验证
- **若更新日志有缺字、错字，以极光官方文档为准**
- **`plugin.xml` 与 `package.json` 的版本号必须一致**
- 本插件不包含本地 SDK 包，所有依赖通过 Maven（Android）和 CocoaPods（iOS）拉取
