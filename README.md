# Pear-ui

[Pear 启动器](https://github.com/twoyears666/pear)的 UI 材质包合集。每个子目录是一个独立可导入的 UI 包。

## 包列表

| 包 | 目录 | 版本 | 说明 |
|---|---|---|---|
| 龙猫蓝 | [pcl2-totoro-blue/](pcl2-totoro-blue/) | 1.0.0 | 经典蓝色主题：顶栏导航 + 左栏启动 |

## 安装

**方式一（推荐）：应用内导入**

1. 从 [Releases](../../releases) 下载对应包的 ZIP
2. Pear 启动器 → 设置 → 界面引擎 → 切换到「材质包引擎」
3. 欢迎界面点「导入 UI 包」→ 选择刚下载的 ZIP
4. 导入成功立即生效；包安装到 `Documents/uipack/active`

**方式二：放入主题目录**

将包目录内的内容（`manifest.json`、`main.lua`、`colors.json`）放到 `Documents/themes/<包 id>/`，然后在 设置 → 主题/材质包 中选择对应包。此方式下 `colors.json` 同时作用于原生页面配色。

## UI 包结构

```
<包目录>/
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

- 布局：`ui.row / ui.column / ui.panel / ui.nav / ui.content` + `ui.dimen({ phone = 170, pad = 300 })` 响应式尺寸
- 叶子：`ui.button / ui.text / ui.image / ui.divider / ui.spacer`
- 事件：`onReady` / `onAccountChange` / `onClick(id)`
- API：`launcher.state`（只读状态）、`launcher.view(id):setText/setVisible/...`、`launcher.action(name)`
- 动作白名单：`open:home/download/versionManager/settings/ai/mods/shaders/modpackImport/gameDirectory/accountManager/profileEditor/multiplayer`、`launch`（M4 接入）
- 颜色：`#RRGGBB` 直写或 `$color:token` 引用主题令牌；图片：`sf:SymbolName`（SF Symbols）或 `$image:token`

完整引擎文档见 Pear 主仓库 `Natives/` 目录源码与 `tests/test_uipack_contracts.py` 契约测试。

## 收录新包

欢迎通过 Pull Request 收录新包：新建子目录（目录名 = 包 id），包含 `manifest.json` / `main.lua` / `colors.json`，并同步更新上方包列表与发布 Release ZIP。
