-- PCL2 龙猫蓝 —— 按 PCL2 (Plain Craft Launcher 2) 默认主题「龙猫蓝」1:1 复刻
--
-- 色值取自 PCL2 源码（ModSecret.vb）：ColorHue=210, ColorSat=85, ColorLightAdjust=0
--   Color1 = HSL(210, 17, 25) = #35404B   深色文字 / 描边
--   Color2 = HSL(210, 85, 45) = #1173D4   主色：高亮按钮、强调文字
--   Color3 = HSL(210, 85, 55) = #2B8CEE   主色-亮
--   顶栏   = HSL(210, 85, 48~54) = #127AE2~#268AED（横向渐变，取中值 #268AED）
--   页面背景 = #F5F5F5（PanForm），卡片 = #FFFFFF（MyCard，圆角 3）
--   Gray3 = #8C8C8C 次要文字，Gray5 = #CCCCCC 分隔线
--
-- 布局取自 FormMain.xaml / PageLaunchLeft.xaml：
--   顶部蓝色标题栏（logo + 横向导航：启动/下载/联机/设置/更多，白字）
--   左栏（iPad 300pt）：启动按钮（高 54、圆角 3）+ 版本信息 + 功能按钮 + 玩家卡
--   右侧内容区

local C = {
  color1 = "#35404B",   -- 深色文字（PCL2 Color1）
  color2 = "#1173D4",   -- 主蓝（PCL2 Color2）
  color3 = "#2B8CEE",   -- 亮蓝（PCL2 Color3）
  topbar = "#268AED",   -- 顶栏蓝（PCL2 顶栏渐变中值）
  page   = "#F5F5F5",   -- 页面背景（PCL2 PanForm）
  card   = "#FFFFFF",   -- 卡片（PCL2 MyCard）
  gray3  = "#8C8C8C",   -- 次要文字（PCL2 Gray3）
  gray5  = "#CCCCCC",   -- 分隔线（PCL2 Gray5）
  white  = "#FFFFFF",
}

function describe()
  return { name = "PCL2 龙猫蓝", author = "Pear", version = "1.0.0" }
end

