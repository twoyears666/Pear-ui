# Pear-ui

[Pear 启动器](https://github.com/twoyears666/pear)的 UI 材质包仓库。本仓库根目录即一个可导入的 UI 包（PCL2 龙猫蓝），后续包可通过分支 / 发行版附加。

## 当前包：PCL2 龙猫蓝

按 [PCL2（Plain Craft Launcher 2）](https://github.com/LTCat/PlainCraftLauncher2)默认主题「龙猫蓝」1:1 复刻：

- **色值**：取自 PCL2 源码 `ModSecret.vb`（`ColorHue=210, ColorSat=85`）——主蓝 `#1173D4`（Color2）、顶栏蓝 `#268AED`、深色文字 `#35404B`（Color1）、页面背景 `#F5F5F5`、灰阶 `#8C8C8C/#CCCCCC`
- **布局**：取自 `FormMain.xaml` / `PageLaunchLeft.xaml`——顶部蓝色标题栏（logo + 启动/下载/联机/设置/更多横向导航）+ 左栏（iPad 宽 300：启动按钮高 54 圆角 3、选择版本/实例配置、玩家卡）+ 内容区
- **行为**：启动按钮显示所选版本名（PCL2 同款）、账号切换实时刷新玩家名

> 引擎限制说明：PCL2 顶栏为横向渐变、按钮带 1px 描边，当前引擎仅支持纯色背景，已取渐变中值 / 主色替代。

## 安装

**方式一（推荐）：应用内导入**

1. 下载本仓库 ZIP（绿色 **Code** 按钮 → **Download ZIP**）
2. Pear 启动器 → 设置 → 界面引擎 → 切换到「材质包引擎」
3. 欢迎界面点「导入 UI 包」→ 选择刚下载的 ZIP（导入器会自动剥掉外层文件夹）
4. 导入成功立即生效；包安装到 `Documents/uipack/active`

**方式二：放入主题目录**

将包内容（`manifest.json`、`main.lua`、`colors.json`）放到 `Documents/themes/pcl2-totoro-blue/`，然后在 设置 → 主题/材质包 中选择「PCL2 龙猫蓝」。此方式下 `colors.json` 同时作用于原生页面配色。

## UI 包结构

```
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
