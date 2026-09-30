# Pear-ui

[Pear 启动器](https://github.com/twoyears666/A-pear)的 UI 材质包合集。每个子目录是一个独立可导入的 UI 包。

## 包列表

| 包 | 目录 | 版本 | 说明 |
|---|---|---|---|
| PCL2 复刻 · 浅色 | [pcl2-totoro-blue/](pcl2-totoro-blue/) | 1.28.0-beta | 仿 PCL 浅色：蓝色顶栏（4 页签：启动/下载/设置/更多，选中=白胶囊）+ 二级页「← + 标题」+ 浅蓝灰渐变背景 + 白底卡片；启动页左右分栏（正版/离线胶囊 + 账号行 + 大号启动按钮 + 左栏「启动中」进度态），启动页可达子页（下载各分类、版本设置概览/设置/Mod 管理/导出/资源、版本选择、账号管理、游戏目录、联机、更多）完整实现 |
| 清风蓝调（HMCL 风格） | [hmcl-breeze/](hmcl-breeze/) | 0.1.1-beta | 仿 HMCL：品牌色通栏顶栏 + 左侧「图标 + 文字」分组导航 + hero 渐变横幅与悬浮启动面板 + 白底描边卡片；下载/联机/设置/版本管理/账号/游戏目录等页面数据驱动 |

## 安装

**方式一（推荐）：应用内导入**

1. 从 [Releases](../../releases) 下载对应包的 ZIP（如 [pcl2-totoro-blue.zip](../../releases/download/pcl2-totoro-blue-v1.4.0/pcl2-totoro-blue.zip)），也可直接下载包目录内的 ZIP（点击文件 → Download raw file）
2. Pear 启动器 → 设置 → 界面引擎 → 切换到「材质包引擎」
3. 欢迎界面点「导入 UI 包」→ 选择刚下载的 ZIP
4. 导入成功立即生效；包安装到 `Documents/uipack/active`

**方式二：放入主题目录**

将包目录内的内容（`manifest.json`、`main.lua`、`colors.json`）放到 `Documents/themes/<包 id>/`，然后在 设置 → 主题/材质包 中选择对应包。此方式下 `colors.json` 同时作用于原生页面配色。

## UI 包结构

```
<包目录>/
  <包id>.zip      # 可导入的 ZIP（内含 manifest.json + main.lua + colors.json）
  manifest.json   # schemaVersion: 2，id/name/author/entry
  main.lua        # describe() + build(ui) 布局树 + 事件回调
  colors.json     # 颜色令牌（放入 themes/ 时作用于原生页面）
```

### main.lua 速览

```lua
function build(ui)
  return ui.column {           -- 容器：row / column / panel / nav
    children = {
      ui.nav   { layout = "horizontal", items = { { icon = "sf:house.fill", label = "启动", action = "open:home" } } },
      ui.button{ label = "启动游戏", action = "launch", height = 54, corner = 3,
                 style = { background = "#FFFFFF", tint = "#1173D4", font = 17 } },
      ui.content{ weight = 1 },          -- 原生页面宿主（全树恰好一个）
    },
  }
end
```

- 布局：`ui.row / ui.column / ui.panel / ui.nav / ui.content` + `ui.dimen({ phone = 170, pad = 300 })` 响应式尺寸；`justify` / `crossAlign` 分布对齐、`width = "32%"` 百分比、`corner = "pill"` 药丸、`background = { from, to, angle }` 渐变
- 叶子：`ui.button / ui.text / ui.image / ui.divider / ui.spacer`
- 事件：`onReady` / `onAccountChange` / `onPageChange(page)` / `onClick(id)`
- API：`launcher.state`（只读状态）、`launcher.view(id):setText/setVisible/setStyle/...`、`launcher.action(name)`
- 动作白名单：`open:home/download/versionManager/settings/ai/mods/shaders/modpackImport/gameDirectory/accountManager/profileEditor/multiplayer/more`、`launch`（已接通真实启动链路）
- 颜色：`#RRGGBB` 直写或 `$color:token` 引用主题令牌；图片：`sf:SymbolName`（SF Symbols）或 `$image:token`

完整引擎文档见 Pear 主仓库 `Natives/` 目录源码与 `tests/test_uipack_contracts.py` 契约测试。

## 收录新包

欢迎通过 Pull Request 收录新包：新建子目录（目录名 = 包 id），包含可导入的 `<包id>.zip`（ZIP 内为 `manifest.json` / `main.lua` / `colors.json`）及这三份源文件，并同步更新上方包列表。
