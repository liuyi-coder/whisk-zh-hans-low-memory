# whisk-zh-hans-低内存（英文）

> ⚠️ 警告：这是非官方修改版，demo 未签名、未公证，仅测试用途，可能被 macOS 拦截；不要与官方 Whisk 同时安装；低内存优化未完成，不保证解决高内存占用。
> ⚠️ Warning: Unofficial modification. The demo is unsigned and not notarized, for testing only, and may be blocked by macOS. Do not install it alongside the official Whisk. The low-memory work is incomplete and does not guarantee lower memory usage.
> 🤖 本仓库内容由 AI 生成。 / This repository is AI-generated.

## 中文说明

- 基于上游 [`nathan-poncet/whisk`](https://github.com/nathan-poncet/whisk) `v1.0.3`，采用 GPL-3.0-or-later 许可。
- 非官方简体中文、英文、法文界面修改版，默认简体中文，可在设置中切换。
- 复制成功提示音（灵感来自 Paste）：成功记录新剪贴板内容后播放提示音，默认开启，可关闭，支持 18 种音效和试听。
- 低内存修改：来源应用图标缩至 32×32 后取色；缩略图缓存上限 32 MiB；只预热前 24 张卡片；关闭历史面板时清空缓存。
- 已知限制：SQLite 历史图片仍会全量读入内存；完整 XCTest 已由 GitHub CI 通过，实际 RSS 对比尚未完成。
- demo 下载见 [Releases](https://github.com/liuyi-coder/whisk-zh-hans-low-memory/releases)；仅作测试，不作为正式版本。

## English

- Based on upstream [`nathan-poncet/whisk`](https://github.com/nathan-poncet/whisk) `v1.0.3`, licensed under GPL-3.0-or-later.
- Unofficial Simplified Chinese, English and French UI modification; defaults to Simplified Chinese and can be changed in Settings.
- Copy success sound (inspired by Paste): plays after Whisk successfully records a new clipboard item; on by default, configurable, with 18 sounds and preview.
- Low-memory changes: source app icons are sampled at 32×32; thumbnail cache is capped at 32 MiB; only the first 24 cards are prewarmed; cache is cleared when the history panel closes.
- Known limits: SQLite history images are still loaded fully into memory; full XCTest has passed in GitHub CI, while real RSS comparisons are not complete.
- See [Releases](https://github.com/liuyi-coder/whisk-zh-hans-low-memory/releases) for the demo; it is for testing only and is not an official release.

## 功能

- 剪贴板历史、搜索、过滤、置顶、撤销、粘贴队列、拖放、预览。
- 简体中文、英文、法文界面，默认简体中文。
- 复制成功提示音（灵感来自 Paste），默认开启，可关闭，18 种音效，支持试听。
- 低内存修改：图标取色缩小到 32×32、缩略图缓存 32 MiB、前 24 张预热、关闭面板清空缓存。

## 源码结构

- `Sources/Whisk/Entities/`：`History`、`ClipboardItem`、`Payload`、`SourceApp` 等实体。
- `Sources/Whisk/UseCases/`：复制捕获、搜索过滤、删除、撤销、保留策略等纯逻辑。
- `Sources/Whisk/Adapters/`：`ClipboardController`、`HistoryPresenter`、`SQLiteHistoryStore`、`AppKitPasteboard` 等适配器。
- `Sources/Whisk/App/`：SwiftUI 视图、面板、菜单栏、热键和组合根。
- 本地化资源：`Sources/Whisk/Resources/zh-Hans.lproj/`、`en.lproj/`、`fr.lproj/`。
- 提示音资源：`Sources/Whisk/Resources/CopySounds/`。
- 低内存相关：`Sources/Whisk/App/Views/SourceAppStyle.swift`、`Sources/Whisk/App/Views/ItemCardView.swift`、`Sources/Whisk/App/PanelController.swift`。

## 构建

```sh
git clone https://github.com/liuyi-coder/whisk-zh-hans-low-memory.git
cd whisk-zh-hans-low-memory
WHISK_LOCALIZED=1 ./scripts/build-app.sh 1.0.3 native
```

`WHISK_LOCALIZED=1` 会构建本地化版本并关闭上游更新检查。生成的应用位于 `dist/Whisk.app`。

## Demo

Releases 中的 `Whisk-1.0.3-zh-hans-low-memory-demo.zip` 是未签名、未公证的 Ad Hoc 测试包，可能被 macOS 拦截。仅用于测试，不要作为正式版本分发。

## 许可证

- 上游 Whisk：GPL-3.0-or-later，版权归属 Nathan Poncet。
- 本仓库修改、简体中文资源和自制提示音：GPL-3.0-or-later。
- 小米提示音：来源见 `Sources/Whisk/Resources/CopySounds/Xiaomi/SOURCE.md`，按 GPL-3.0-or-later 授权。
- 详见 `LICENSE` 与 `LICENSE-EXCEPTION-APP-STORE.md`。
