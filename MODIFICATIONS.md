# 修改说明 / Modifications

> ⚠️ 警告：这是非官方修改版，demo 未签名、未公证，仅测试用途，可能被 macOS 拦截；不要与官方 Whisk 同时安装；低内存优化未完成，不保证解决高内存占用。
> ⚠️ Warning: Unofficial modification. The demo is unsigned and not notarized, for testing only, and may be blocked by macOS. Do not install it alongside the official Whisk. The low-memory work is incomplete and does not guarantee lower memory usage.
> 🤖 本仓库内容由 AI 生成。 / This repository is AI-generated.

## 中文说明

### 基线

- 上游仓库：`https://github.com/nathan-poncet/whisk`
- 上游版本：`v1.0.3`，提交 `1ebcee1`
- 本仓库分支：`zh-hans`
- 许可证：GPL-3.0-or-later

### 主要修改

1. 简体中文、英文、法文界面
   - 新增 `Sources/Whisk/Resources/zh-Hans.lproj/`。
   - 新增 `Sources/Whisk/Adapters/Presenters/Localization.swift`，默认简体中文，可在设置中切换 English、Français、跟随系统。
   - 新增 `scripts/check-localization-catalogs.py`，检查三种语言的键和格式占位符一致。

2. 复制成功提示音（灵感来自 Paste）
   - 新增 `Sources/Whisk/App/CopySoundFeedback.swift`。
   - 新增 `Sources/Whisk/Resources/CopySounds/`，包含 14 个自制短音效和 3 个小米自然音效。
   - `ClipboardController` 只在成功记录新剪贴板内容后触发；暂停记录、来源排除、权限拒绝、Whisk 自身写回时不播放。
   - 设置中默认开启，可关闭，支持 18 种音效和试听。

3. 低内存修改
   - `Sources/Whisk/App/Views/SourceAppStyle.swift`：来源应用图标先缩至 32×32 再取色，避免完整图标位图长期驻留。
   - `Sources/Whisk/App/Views/ItemCardView.swift`：缩略图缓存上限 32 MiB，只预热前 24 张卡片。
   - `Sources/Whisk/App/PanelController.swift`：关闭历史面板时清空缓存。
   - `Sources/Whisk/Adapters/Gateways/SQLiteHistoryStore.swift`：历史图片仍会全量读入内存，按需读取尚未完成。

### 已知问题

- 完整 XCTest 尚未在当前机器完成；GitHub CI 会在推送后运行。
- 低内存修改尚未做实际 RSS 对比，不能承诺解决约 700 MB 常驻占用。
- demo 为 Ad Hoc 签名、未公证，macOS 可能拦截。
- Bundle ID 仍为 `com.nathanponcet.whisk`，不要与官方 Whisk 同时安装。

### 源码结构

- `Entities/`：`History`、`ClipboardItem`、`Payload`、`SourceApp` 等。
- `UseCases/`：复制捕获、搜索过滤、删除、撤销、保留策略等纯逻辑。
- `Adapters/`：`ClipboardController`、`HistoryPresenter`、`SQLiteHistoryStore`、`AppKitPasteboard` 等。
- `App/`：SwiftUI 视图、面板、菜单栏、热键和组合根。

## English

### Baseline

- Upstream: `https://github.com/nathan-poncet/whisk`
- Upstream release: `v1.0.3`, commit `1ebcee1`
- Branch: `zh-hans`
- License: GPL-3.0-or-later

### Main changes

1. Simplified Chinese, English and French UI
   - Added `Sources/Whisk/Resources/zh-Hans.lproj/`.
   - Added `Sources/Whisk/Adapters/Presenters/Localization.swift`; defaults to Simplified Chinese and supports English, French and Follow System.
   - Added `scripts/check-localization-catalogs.py` to verify keys and format placeholders across all three languages.

2. Copy success sound (inspired by Paste)
   - Added `Sources/Whisk/App/CopySoundFeedback.swift`.
   - Added `Sources/Whisk/Resources/CopySounds/` with 14 original short sounds and 3 Xiaomi nature sounds.
   - `ClipboardController` triggers the sound only after a new clipboard item is successfully recorded; it stays silent when recording is paused, the source is excluded, access is denied, or Whisk itself wrote to the clipboard.
   - The setting is on by default, can be turned off, and offers 18 sounds with preview.

3. Low-memory changes
   - `Sources/Whisk/App/Views/SourceAppStyle.swift`: source app icons are sampled at 32×32 before color extraction.
   - `Sources/Whisk/App/Views/ItemCardView.swift`: thumbnail cache is capped at 32 MiB and only the first 24 cards are prewarmed.
   - `Sources/Whisk/App/PanelController.swift`: cache is cleared when the history panel closes.
   - `Sources/Whisk/Adapters/Gateways/SQLiteHistoryStore.swift`: history images are still loaded fully into memory; lazy loading is not implemented yet.

### Known issues

- Full XCTest has not been completed on the current machine; GitHub CI will run after push.
- No real RSS comparison has been done for the low-memory changes; they do not guarantee fixing the roughly 700 MB resident usage.
- The demo is Ad Hoc signed and not notarized; macOS may block it.
- The Bundle ID remains `com.nathanponcet.whisk`; do not install it alongside the official Whisk.

### Source structure

- `Entities/`: `History`, `ClipboardItem`, `Payload`, `SourceApp`, etc.
- `UseCases/`: pure logic for capture, search, filter, delete, undo and retention.
- `Adapters/`: `ClipboardController`, `HistoryPresenter`, `SQLiteHistoryStore`, `AppKitPasteboard`, etc.
- `App/`: SwiftUI views, panel, menu bar, hot key and composition root.