function build(ui)
  return ui.column {
    id = "shell",
    children = {
      -- 顶部标题栏：Pear logo + 横向导航（PCL2：启动/下载/联机/设置/更多，白字无底）
      ui.row {
        id = "titlebar",
        height = 52,
        background = C.topbar,
        padding = { left = 18, right = 14, top = 0, bottom = 0 },
        spacing = 22,
        children = {
          ui.text {
            id = "logo",
            text = "Pear",
            style = { font = 18, weight = "bold", color = C.white },
          },
          ui.nav {
            id = "nav",
            layout = "horizontal",
            spacing = 6,
            items = {
              { id = "nav.home",     icon = "sf:house.fill",                         label = "启动", action = "open:home",       style = { tint = C.white, font = 15 } },
              { id = "nav.download", icon = "sf:arrow.down.circle.fill",             label = "下载", action = "open:download",   style = { tint = C.white, font = 15 } },
              { id = "nav.link",     icon = "sf:antenna.radiowaves.left.and.right",  label = "联机", action = "open:multiplayer", style = { tint = C.white, font = 15 } },
              { id = "nav.setup",    icon = "sf:gearshape.fill",                     label = "设置", action = "open:settings",   style = { tint = C.white, font = 15 } },
              { id = "nav.other",    icon = "sf:ellipsis.circle.fill",               label = "更多", action = "open:mods",       style = { tint = C.white, font = 15 } },
            },
          },
        },
      },
      -- 主体：左栏（PCL2 PageLaunchLeft，iPad 宽 300）+ 内容区
      ui.row {
        id = "page",
        weight = 1,
        children = {
          ui.column {
            id = "left",
            width = ui.dimen({ phone = 170, pad = 300 }),
            background = C.page,
            padding = { left = 15, right = 15, top = 15, bottom = 12 },
            spacing = 10,
            children = {
              -- 版本信息（PCL2 LabVersion：按钮下方 11pt 灰字）
              ui.text {
                id = "versionDetail",
                text = "正在加载版本…",
                style = { font = 11, color = C.gray3 },
              },
              -- 启动按钮（PCL2 BtnLaunch：高 54、圆角 3、白底主色字）
              ui.button {
                id = "launch",
                label = "启动游戏",
                action = "launch",
                height = 54,
                corner = 3,
                style = { background = C.card, tint = C.color2, font = 17, weight = "medium" },
              },
              ui.divider { background = C.gray5 },
              -- 选择版本 / 实例配置（PCL2 BtnVersion / BtnMore：高 35、圆角 3）
              ui.row {
                id = "row.version",
                spacing = 10,
                children = {
                  ui.button { id = "chooseVersion", label = "选择版本", action = "open:versionManager", height = 35, corner = 3, weight = 1, style = { background = C.card, tint = C.color1, font = 13 } },
                  ui.button { id = "profileEdit",   label = "实例配置", action = "open:profileEditor",   height = 35, corner = 3, weight = 1, style = { background = C.card, tint = C.color1, font = 13 } },
                },
              },
              -- 账号管理 / 游戏文件夹（PCL2 风格次级按钮）
              ui.row {
                id = "row.account",
                spacing = 10,
                children = {
                  ui.button { id = "account", label = "账号管理",   action = "open:accountManager", height = 35, corner = 3, weight = 1, style = { background = C.card, tint = C.color1, font = 13 } },
                  ui.button { id = "gameDir", label = "游戏文件夹", action = "open:gameDirectory",   height = 35, corner = 3, weight = 1, style = { background = C.card, tint = C.color1, font = 13 } },
                },
              },
              -- Pear 扩展入口（AI / 光影）
              ui.row {
                id = "row.extras",
                spacing = 10,
                children = {
                  ui.button { id = "ai",      label = "AI",   action = "open:ai",      height = 32, corner = 3, weight = 1, style = { background = C.card, tint = C.color3, font = 13 } },
                  ui.button { id = "shaders", label = "光影", action = "open:shaders", height = 32, corner = 3, weight = 1, style = { background = C.card, tint = C.color3, font = 13 } },
                },
              },
              ui.spacer { weight = 1 },
              -- 玩家卡（PCL2 左下角 MySkin 玩家卡片）
              ui.panel {
                id = "playerCard",
                background = C.card,
                corner = 3,
                padding = 12,
                spacing = 4,
                children = {
                  ui.text { id = "playerTitle", text = "当前玩家", style = { font = 11, color = C.gray3 } },
                  ui.text { id = "playerName",  text = "未登录",   style = { font = 15, weight = "medium", color = C.color1 } },
                },
              },
            },
          },
          ui.content { id = "content", weight = 1, initialPage = "home" },
        },
      },
    },
  }
end

-- 默认文案（事件里回退用）
local defaultLaunchLabel = "启动游戏"
local defaultVersionDetail = "尚未选择版本"
local defaultPlayerName = "未登录"

function onReady()
  local state = launcher.state or {}
  local version = state.version or {}
  local account = state.account or {}

  -- PCL2 行为：启动按钮显示所选版本名，下方灰字显示版本详情
  if version.name and version.name ~= "" then
    launcher.view("launch"):setText(version.name)
    launcher.view("versionDetail"):setText(version.name)
  else
    launcher.view("launch"):setText(defaultLaunchLabel)
    launcher.view("versionDetail"):setText(defaultVersionDetail)
  end

  if account.name and account.name ~= "" then
    launcher.view("playerName"):setText(account.name)
  end
end

function onAccountChange(account)
  local view = launcher.view("playerName")
  if not view then return end
  if account and account.name and account.name ~= "" then
    view:setText(account.name)
  else
    view:setText(defaultPlayerName)
  end
end

function onClick(id)
  -- PCL2 的启动按钮点击有缩放动画；引擎动画能力接入后在此补充
end
