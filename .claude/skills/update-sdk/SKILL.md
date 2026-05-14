---
name: update-sdk
description: |
  更新 jpush-phonegap-plugin 插件的 JPush SDK 版本。自动拉取极光官网 Changelog，分析新增/移除/变更 API，更新 plugin.xml 中 Android（Gradle framework）和 iOS（CocoaPods podspec）版本引用，同步更新 Native 层（Java/ObjC）和 JS Bridge 层代码，展示变更摘要确认后发布到 npm。
  Use when: 更新 JPush SDK、升级推送 SDK 版本、jpush-phonegap-plugin 发布新版本、Cordova/PhoneGap 插件 SDK 更新。
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - WebFetch
---

你正在更新 **jpush-phonegap-plugin** 插件。

**用户参数：** $ARGUMENTS

---

## 第一步：解析参数

从 `$ARGUMENTS` 中提取版本号：
- `--android X.X.X` → Android JPush SDK 目标版本
- `--ios X.X.X` → iOS JPush SDK 目标版本

如果某端版本号缺失，先询问用户再继续。

---

## 第二步：安装依赖

```bash
pip3 install requests beautifulsoup4 -q 2>&1 | tail -1
```

---

## 第三步：拉取 SDK Changelog

```bash
python3 .claude/skills/update-sdk/scripts/changelog_fetcher.py --android <ANDROID_VERSION> --ios <IOS_VERSION>
```

读取 `.claude/skills/update-sdk/scripts/.changelog_cache.json` 获取 Changelog 内容。

---

## 第四步：AI 分析变更

分析 Changelog，整理：

> **注意**：Changelog 同时包含 JPush 和 JCore 的变更。只关注调用类以 `JPush` 开头的条目，忽略类名以 `JCore` 开头的内容。

1. 新增 API（Android + iOS 相同功能合并为统一插件 API）；仅单端有的 → **先检查另一端是否已有等价实现**（见下方说明），确认缺失才标注单端
2. 移除/废弃 API
3. 行为变更
4. 新插件版本号：始终升 patch（如 3.4.9 → 3.5.0，3.9.9 → 4.0.0）

> **跨平台等价检查**：当 Changelog 只在某一端出现新增 API 时，**不要直接标为单端 Only**。先读取另一端的 Native 文件（`src/android/JPushPlugin.java` 或 `src/ios/Plugins/JPushPlugin.m`）和 JS Bridge（`www/JPushPlugin.js`），搜索功能相同或名称相近的方法。如果另一端已有对应实现，则合并为统一 API；只有确认另一端完全没有等价功能时，才标注 Android Only / iOS Only。

---

## 第五步：更新版本号引用

plugin.xml 中同时包含 SDK 版本和插件版本：

```bash
python3 .claude/skills/update-sdk/scripts/plugin_updater.py \
  --android <ANDROID_VERSION> \
  --ios <IOS_VERSION> \
  --bump-patch \
  --changelog-summary "<ONE_LINE_SUMMARY>"
```

---

## 第六步：更新 Native 层代码

**编写代码前，先通过 WebFetch 查询官网 API 文档，确认新增方法的完整签名、参数类型和返回值：**
- Android 文档：`https://docs.jiguang.cn/jpush/client/Android/android_api`
- iOS 文档：`https://docs.jiguang.cn/jpush/client/iOS/ios_api`

在文档中搜索第四步识别出的新增方法名，确认签名后再编写下方代码。

**Android** — `src/android/JPushPlugin.java`
- 在 `execute()` 方法中添加新的 action 分支处理新 API
- 内部调用 `JPushInterface.newMethod()`

**iOS** — `src/ios/Plugins/JPushPlugin.m`
- 在对应的 action 处理中添加新方法
- 内部调用 JPush iOS SDK 对应方法

---

## 第七步：更新 JavaScript Bridge

**`www/JPushPlugin.js`**
- 添加新方法的 `cordova.exec()` 封装（统一 Android 和 iOS 入口）

---

## 第八步：展示变更摘要并请求确认

```
========== jpush-phonegap-plugin 更新摘要 ==========
Android JPush SDK:  旧版本 → 新版本
iOS JPush SDK:      旧版本 → 新版本
插件版本（plugin.xml）：旧版本 → 新版本

新增 API：...
修改的文件：plugin.xml, src/android/JPushPlugin.java, src/ios/Plugins/JPushPlugin.m, www/JPushPlugin.js, CHANGELOG.md
====================================================

确认以上变更并发布到 npm? [y/N]
```

---

## 第九步：发布（确认后执行）

```bash
python3 .claude/skills/update-sdk/scripts/publisher.py
```
