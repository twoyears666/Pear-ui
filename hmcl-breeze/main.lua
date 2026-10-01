-- Pear 启动器 · HMCL 清风蓝调 UI 包 —— v0.2.0-beta
--
-- 视觉仿 HMCL（Hello Minecraft! Launcher）桌面版：
--   · 顶栏 = 品牌色通栏（$color:topbar）+ 应用图标 + 标题 + 右侧 ? / − / ✕；
--     子页顶栏改为 ← 返回 + 页面标题。
--   · 左栏 = 白底分组导航（组标题=小字灰字 + 右侧细分隔线），
--     条目 = 图标 + 标题（+ 灰副标题），选中态 = 白色悬浮卡片（阴影 + 描边）。
--   · 主区 = 大幅 hero 渐变横幅 + 右下角品牌色圆角悬浮启动面板（启动游戏 / 版本 / ▾）。
--   · 设置页 = 卡外左侧灰色分节标题 + 白卡行（label 左对齐 / 控件右对齐：开关 / 下拉 / 单选）。
--   · 安装向导 = 品牌色标题栏（← + 安装新游戏 - <版本>）+ 白卡 + 加载器选项卡 + 右下「安装」。
--
-- 契约（引擎通用，零特例）：
--   尺寸：纵向按窗口高 1H 比例（vh = 0.01H），横向用 %；最小可点区域 >= 0.06H。
--   颜色：全部走 colors.json 令牌（$color:*），不硬编码、不新增令牌。
--   页面：content 节点恰好 1 个，页 token ∈ CONFIG.pages；仅浅色主题。
--   点击：引擎派发下划线形式的节点 id，onClick 用 string.match 剥后缀/前缀匹配。

function describe()
  return { name = "清风蓝调", version = "0.3.0-beta" }
end

-- ============ 颜色令牌 ============
local C = {
  topbar       = "$color:topbar",
  pageFrom     = "$color:pageFrom",
  pageTo       = "$color:pageTo",
  card         = "$color:card",
  cardBorder   = "$color:cardBorder",
  dark         = "$color:cardText",
  mid          = "$color:subText",
  white        = "$color:white",
  transparent  = "$color:transparent",
  accent       = "$color:accent",
  accentBorder = "$color:accentBorder",
  hover        = "$color:hover",
  avatarBg     = "$color:avatarBg",
  avatarLine   = "$color:avatarLine",
  success      = "$color:success",
  danger       = "$color:danger",
  warningBg    = "$color:warningBg",
  hintBg       = "$color:faintBlue",
  fieldBorder  = "$color:fieldBorder",
  green        = "$color:brandGreen",
  orange       = "$color:brandOrange",
  purple       = "$color:brandPurple",
  pink         = "$color:brandPink",
  cyan         = "$color:brandCyan",
  border       = "$color:border",
}

-- ============ 尺寸令牌（便于材料包替换 / 对齐 HMCL 规格）============
local DIM = {
  bar          = "6.6vh",   -- 顶栏高
  rail         = "26%",     -- 左栏宽（≈窗口 1/4）
  railItem     = "6vh",     -- 导航条目高
  railItemTall = "6.8vh",   -- 带副标题条目高
  rowH         = "7vh",     -- 条目卡高 ≈0.07H
  rowIcon      = "3.5vh",   -- 条目左图标 ≈0.035H
  cardRadius   = "1.2vh",   -- 圆角 ≈0.012H
  cardPad      = "1.8vh",
  cardSpace    = "2vh",     -- 卡片间距 ≥0.02H
  gap          = "1.6vh",
  pagePad      = "2vh",
  inputH       = "6vh",
}
local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_T = { width = "0.12vh", color = C.transparent }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local SHADOW   = { blur = "0.35vh", opacity = 0.10, x = 0, y = "0.16vh" }

-- hero 横幅渐变（包内无图片资源，用令牌渐变模拟；离线安全）
local HERO_FROM = "$color:heroFrom"
local HERO_TO   = "$color:heroTo"

-- ============ 品牌 / 文案配置（避免规则里硬编码）============
local BRAND = {
  title  = "Hello Minecraft! Launcher",
  sub    = "v3.7.3",
  icon   = "sf:cube.transparent.fill",
}
local HERO = {
  title = "欢迎回来",
  sub   = "选择一个实例，开始你的 Minecraft 之旅。",
}
local LAUNCH = {
  label = "启动游戏",
}
local NAV_ACCOUNT = { fallbackName = "账号管理", fallbackSub = "未登录账号" }
local INSTALL = { titlePrefix = "安装新游戏 - ", nameLabel = "游戏实例名称", start = "安装" }

-- ============ 左侧导航栏（HMCL 式分组：账户 / 游戏 / 通用）============
local RAIL_SECTIONS = {
  { name = "账户", items = {
      { id = "navAccount", icon = "sf:person.crop.circle.fill", label = NAV_ACCOUNT.fallbackName,
        titleId = "navAccount_label", subId = "navAccount_sub", sub = NAV_ACCOUNT.fallbackSub,
        action = "open:accountManager", page = "accountManager", avatar = true },
    } },
  { name = "游戏", items = {
      { id = "navHome", icon = "sf:square.stack.3d.up.fill", label = "实例管理",
        subId = "navHome_sub", sub = "未选择版本", action = "open:home", page = "home", thumb = true },
      { id = "navVersionManager", icon = "sf:list.bullet",        label = "实例列表", action = "open:versionManager",   page = "versionManager" },
      { id = "navDownload",       icon = "sf:arrow.down.circle",  label = "下载",     action = "open:download",         page = "download" },
      { id = "navVersionSettings", icon = "sf:wrench.and.screwdriver", label = "版本设置", action = "open:version_settings", page = "version_settings" },
      { id = "navGameDirectory",  icon = "sf:folder",             label = "游戏目录", action = "open:gameDirectory",    page = "gameDirectory" },
    } },
  { name = "通用", items = {
      { id = "navSettings", icon = "sf:gearshape",      label = "设置",     action = "open:settings", page = "settings" },
      { id = "navMulti",    icon = "sf:network",        label = "多人联机", action = "open:multi",    page = "multi" },
      { id = "navMore",     icon = "sf:ellipsis.circle", label = "更多",    action = "open:more",     page = "more" },
    } },
}

local RAIL = {}
for _, sec in ipairs(RAIL_SECTIONS) do
  for _, it in ipairs(sec.items) do RAIL[#RAIL + 1] = it end
end

local PAGE_RAIL = {
  home = "navHome", download = "navDownload", multi = "navMulti",
  settings = "navSettings", more = "navMore", version_settings = "navVersionSettings",
  versionManager = "navVersionManager", accountManager = "navAccount",
  gameDirectory = "navGameDirectory", versionDetail = "navVersionManager",
}

local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore", version_settings = "pageVersionSettings",
    versionManager = "pageVersionManager", accountManager = "pageAccountManager",
    gameDirectory = "pageGameDirectory", versionDetail = "pageVersionDetail",
  },
  pageTitles = {
    download = "下载", multi = "多人联机", settings = "设置", more = "更多",
    version_settings = "版本设置", versionManager = "实例列表",
    accountManager = "账号管理", gameDirectory = "游戏目录", versionDetail = "实例详情",
  },
  download = {
    installHint = "安装后请留意版本与 Mod 兼容性；Fabric/Forge 需安装对应加载器。",
    searchStatusPreset = "点击「搜索」获取社区资源，点击结果条目可下载最新版本",
    communitySlots = 6,
    componentCount = 2,
    componentRows = 3,
    loaders = { "无", "Fabric", "Forge", "Quilt", "NeoForge" },
    installers = {
      { name = "Minecraft",   sub = "原版核心",     icon = "sf:cube.fill" },
      { name = "Forge",       sub = "与 Fabric 不兼容", icon = "sf:hammer.fill" },
      { name = "NeoForge",    sub = "与 Fabric 不兼容", icon = "sf:flame.fill" },
      { name = "OptiFine",    sub = "与 Fabric 不兼容", icon = "sf:sparkles" },
      { name = "Fabric",      sub = "0.17.3",       icon = "sf:square.stack.3d.up.fill" },
      { name = "Fabric API",  sub = "不安装",       icon = "sf:puzzlepiece.fill" },
      { name = "Quilt",       sub = "与 Fabric 不兼容", icon = "sf:leaf.fill" },
      { name = "QSL/QFAPI",   sub = "与 Fabric 不兼容", icon = "sf:shippingbox.fill" },
    },
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "预览版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
  },
  multi = {
    branches = { "局域网", "在线" },
    preset = "选择模式后创建或加入房间。",
  },
  settingsGroups = {
    { id = "appearance", label = "外观", rows = {
        { type = "select", label = "主题",       key = "theme",  options = { "清风蓝调", "跟随系统" } },
        { type = "toggle", label = "标题栏透明", key = "barAlpha" },
        { type = "toggle", label = "关闭动画（重启后生效）", key = "noAnim" },
      } },
    { id = "background", label = "背景图片", rows = {
        { type = "radio",  label = "背景来源", key = "bgSource",
          options = { "默认", "经典", "自定义", "网络", "纯色" } },
      } },
    { id = "launcher_settings", label = "启动器", rows = {
        { type = "select", label = "界面语言",       key = "lang",  options = { "简体中文", "English" } },
        { type = "toggle", label = "启动时检查更新", key = "checkUpdate" },
        { type = "button", label = "打开日志目录",   key = "logs" },
      } },
    { id = "download_mirror", label = "下载", rows = {
        { type = "select", label = "下载源",       key = "source", options = { "自动", "BMCLAPI", "MCBBS" } },
        { type = "toggle", label = "自动检测延迟", key = "ping" },
        { type = "toggle", label = "并发下载",     key = "parallel" },
      } },
    { id = "video_settings", label = "视频", rows = {
        { type = "toggle", label = "垂直同步", key = "vsync" },
        { type = "toggle", label = "限制帧率", key = "fps" },
        { type = "select", label = "画面质量", key = "gfx", options = { "流畅", "均衡", "高品质" } },
      } },
    { id = "account_settings", label = "账号", rows = {
        { type = "button", label = "添加账号", key = "addAccount" },
        { type = "button", label = "退出登录", key = "logout" },
      } },
  },
  settingsStatus = "设置项以输入为准，开关与选项即时生效。",
  vs_categories = {
    { token = "overview", label = "概览" },
    { token = "settings", label = "游戏设置" },
    { token = "mods",     label = "Mod 管理" },
    { token = "advanced", label = "高级" },
  },
  vsGroups = {
    { id = "overview", rows = {
        { type = "select", label = "游戏版本",     key = "vsVer", options = { "自动", "1.20.1", "1.19.4" } },
        { type = "button", label = "打开版本目录", key = "vsDir" },
      } },
    { id = "settings", rows = {
        { type = "toggle", label = "全屏启动",     key = "vsFull" },
        { type = "select", label = "窗口分辨率",   key = "vsRes", options = { "自动", "1280x720", "1920x1080" } },
        { type = "toggle", label = "版本隔离",     key = "vsIso" },
      } },
    { id = "mods", rows = {
        { type = "toggle", label = "启用全部 Mod",  key = "vsModAll" },
        { type = "button", label = "安装 Mod",      key = "vsModIn" },
        { type = "button", label = "打开 Mods 目录", key = "vsModDir" },
      } },
    { id = "advanced", rows = {
        { type = "toggle", label = "调试模式",     key = "vsDebug" },
        { type = "button", label = "补全资源文件", key = "vsFix" },
        { type = "button", label = "导出启动脚本", key = "vsExport" },
      } },
  },
  moreGroups = {
    { name = "资源", rows = {
        { id = "moreDefaultVersion", icon = "sf:cube.fill",             label = "默认版本", right = "version", action = "open:versionManager" },
        { id = "moreVersions",       icon = "sf:list.bullet",           label = "实例列表", right = "chevron", action = "open:versionManager" },
        { id = "moreVersionSetup",   icon = "sf:wrench.and.screwdriver", label = "版本设置", right = "chevron", action = "open:version_settings" },
      } },
    { name = "高级", rows = {
        { id = "moreDirectory", icon = "sf:folder",             label = "游戏目录", right = "chevron", action = "open:gameDirectory" },
        { id = "moreAccount",   icon = "sf:person.crop.circle", label = "账号管理", right = "chevron", action = "open:accountManager" },
    } },
    { name = "帮助", rows = {
        { id = "moreAbout", icon = "sf:info.circle", label = "关于启动器", right = "chevron", action = "open:more" },
        { id = "moreLogs",  icon = "sf:doc.text",    label = "日志",       right = "chevron", action = "open:more" },
      } },
  },
  versionManager = { title = "实例列表", emptyText = "尚未安装任何游戏版本，可前往下载页获取。", addAction = "open:download" },
  accountManager = { title = "账号管理", emptyText = "暂无已登录账号，登录后即可联机同步。", addAction = "open:settings" },
  gameDirectory  = { title = "游戏目录", emptyText = "尚未创建其他游戏目录，可在下方输入名称新建。", addPlaceholder = "输入新目录名…" },
  detail         = { title = "实例详情" },
}

-- 行配置索引：key -> row（供 onClick 剥后缀后取回配置）
local SET_ROWS = {}
for _, g in ipairs(CONFIG.settingsGroups) do
  for _, s in ipairs(g.rows or {}) do SET_ROWS[s.key] = s end
end
for _, g in ipairs(CONFIG.vsGroups) do
  for _, s in ipairs(g.rows or {}) do SET_ROWS[s.key] = s end
end

-- ============ 通用构件 ============
local function card(id, children, opts)
  opts = opts or {}
  local shadow = SHADOW
  if opts.flat then shadow = nil end
  return ui.column {
    id = id, width = opts.width or "100%", crossAlign = opts.crossAlign or "stretch",
    background = opts.background or C.card, border = opts.border or BORDER,
    corner = opts.corner or DIM.cardRadius, shadow = shadow,
    padding = opts.padding or DIM.cardPad, spacing = opts.spacing or DIM.cardSpace,
    hoverColor = opts.hoverColor, visible = opts.visible, children = children,
  }
end

-- 卡内小标题（accent 粗体）
local function cardTitle(text)
  return ui.text { text = text, width = "100%",
    style = { font = "2.6vh", weight = "bold", color = C.accent } }
end

-- 卡外分节标题（HMCL：左侧小号灰字）
local function groupLabel(text, width)
  return ui.text { text = text, width = width or "94%",
    style = { font = "2.2vh", weight = "bold", color = C.mid } }
end

local function chevron(tint)
  return ui.image { icon = "sf:chevron.right", size = "2.3vh", style = { tint = tint or C.mid } }
end

local function iconTile(icon, opts)
  opts = opts or {}
  return ui.image { id = opts.id, icon = icon, size = opts.size or DIM.rowIcon,
    corner = opts.corner or "0.9vh", background = opts.background or C.hintBg,
    style = { tint = opts.tint or C.accent } }
end

-- 条目卡：整行可点（左图标 + 标题/副标题 + 右值/›）
local function listRow(spec)
  local right
  if spec.valueId or spec.value then
    right = ui.text { id = spec.valueId, text = spec.value or "",
      style = { font = "2.3vh", color = spec.valueColor or C.mid } }
  else
    right = chevron()
  end
  local mid
  if spec.sub then
    mid = ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
      ui.text { id = spec.titleId, text = spec.title, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = spec.subId, text = spec.sub, style = { font = "1.9vh", color = C.mid } },
    } }
  else
    mid = ui.text { id = spec.titleId, text = spec.title, weight = 1,
      style = { font = "2.5vh", color = C.dark } }
  end
  return ui.row { id = spec.id, action = spec.action, width = "100%", height = spec.height or DIM.rowH,
    crossAlign = "center", spacing = "1.5vh", padding = { left = "1.2vh", right = "1.2vh" },
    corner = DIM.cardRadius, hoverColor = C.hover, visible = spec.visible, children = {
      iconTile(spec.icon, { tint = spec.tint, background = spec.tintBg, id = spec.iconId }),
      mid,
      right,
    } }
end

-- HMCL 填充式操作按钮（主按钮品牌色底白字）
local function actionButton(id, label, primary, action)
  return ui.row { id = id, action = action or id, corner = DIM.cardRadius,
    padding = { left = "2.6vh", right = "2.6vh", top = "0.9vh", bottom = "0.9vh" },
    background = primary and C.accent or C.card, border = BORDER_A, hoverColor = C.hover,
    children = { ui.text { text = label,
      style = { font = "2.4vh", weight = primary and "bold" or "normal", color = primary and C.white or C.dark } } } }
end

-- 胶囊选择标签
local function pill(id, textId, label, selected)
  return ui.row { id = id, corner = DIM.cardRadius, height = "5.4vh",
    crossAlign = "center", justify = "center",
    padding = { left = "2.4vh", right = "2.4vh", top = "0.6vh", bottom = "0.6vh" },
    background = selected and C.card or C.card,
    border = selected and BORDER_A or BORDER, hoverColor = C.hover,
    children = { ui.text { id = textId, text = label, style = { font = "2.3vh", color = C.dark } } } }
end

-- 左栏导航条目（选中态 = 白色悬浮卡片；未选中透明，阴影随之不可见）
local function railItem(r)
  local ico
  if r.avatar then
    ico = iconTile(r.icon, { id = r.id .. "_ico", corner = "pill", background = C.avatarBg, tint = C.mid })
  elseif r.thumb then
    ico = iconTile(r.icon, { id = r.id .. "_ico", tint = C.mid })
  else
    ico = ui.image { id = r.id .. "_ico", icon = r.icon, size = DIM.rowIcon, style = { tint = C.mid } }
  end
  local mid
  if r.sub then
    mid = ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
      ui.text { id = r.titleId or (r.id .. "_label"), text = r.label, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = r.subId, text = r.sub, style = { font = "1.9vh", color = C.mid } },
    } }
  else
    mid = ui.text { id = r.titleId or (r.id .. "_label"), text = r.label, weight = 1,
      style = { font = "2.5vh", color = C.dark } }
  end
  return ui.row { id = r.id, action = r.action, width = "100%",
    height = r.sub and DIM.railItemTall or DIM.railItem,
    crossAlign = "center", spacing = "1.3vh", padding = { left = "1.2vh", right = "1.2vh" },
    corner = DIM.cardRadius, background = C.transparent, border = BORDER_T,
    shadow = SHADOW, hoverColor = C.hover, children = { ico, mid } }
end

local function statusBar(barId, textId, text, width)
  return ui.row { id = barId, width = width or "94%", background = C.hintBg, corner = DIM.cardRadius,
    crossAlign = "center", spacing = "1.2vh", padding = "1.5vh", children = {
      ui.image { icon = "sf:info.circle.fill", size = "2.6vh", style = { tint = C.accent } },
      ui.text { id = textId, weight = 1, text = text, style = { font = "2.2vh", color = C.dark } },
    } }
end

local function updateBar(trackId, fillId, pct)
  pct = tonumber(pct) or 0
  if pct < 0 then pct = 0 elseif pct > 100 then pct = 100 end
  local tr = launcher.view(trackId)
  if not tr then return end
  local fr = tr:getFrame() or {}
  local w = (tonumber(fr.w) or 0) * pct / 100
  local h = tonumber(fr.h) or 1.4
  if h <= 0 then h = 1.4 end
  if launcher.view(fillId) then
    launcher.view(fillId):setFrame({ x = 0, y = 0, w = w, h = h })
  end
end

-- ============ 设置行（数据驱动，id 剥离后缀匹配）============
local function settingsRow(s)
  local id = "set_" .. s.key
  if s.type == "radio" then
    local opts = s.options or {}
    local kids = { ui.text { text = s.label, width = "100%",
      style = { font = "2.4vh", color = C.dark } } }
    for i, opt in ipairs(opts) do
      kids[#kids + 1] = ui.row { id = id .. "_opt" .. i, action = id .. "_opt" .. i,
        width = "100%", height = "5.6vh", crossAlign = "center", spacing = "1.4vh",
        corner = "1vh", hoverColor = C.hover, children = {
          ui.image { id = id .. "_dot" .. i,
            icon = (i == 1) and "sf:largecircle.fill.circle" or "sf:circle",
            size = "2.6vh", style = { tint = (i == 1) and C.accent or C.mid } },
          ui.text { text = opt, weight = 1, style = { font = "2.4vh", color = C.dark } },
        } }
    end
    return ui.column { id = id, width = "100%", spacing = "0", children = kids }
  end

  local right
  if s.type == "toggle" then
    right = ui.row { id = id .. "_sw", action = id .. "_sw", height = "3.6vh", width = "6.8vh",
      corner = "pill", background = C.fieldBorder, children = {
        ui.row { height = "100%", justify = "end", crossAlign = "center",
          padding = { left = "0.5vh", right = "0.5vh", top = "0.4vh", bottom = "0.4vh" }, children = {
            ui.row { id = id .. "_knob", height = "2.8vh", width = "2.8vh", corner = "pill", background = C.card },
          } },
      } }
  elseif s.type == "select" then
    right = ui.row { id = id .. "_v", action = id .. "_v", corner = DIM.cardRadius,
      padding = { left = "2.2vh", right = "2vh", top = "0.6vh", bottom = "0.6vh" },
      crossAlign = "center", spacing = "0.8vh", background = C.card, border = BORDER_A,
      hoverColor = C.hover, children = {
        ui.text { id = id .. "_val", text = (s.options and s.options[1]) or "···",
          style = { font = "2.3vh", color = C.accent } },
        ui.image { icon = "sf:chevron.down", size = "2vh", style = { tint = C.accent } },
      } }
  elseif s.type == "button" then
    right = ui.row { id = id .. "_btn", action = id .. "_btn", corner = DIM.cardRadius,
      padding = { left = "2.6vh", right = "2.6vh", top = "0.6vh", bottom = "0.6vh" },
      background = C.card, border = BORDER_A, hoverColor = C.hover,
      children = { ui.text { text = "执行", style = { font = "2.3vh", color = C.accent } } } }
  else
    right = ui.text { text = "···", style = { font = "2.3vh", color = C.mid } }
  end
  return ui.row { id = id, width = "100%", height = "6.6vh", crossAlign = "center",
    spacing = "1.5vh", padding = { left = "0.4vh", right = "0.4vh" }, corner = "1vh",
    hoverColor = C.hover, children = {
      ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
      right,
    } }
end

-- ============ 首页：hero 横幅 + 右下品牌色悬浮启动面板 ============
local function buildHomePage()
  return ui.column { id = "pageHome", weight = 1, crossAlign = "stretch", spacing = 0,
    background = { from = HERO_FROM, to = HERO_TO, angle = 60 },
    padding = { left = "3vh", right = "3vh", top = "3vh", bottom = "3vh" }, children = {
      ui.text { text = HERO.title, width = "100%",
        style = { font = "4.6vh", weight = "bold", color = C.white } },
      ui.text { text = HERO.sub, width = "100%", style = { font = "2.4vh", color = C.white } },
      ui.spacer { weight = 1 },
      ui.row { width = "100%", crossAlign = "center", spacing = "1.6vh", children = {
        -- 左下：账号小块（点按进入账号管理）
        ui.row { id = "homeAccount", action = "open:accountManager", corner = DIM.cardRadius,
          background = C.card, border = BORDER, shadow = SHADOW, hoverColor = C.hover,
          padding = { left = "1.4vh", right = "2vh", top = "1vh", bottom = "1vh" },
          spacing = "1.2vh", crossAlign = "center", children = {
            ui.image { id = "panelAvatar", icon = "sf:person.crop.circle.fill", size = "5vh",
              corner = "pill", background = C.avatarBg, style = { tint = C.accent } },
            ui.column { justify = "center", spacing = "0.2vh", children = {
              ui.text { id = "accountName", text = "未登录",
                style = { font = "2.5vh", weight = "bold", color = C.dark } },
              ui.text { id = "accountType", text = "离线账号", style = { font = "2vh", color = C.mid } },
            } },
          } },
        ui.spacer { weight = 1 },
        -- 右下：品牌色悬浮启动面板
        ui.row { id = "launchPrimary", action = "launch", corner = DIM.cardRadius,
          background = C.topbar, shadow = SHADOW, hoverColor = C.accent,
          padding = { left = "2.8vh", right = "2.2vh", top = "1.4vh", bottom = "1.4vh" },
          spacing = "2.2vh", crossAlign = "center", children = {
            ui.column { justify = "center", spacing = "0.2vh", children = {
              ui.text { text = LAUNCH.label, style = { font = "2.9vh", weight = "bold", color = C.white } },
              ui.text { id = "panelVersion", text = "未选择版本", style = { font = "2vh", color = C.white } },
            } },
            ui.image { icon = "sf:chevron.down", size = "2.4vh", style = { tint = C.white } },
          } },
      } },
    } }
end

-- ============ 下载页 ============
local PLC = {}
local dlLevel = "groups"
local dlOpenGroup = {}
local dlGroups = {}
local dlCommItems = {}
local compSel = {}
local compOpen = {}
local loaderSel = 1

local function refreshInstallPanel()
  local v = (PLC.mc and PLC.mc ~= "") and PLC.mc or "未选择版本"
  if launcher.view("insTitle") then launcher.view("insTitle"):setText(INSTALL.titlePrefix .. v) end
  if launcher.view("insNameIn") and PLC.mc and PLC.mc ~= "" then
    -- 占位提示仅作文字提示，实际值由用户输入
  end
  for i = 1, CONFIG.download.componentCount do
    local cv = launcher.view("dlCompVer_" .. i)
    if cv then cv:setText(compSel[i] and "已选择" or "未选择") end
  end
end

local function refreshDownloadGroups()
  for gk, items in pairs(dlGroups) do
    local listV = launcher.view("dlGrpList_" .. gk)
    if listV then
      local open = dlOpenGroup[gk] == true
      local rows = {}
      if open then
        for j, it in ipairs(items) do
          rows[#rows + 1] = { table = "row", id = "dlGrpVer_" .. gk .. "_" .. j,
            crossAlign = "center", spacing = "1.4vh", padding = "1.1vh",
            corner = "1vh", hoverColor = C.hover, children = {
              { table = "image", icon = "sf:cube.fill", size = "3.4vh",
                corner = "pill", background = C.hintBg, style = { tint = C.accent } },
              { table = "text", text = it.name or it.id, weight = 1,
                style = { font = "2.4vh", color = C.dark } },
              { table = "text", text = it.type or "原版", style = { font = "2.1vh", color = C.mid } },
            } }
        end
      end
      listV:setVisible(open)
      if #rows > 0 then listV:append(rows) end
    end
  end
end

local function refreshDownloadVersions()
  local resp = launcher.service and launcher.service("download", "versions") or nil
  local groups = (type(resp) == "table" and type(resp.groups) == "table") and resp.groups or {}
  dlGroups = groups
  for _, g in ipairs(CONFIG.download.versionGroups) do
    local cnt = launcher.view("dlGh_" .. g.key .. "_cnt")
    if cnt then
      local n = #(groups[g.key] or {})
      cnt:setText(n > 0 and ("▸ " .. n) or "▸")
    end
  end
  refreshDownloadGroups()
end

local function refreshDownloadState()
  if launcher.view("dlGroupsCard") then launcher.view("dlGroupsCard"):setVisible(dlLevel == "groups") end
  if launcher.view("dlViewer") then launcher.view("dlViewer"):setVisible(dlLevel == "install") end
end

local function refreshLoaderCards()
  for i, _ in ipairs(CONFIG.download.installers) do
    local v = launcher.view("insLdr_" .. i)
    if v then
      local on = (i == loaderSel)
      v:setStyle({ background = on and C.faintBlue or C.card,
        borderColor = on and C.accentBorder or C.cardBorder })
    end
  end
end

local function buildVersionGroupsCard()
  local grpChildren = {}
  for _, g in ipairs(CONFIG.download.versionGroups) do
    local key = g.key
    grpChildren[#grpChildren + 1] = ui.column { width = "100%", spacing = "0", children = {
      ui.row { id = "dlGh_" .. key, action = "dlGh_" .. key, width = "100%", height = DIM.rowH,
        crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, children = {
          iconTile("sf:list.bullet", { corner = "pill" }),
          ui.text { text = g.name, weight = 1, style = { font = "2.5vh", color = C.dark } },
          ui.text { id = "dlGh_" .. key .. "_cnt", text = "▸", style = { font = "2.3vh", color = C.mid } },
        } },
      ui.column { id = "dlGrpList_" .. key, width = "100%", visible = false,
        spacing = "0.3vh", padding = { left = "1vh" }, children = {} },
    } }
  end
  return card("dlGroupsCard", {
    cardTitle("Minecraft 版本"),
    ui.text { text = "点击分组展开可用版本，点击具体版本进入安装向导。", width = "100%",
      style = { font = "2.1vh", color = C.mid } },
    ui.column { width = "100%", spacing = "0.2vh", children = grpChildren },
  }, { width = "94%", spacing = "0.8vh" })
end

local function buildMinecraftCard()
  return card("dlMc", {
    ui.row { id = "dlMcToggle", action = "dlMcToggle", width = "100%", height = DIM.rowH,
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, children = {
        iconTile("sf:cube.fill", { size = "4.2vh", tint = C.white,
          background = C.accent, corner = "1vh" }),
        ui.text { text = "Minecraft 版本", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.dark } },
        ui.text { id = "dlMcVersion", text = "未选择", style = { font = "2.4vh", color = C.accent } },
        chevron(),
      } },
    ui.column { id = "dlMcList", width = "100%", visible = false, spacing = "0.4vh", children = {} },
  }, { width = "94%", spacing = "0.8vh" })
end

local function buildComponentCard(i)
  local rows = {}
  for j = 1, CONFIG.download.componentRows do
    rows[#rows + 1] = ui.row { id = "dlCompV_" .. i .. "_" .. j, action = "dlCompV_" .. i .. "_" .. j,
      height = "5.5vh", crossAlign = "center", spacing = "1.4vh", corner = "1vh",
      hoverColor = C.hover, visible = false, children = {
        ui.image { icon = "sf:arrow.right.circle.fill", size = "3.2vh", style = { tint = C.accent } },
        ui.text { text = "组件版本 " .. j, weight = 1, style = { font = "2.4vh", color = C.dark } },
      } }
  end
  return card("dlComp_" .. i, {
    ui.row { id = "dlCompH_" .. i, action = "dlCompH_" .. i, width = "100%", height = DIM.rowH,
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, children = {
        iconTile("sf:shippingbox.fill", { size = "4.2vh", tint = C.white,
          background = C.green, corner = "1vh" }),
        ui.text { text = "附加组件 " .. i, weight = 1, style = { font = "2.6vh", color = C.dark } },
        ui.text { id = "dlCompVer_" .. i, text = "未选择", style = { font = "2.3vh", color = C.mid } },
        chevron(),
      } },
    ui.column { id = "dlCompList_" .. i, width = "100%", visible = false, spacing = "0.4vh", children = rows },
  }, { width = "94%", spacing = "0.8vh" })
end

-- 安装向导（对话框形态：品牌色标题栏 + 白卡 + 加载器选项卡 + 右下「安装」）
local function buildInstallWizard()
  -- 标题栏
  local bar = ui.row { width = "100%", height = DIM.bar, background = C.topbar,
    crossAlign = "center", spacing = "1.2vh",
    padding = { left = "1.4vh", right = "1.2vh" }, children = {
      ui.row { id = "dlBackGrp", action = "dlBackGrp", width = "4.4vh", height = "4.4vh",
        corner = "1vh", crossAlign = "center", justify = "center", hoverColor = C.accent, children = {
          ui.image { icon = "sf:chevron.left", size = "2.6vh", style = { tint = C.white } },
        } },
      ui.text { id = "insTitle", text = INSTALL.titlePrefix .. "未选择版本", weight = 1,
        style = { font = "2.7vh", weight = "bold", color = C.white } },
      ui.image { icon = "sf:questionmark.circle", size = "2.4vh", style = { tint = C.white } },
      ui.image { icon = "sf:minus", size = "2.4vh", style = { tint = C.white } },
      ui.image { icon = "sf:xmark", size = "2.4vh", style = { tint = C.white } },
    } }

  -- 名称行
  local nameCard = card(nil, {
    ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.6vh", children = {
      ui.text { text = INSTALL.nameLabel, style = { font = "2.5vh", color = C.dark } },
      ui.input { id = "insNameIn", weight = 1, height = DIM.inputH, placeholder = "输入实例名称（留空为默认）",
        corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
    } },
  }, { width = "100%", flat = true, border = BORDER, spacing = "0.6vh" })

  -- 加载器选项卡网格（4 列 × 2 行）
  local grid = {}
  local row = {}
  for i, it in ipairs(CONFIG.download.installers) do
    local on = (i == loaderSel)
    row[#row + 1] = ui.column { id = "insLdr_" .. i, action = "insLdr_" .. i,
      weight = 1, height = "12vh", corner = DIM.cardRadius,
      background = on and C.faintBlue or C.card,
      border = on and BORDER_A or BORDER, hoverColor = C.hover,
      crossAlign = "center", justify = "center", spacing = "0.6vh", children = {
        iconTile(it.icon, { size = "4.6vh", corner = "1vh", tint = C.accent }),
        ui.text { text = it.name, style = { font = "2.4vh", weight = "bold", color = C.dark } },
        ui.text { text = it.sub, style = { font = "1.9vh", color = C.mid } },
      } }
    if #row == 4 then grid[#grid + 1] = ui.row { width = "100%", spacing = "1.4vh", crossAlign = "stretch", children = row }; row = {} end
  end
  if #row > 0 then
    while #row < 4 do row[#row + 1] = ui.spacer { weight = 1 } end
    grid[#grid + 1] = ui.row { width = "100%", spacing = "1.4vh", crossAlign = "stretch", children = row }
  end

  return ui.column { id = "dlViewer", width = "94%", spacing = 0,
    background = C.card, border = BORDER, corner = DIM.cardRadius, shadow = SHADOW,
    visible = false, children = {
      bar,
      ui.column { width = "100%", spacing = DIM.gap, padding = DIM.cardPad, children = {
        nameCard,
        ui.column { width = "100%", spacing = "1.4vh", children = grid },
        ui.text { text = CONFIG.download.installHint, width = "100%",
          style = { font = "1.9vh", color = C.mid } },
        ui.row { id = "dlProgress", width = "100%", visible = false, crossAlign = "center", spacing = "1vh",
          padding = "1vh", children = {
            ui.text { id = "dlProgressLabel", text = "", weight = 1, style = { font = "2.2vh", color = C.dark } },
            ui.row { id = "dlBarTrack", width = "40%", height = "1.4vh", corner = "pill", background = C.hintBg, children = {
              ui.column { id = "dlBarFill", absolute = true, width = "0vh", height = "1.4vh",
                corner = "pill", background = C.accent },
            } },
          } },
        ui.row { width = "100%", justify = "end", children = {
          ui.row { id = "insStart", action = "insStart", corner = DIM.cardRadius,
            padding = { left = "3.4vh", right = "3.4vh", top = "1vh", bottom = "1vh" },
            background = C.accent, hoverColor = C.accentBorder, children = {
              ui.text { text = INSTALL.start, style = { font = "2.5vh", weight = "bold", color = C.white } },
            } },
        } },
      } },
    } }
end

local function buildCommunityCard()
  local slots = {}
  for i = 1, CONFIG.download.communitySlots do
    slots[#slots + 1] = ui.row { id = "dlComm_" .. i, action = "dlComm_" .. i, width = "100%", height = DIM.rowH,
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, visible = false, children = {
        iconTile("sf:doc.richtext.fill", { corner = "pill" }),
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "dlComm_" .. i .. "_title", text = "· · ·", style = { font = "2.5vh", weight = "bold", color = C.dark } },
          ui.text { id = "dlComm_" .. i .. "_meta", text = "· · ·", style = { font = "2.1vh", color = C.mid } },
        } },
        ui.text { id = "dlComm_" .. i .. "_btn", text = "下载", style = { font = "2.3vh", color = C.accent } },
      } }
  end
  return card("dlCommCard", {
    ui.row { width = "100%", crossAlign = "center", spacing = "1.2vh", children = {
      ui.text { text = "社区资源搜索", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.accent } },
      actionButton("dlCommKeyword", "关键词", false),
      actionButton("dlCommSearch", "搜索", true),
    } },
    ui.text { id = "dlCommStatus", text = CONFIG.download.searchStatusPreset, width = "100%",
      style = { font = "2.1vh", color = C.mid } },
    ui.column { width = "100%", spacing = "0.3vh", children = slots },
  }, { width = "94%", spacing = "0.8vh" })
end

local function buildDownloadPage()
  local kids = {}
  kids[#kids + 1] = buildVersionGroupsCard()
  kids[#kids + 1] = buildInstallWizard()
  kids[#kids + 1] = buildMinecraftCard()
  for i = 1, CONFIG.download.componentCount do
    kids[#kids + 1] = buildComponentCard(i)
  end
  kids[#kids + 1] = buildCommunityCard()
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = kids }
end

-- ============ 联机页 ============
local function buildMultiPage()
  local seg = {}
  for i, label in ipairs(CONFIG.multi.branches) do
    seg[#seg + 1] = ui.row { id = "segM_" .. i, action = "segM_" .. i, corner = DIM.cardRadius, height = "5.6vh",
      crossAlign = "center", justify = "center",
      padding = { left = "2.6vh", right = "2.6vh", top = "0.6vh", bottom = "0.6vh" },
      background = (i == 1) and C.faintBlue or C.card,
      border = (i == 1) and BORDER_A or BORDER, hoverColor = C.hover,
      children = { ui.text { id = "segM_" .. i .. "_t", text = label,
        style = { font = "2.3vh", weight = (i == 1) and "bold" or "normal", color = C.dark } } } }
  end
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = {
      card("mpCard", {
        cardTitle("联机大厅"),
        ui.text { text = "与好友在同一世界冒险：局域网直连或在线房间。", width = "100%",
          style = { font = "2.1vh", color = C.mid } },
        ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.5vh", children = {
          ui.text { text = "模式", style = { font = "2.4vh", color = C.mid } },
          (function()
            local out = {}
            for _, n in ipairs(seg) do out[#out + 1] = n end
            return ui.row { id = "segMRow", spacing = "1.2vh", crossAlign = "center", children = out }
          end)(),
        } },
        ui.text { id = "mpStatus", text = CONFIG.multi.preset, width = "100%",
          style = { font = "2.2vh", color = C.dark } },
        ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.5vh", children = {
          actionButton("mpCreate", "创建房间", true),
          actionButton("mpJoin", "加入房间", false),
        } },
      }, { width = "94%" }),
    } }
end

-- ============ 设置页（卡外分节标题 + 白卡行）============
local function buildSettingsPage()
  local kids = {}
  for _, g in ipairs(CONFIG.settingsGroups) do
    local rows = {}
    for i, s in ipairs(g.rows) do
      if i > 1 then rows[#rows + 1] = ui.divider { height = "0.08vh", background = C.cardBorder } end
      rows[#rows + 1] = settingsRow(s)
    end
    kids[#kids + 1] = ui.column { width = "94%", spacing = "0.8vh", crossAlign = "stretch", children = {
      groupLabel(g.label, "100%"),
      card("setSec_" .. g.id, rows, { width = "100%",
        padding = { left = "2vh", right = "2vh", top = "0.8vh", bottom = "0.8vh" }, spacing = "0" }),
    } }
  end
  kids[#kids + 1] = statusBar("setStatusBar", "setStatus", CONFIG.settingsStatus, "94%")
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = kids }
end

-- ============ 更多页 ============
local function buildMorePage()
  local kids = {}
  kids[#kids + 1] = card("moreThemeCard", {
    cardTitle("主题包"),
    ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.6vh", children = {
      iconTile("sf:paintbrush.fill", { size = "4.4vh", corner = "pill" }),
      ui.text { text = "主题包名称", weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = "moreThemeName_text", text = "清风蓝调", style = { font = "2.4vh", color = C.mid } },
    } },
    ui.divider { height = "0.08vh", background = C.cardBorder },
    ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.6vh", children = {
      iconTile("sf:tag.fill", { size = "4.4vh", corner = "pill" }),
      ui.text { text = "主题包版本", weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = "moreThemeVersion", text = "· · ·", style = { font = "2.4vh", color = C.mid } },
    } },
  }, { width = "94%", spacing = "0.6vh" })
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = { groupLabel(g.name, "100%") }
    for _, rr in ipairs(g.rows) do
      local spec = { id = rr.id, action = rr.action or "open:more", icon = rr.icon or "sf:gearshape", title = rr.label }
      if rr.right == "version" then
        spec.valueId = rr.id .. "_val"
        spec.value = "未选择"
      end
      rows[#rows + 1] = listRow(spec)
    end
    kids[#kids + 1] = card("moreSec_" .. g.name, rows, { width = "94%", spacing = "0.6vh" })
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = kids }
end

-- ============ 版本设置页 ============
local vsSelCat = "overview"
local VS_LABEL = {}
for _, cat in ipairs(CONFIG.vs_categories) do VS_LABEL[cat.token] = cat.label end

local function buildVersionSettingsPage()
  local chips = {}
  for _, cat in ipairs(CONFIG.vs_categories) do
    chips[#chips + 1] = pill("vsCat_" .. cat.token, "vsCat_" .. cat.token .. "_t", cat.label, false)
  end
  local sections = {}
  for _, g in ipairs(CONFIG.vsGroups) do
    local rows = {}
    for i, s in ipairs(g.rows) do
      if i > 1 then rows[#rows + 1] = ui.divider { height = "0.08vh", background = C.cardBorder } end
      rows[#rows + 1] = settingsRow(s)
    end
    sections[#sections + 1] = card("vsSec_" .. g.id, rows, { width = "94%", visible = false,
      padding = { left = "2vh", right = "2vh", top = "0.8vh", bottom = "0.8vh" }, spacing = "0" })
  end
  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = {
      card("vsHead", {
        ui.row { width = "100%", height = "9vh", crossAlign = "center", spacing = "2vh", children = {
          iconTile("sf:wrench.and.screwdriver.fill", { size = "5.6vh", corner = "1.2vh", tint = C.white, background = C.accent }),
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vsName", text = "未选择版本", style = { font = "2.9vh", weight = "bold", color = C.dark } },
            ui.text { id = "vsMeta", text = "版本独立设置 · 与全局设置互不影响", style = { font = "2.1vh", color = C.mid } },
          } },
          actionButton("vsOpenDir", "游戏目录", false),
        } },
      }, { width = "94%" }),
      ui.row { id = "vsCatRow", width = "94%", spacing = "1.2vh", crossAlign = "center", children = chips },
      ui.column { id = "vsSections", width = "100%", spacing = DIM.cardSpace, crossAlign = "center", children = sections },
      statusBar("vsStatusBar", "vsStatus", "修改会写入当前版本的独立配置。", "94%"),
    } }
end

-- ============ 实例列表页（versionManager）============
local function buildVersionManagerPage()
  local kids = {
    ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
      ui.text { text = CONFIG.versionManager.title, weight = 1,
        style = { font = "2.9vh", weight = "bold", color = C.accent } },
      actionButton("vmAdd", "添加", true, CONFIG.versionManager.addAction),
    } },
  }
  for i = 1, 5 do
    kids[#kids + 1] = listRow {
      id = "vmSlot_" .. i, action = "vmSlot_" .. i, icon = "sf:cube.fill", tint = C.accent,
      title = "· · ·", titleId = "vmSlot_" .. i .. "_name",
      sub = "", subId = "vmSlot_" .. i .. "_meta", visible = false,
    }
  end
  kids[#kids + 1] = ui.text { id = "vmEmpty", text = CONFIG.versionManager.emptyText,
    style = { font = "2.2vh", color = C.mid } }
  return ui.column { id = "pageVersionManager", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = { card("vmCard", kids, { width = "94%" }) } }
end

-- ============ 账号管理页 ============
local function buildAccountManagerPage()
  local kids = {
    ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
      ui.text { text = CONFIG.accountManager.title, weight = 1,
        style = { font = "2.9vh", weight = "bold", color = C.accent } },
      actionButton("amAdd", "添加", true, CONFIG.accountManager.addAction),
    } },
  }
  for i = 1, 4 do
    kids[#kids + 1] = ui.row { id = "amSlot_" .. i, action = "amSlot_" .. i, width = "100%", height = "7.5vh",
      crossAlign = "center", spacing = "1.5vh", padding = { left = "1.2vh", right = "1.2vh" },
      corner = "1vh", hoverColor = C.hover, visible = false, children = {
        iconTile("sf:person.crop.circle.fill", { size = "4.6vh", corner = "pill", background = C.avatarBg }),
        ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
          ui.text { id = "amSlot_" .. i .. "_name", text = "· · ·", style = { font = "2.5vh", color = C.dark } },
          ui.text { id = "amSlot_" .. i .. "_meta", text = "", style = { font = "1.9vh", color = C.mid } },
        } },
        ui.text { id = "amSlot_" .. i .. "_tag", text = "", style = { font = "2.2vh", color = C.accent } },
      } }
  end
  kids[#kids + 1] = ui.text { id = "amEmpty", text = CONFIG.accountManager.emptyText,
    style = { font = "2.2vh", color = C.mid } }
  return ui.column { id = "pageAccountManager", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = { card("amCard", kids, { width = "94%" }) } }
end

-- ============ 游戏目录页 ============
local function buildGameDirectoryPage()
  local kids = {
    ui.text { text = CONFIG.gameDirectory.title, width = "100%",
      style = { font = "2.9vh", weight = "bold", color = C.accent } },
    ui.row { width = "100%", height = "6vh", crossAlign = "center", spacing = "1.2vh", children = {
      ui.input { id = "gdNameIn", weight = 1, height = DIM.inputH, placeholder = CONFIG.gameDirectory.addPlaceholder,
        corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
      actionButton("gdCreate", "新建", true),
    } },
  }
  for i = 1, 4 do
    kids[#kids + 1] = listRow {
      id = "gd_" .. i, action = "gd_" .. i, icon = "sf:folder.fill", tint = C.orange,
      title = "· · ·", titleId = "gd_" .. i .. "_name",
      sub = "游戏目录", subId = "gd_" .. i .. "_sub",
      valueId = "gd_" .. i .. "_tag", value = "",
    }
  end
  kids[#kids + 1] = ui.text { id = "gdEmpty", text = CONFIG.gameDirectory.emptyText,
    style = { font = "2.2vh", color = C.mid } }
  return ui.column { id = "pageGameDirectory", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = { card("gdCard", kids, { width = "94%" }) } }
end

-- ============ 实例详情页 ============
local function buildVersionDetailPage()
  local loaderBtns = {}
  for li, lname in ipairs(CONFIG.download.loaders) do
    loaderBtns[#loaderBtns + 1] = ui.row { id = "vdL_" .. li, action = "vdL_" .. li, corner = DIM.cardRadius, height = "5.6vh",
      crossAlign = "center", justify = "center",
      padding = { left = "2.4vh", right = "2.4vh", top = "0.6vh", bottom = "0.6vh" },
      background = (li == 1) and C.faintBlue or C.card,
      border = (li == 1) and BORDER_A or BORDER, hoverColor = C.hover,
      children = { ui.text { id = "vdL_" .. li .. "_t", text = lname,
        style = { font = "2.3vh", color = C.dark } } } }
  end
  return ui.column { id = "pageVersionDetail", weight = 1, crossAlign = "center",
    padding = DIM.pagePad, spacing = DIM.cardSpace, children = {
      card("vdCard", {
        ui.text { text = CONFIG.detail.title, width = "100%",
          style = { font = "2.9vh", weight = "bold", color = C.accent } },
        ui.row { width = "100%", height = "10vh", crossAlign = "center", spacing = "2vh", children = {
          iconTile("sf:cube.fill", { size = "6.6vh", corner = "1.4vh", tint = C.white, background = C.accent }),
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vdVersion", text = "未选择版本", style = { font = "2.9vh", weight = "bold", color = C.dark } },
            ui.text { id = "vdType", text = "原版 · 未安装", style = { font = "2.2vh", color = C.mid } },
          } },
        } },
        ui.text { text = "模组加载器", width = "100%", style = { font = "2.2vh", weight = "bold", color = C.dark } },
        ui.row { id = "vdLoaderRow", width = "100%", spacing = "1.2vh", crossAlign = "center", children = loaderBtns },
        ui.divider { height = "0.08vh", background = C.cardBorder },
        ui.row { width = "100%", justify = "end", children = {
          ui.row { id = "vdInstall", action = "vdInstall", corner = DIM.cardRadius,
            padding = { left = "3.4vh", right = "3.4vh", top = "1vh", bottom = "1vh" },
            background = C.accent, hoverColor = C.accentBorder, children = {
              ui.text { text = "下载并安装", style = { font = "2.5vh", weight = "bold", color = C.white } },
            } },
        } },
      }, { width = "94%", spacing = "1.4vh" }),
    } }
end

-- ============ 顶栏 / 左栏 / 壳 ============
local function buildTopbar()
  local function winBtn(id, icon)
    return ui.row { id = id, width = "4.4vh", height = "4.4vh", corner = "1vh",
      crossAlign = "center", justify = "center", hoverColor = C.accent, children = {
        ui.image { icon = icon, size = "2.4vh", style = { tint = C.white } },
      } }
  end
  return ui.row { id = "titlebar", height = DIM.bar, background = C.topbar, crossAlign = "center",
    spacing = "1vh", padding = { left = "1.6vh", right = "1.2vh" }, children = {
      ui.row { id = "barBack", action = "open:home", width = "4.4vh", height = "4.4vh",
        corner = "1vh", crossAlign = "center", justify = "center", visible = false, hoverColor = C.accent, children = {
          ui.image { icon = "sf:chevron.left", size = "2.6vh", style = { tint = C.white } },
        } },
      ui.image { id = "logoIcon", icon = BRAND.icon, size = "3vh", style = { tint = C.white } },
      ui.text { id = "logo", text = BRAND.title, style = { font = "2.9vh", weight = "bold", color = C.white } },
      ui.text { id = "logoSub", text = BRAND.sub, style = { font = "2.1vh", color = C.white } },
      ui.text { id = "barTitle", text = "", visible = false,
        style = { font = "2.7vh", weight = "bold", color = C.white } },
      ui.spacer { weight = 1 },
      winBtn("winHelp", "sf:questionmark.circle"),
      winBtn("winMin", "sf:minus"),
      winBtn("winClose", "sf:xmark"),
    } }
end

local function buildRail()
  local kids = {}
  for _, sec in ipairs(RAIL_SECTIONS) do
    if sec.name then
      kids[#kids + 1] = ui.row { width = "100%", crossAlign = "center", spacing = "0.8vh",
        padding = { left = "1.2vh", right = "1.2vh", top = "1.2vh", bottom = "0.4vh" }, children = {
          ui.text { text = sec.name, style = { font = "1.8vh", weight = "bold", color = C.mid } },
          ui.row { weight = 1, height = "0.08vh", background = C.border, children = {} },
        } }
    end
    for _, r in ipairs(sec.items) do kids[#kids + 1] = railItem(r) end
  end
  kids[#kids + 1] = ui.spacer { weight = 1 }
  return kids
end

function build(ui)
  local contentChildren = {
    buildHomePage(),
    buildDownloadPage(),
    buildMultiPage(),
    buildSettingsPage(),
    buildMorePage(),
    buildVersionSettingsPage(),
    buildVersionManagerPage(),
    buildAccountManagerPage(),
    buildGameDirectoryPage(),
    buildVersionDetailPage(),
  }
  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0, children = {
      buildTopbar(),
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0, children = {
        ui.column { id = "rail", width = DIM.rail, background = C.card, crossAlign = "stretch",
          spacing = "0.4vh", padding = { left = "1.2vh", right = "1.2vh", top = "1.2vh", bottom = "1.2vh" },
          children = buildRail() },
        ui.content {
          id = "content", weight = 1, initialPage = "home",
          background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
          pages = CONFIG.pages, children = contentChildren,
        },
      } },
    },
  }
end

-- ===== 交互 =====
local currentPage = "home"
local mpBranch = 1
local setToggleState = {}
local setSelectIdx = {}
local setRadio = {}

local function pushStatus(msg)
  if launcher.view("setStatus") then launcher.view("setStatus"):setText(msg) end
  if launcher.view("vsStatus") then launcher.view("vsStatus"):setText(msg) end
end

local function refreshAccount()
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) or ""
  local kind = (type(acc) == "table" and (acc.type or acc.kind)) or ""
  if launcher.view("accountName") then launcher.view("accountName"):setText(name ~= "" and name or "未登录") end
  if launcher.view("accountType") then launcher.view("accountType"):setText(kind ~= "" and kind or "离线账号") end
  if launcher.view("navAccount_label") then
    launcher.view("navAccount_label"):setText(name ~= "" and name or NAV_ACCOUNT.fallbackName)
  end
  if launcher.view("navAccount_sub") then
    launcher.view("navAccount_sub"):setText(kind ~= "" and kind or NAV_ACCOUNT.fallbackSub)
  end
end

local function refreshVersion()
  local ver = launcher.state and launcher.state.version
  local name = (type(ver) == "table" and ver.name) or ""
  local label = (name ~= "" and name) or "未选择版本"
  if launcher.view("panelVersion") then launcher.view("panelVersion"):setText(label) end
  if launcher.view("navHome_sub") then launcher.view("navHome_sub"):setText(label) end
  if launcher.view("vdVersion") then launcher.view("vdVersion"):setText(name ~= "" and name or "未选择版本") end
  if launcher.view("vsName") then launcher.view("vsName"):setText(name ~= "" and name or "未选择版本") end
end

local function refreshVersionSettings()
  for _, cat in ipairs(CONFIG.vs_categories) do
    local chip = launcher.view("vsCat_" .. cat.token)
    if chip then
      chip:setStyle((cat.token == vsSelCat)
        and { background = C.card, borderColor = C.accentBorder }
        or  { background = C.card, borderColor = C.cardBorder })
    end
    local sec = launcher.view("vsSec_" .. cat.token)
    if sec then sec:setVisible(cat.token == vsSelCat) end
  end
end

local function refreshMoreContent()
  local st = launcher.getState and launcher.getState() or {}
  local sui = (type(st.ui) == "table") and st.ui or nil
  if launcher.view("moreThemeName_text") and sui and sui.name and sui.name ~= "" then
    launcher.view("moreThemeName_text"):setText(sui.name)
  end
  if launcher.view("moreThemeVersion") and sui and sui.version and sui.version ~= "" then
    launcher.view("moreThemeVersion"):setText(sui.version)
  end
  local vi = (type(st.version) == "table" and st.version.name) or ""
  if launcher.view("moreDefaultVersion_val") then
    launcher.view("moreDefaultVersion_val"):setText(vi ~= "" and vi or "未选择")
  end
end

local function refreshVersionManager()
  local st = launcher.getState and launcher.getState() or {}
  local items = (type(st) == "table" and type(st.versions) == "table") and st.versions or {}
  for i = 1, 5 do
    local slot = launcher.view("vmSlot_" .. i)
    if slot then
      local it = items[i]
      if it then
        slot:setVisible(true)
        if launcher.view("vmSlot_" .. i .. "_name") then
          launcher.view("vmSlot_" .. i .. "_name"):setText(it.name or it.id or "未命名")
        end
        if launcher.view("vmSlot_" .. i .. "_meta") then
          launcher.view("vmSlot_" .. i .. "_meta"):setText(it.type or "已安装")
        end
      else
        slot:setVisible(false)
      end
    end
  end
  if launcher.view("vmEmpty") then launcher.view("vmEmpty"):setVisible(#items == 0) end
end

local function refreshAccountManager()
  local st = launcher.getState and launcher.getState() or {}
  local items = (type(st) == "table" and type(st.accounts) == "table") and st.accounts or nil
  if not items then
    local acc = launcher.state and launcher.state.account
    if type(acc) == "table" and acc.name then items = { acc } else items = {} end
  end
  for i = 1, 4 do
    local slot = launcher.view("amSlot_" .. i)
    if slot then
      local it = items[i]
      if it then
        slot:setVisible(true)
        if launcher.view("amSlot_" .. i .. "_name") then
          launcher.view("amSlot_" .. i .. "_name"):setText(it.name or "未命名账号")
        end
        if launcher.view("amSlot_" .. i .. "_meta") then
          launcher.view("amSlot_" .. i .. "_meta"):setText((it.type or it.kind or "离线") .. " 账号")
        end
        if launcher.view("amSlot_" .. i .. "_tag") then
          launcher.view("amSlot_" .. i .. "_tag"):setText(it.selected and "使用中" or "切换")
        end
      else
        slot:setVisible(false)
      end
    end
  end
  if launcher.view("amEmpty") then launcher.view("amEmpty"):setVisible(#items == 0) end
end

local function refreshGameDirectory()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for i = 1, 4 do
    local slot = launcher.view("gd_" .. i)
    if slot then
      local it = items[i]
      if it then
        slot:setVisible(true)
        if launcher.view("gd_" .. i .. "_name") then
          launcher.view("gd_" .. i .. "_name"):setText(it.name or "游戏目录")
        end
        if launcher.view("gd_" .. i .. "_sub") then
          launcher.view("gd_" .. i .. "_sub"):setText(it.path or "游戏目录")
        end
        if launcher.view("gd_" .. i .. "_tag") then
          launcher.view("gd_" .. i .. "_tag"):setText(it.selected and "使用中" or "")
        end
      else
        slot:setVisible(false)
      end
    end
  end
  if launcher.view("gdEmpty") then launcher.view("gdEmpty"):setVisible(#items == 0) end
end

-- 设置项行为（供带后缀的控件与整行点击共用）
local function applyToggle(key)
  local on = not (setToggleState[key] == true)
  setToggleState[key] = on
  local sw = launcher.view("set_" .. key .. "_sw")
  if sw then sw:setStyle({ background = on and C.success or C.fieldBorder }) end
  local knob = launcher.view("set_" .. key .. "_knob")
  if knob then knob:setStyle({ background = on and C.white or C.card }) end
end

local function cycleSelect(key)
  local row = SET_ROWS[key]
  local opts = (row and row.options) or {}
  if #opts == 0 then return end
  local i = (setSelectIdx[key] or 1) + 1
  if i > #opts then i = 1 end
  setSelectIdx[key] = i
  local v = launcher.view("set_" .. key .. "_val")
  if v then v:setText(opts[i]) end
end

local function refreshRadio(key)
  local row = SET_ROWS[key]
  local opts = (row and row.options) or {}
  local cur = setRadio[key] or 1
  for i = 1, #opts do
    local dot = launcher.view("set_" .. key .. "_dot" .. i)
    if dot then
      dot:setImage(i == cur and "sf:largecircle.fill.circle" or "sf:circle")
      dot:setStyle({ tint = (i == cur) and C.accent or C.mid })
    end
  end
end

function onReady()
  refreshAccount()
  refreshVersion()
  onPageChange(currentPage)
end

function onLayout() end

function onAccountChange(account)
  if type(account) ~= "table" then return end
  if launcher.view("accountName") then launcher.view("accountName"):setText(account.name or "未登录") end
  local kind = account.type or account.kind or "离线"
  if launcher.view("accountType") then launcher.view("accountType"):setText(kind .. " 账号") end
  if launcher.view("navAccount_label") then launcher.view("navAccount_label"):setText(account.name or NAV_ACCOUNT.fallbackName) end
  if launcher.view("navAccount_sub") then launcher.view("navAccount_sub"):setText(kind) end
end

function onMultiplayerRooms(payload) end

function onMultiplayerStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "联机状态已更新"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
end

function onMultiplayerProgress(payload)
  local msg = (type(payload) == "table" and payload.message) or "连接中…"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
end

function onDownloadUpdate(payload)
  local p = payload or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  updateBar("dlBarTrack", "dlBarFill", pct)
  if launcher.view("dlProgressLabel") then
    launcher.view("dlProgressLabel"):setText(p.finished and ("安装完成（" .. pct .. "%）") or ("下载中 " .. pct .. "%…"))
  end
  if launcher.view("dlProgress") then launcher.view("dlProgress"):setVisible(true) end
end

function onRemoteVersions(payload)
  refreshDownloadVersions()
end

function onCommunityResults(payload)
  dlCommItems = {}
  for _, it in ipairs((type(payload) == "table" and payload.items) or {}) do
    dlCommItems[#dlCommItems + 1] = it
  end
  for i = 1, CONFIG.download.communitySlots do
    local row = launcher.view("dlComm_" .. i)
    if row then
      local it = dlCommItems[i]
      if it then
        row:setVisible(true)
        if launcher.view("dlComm_" .. i .. "_title") then
          launcher.view("dlComm_" .. i .. "_title"):setText(it.title or "未知资源")
        end
        if launcher.view("dlComm_" .. i .. "_meta") then
          local author = it.author or ""
          local dls = tostring(it.downloads or 0)
          launcher.view("dlComm_" .. i .. "_meta"):setText((author ~= "" and (author .. " · ") or "") .. "下载 " .. dls)
        end
      else
        row:setVisible(false)
      end
    end
  end
  if launcher.view("dlCommStatus") then
    launcher.view("dlCommStatus"):setText(#dlCommItems == 0 and "未找到相关资源。"
      or ("找到 " .. #dlCommItems .. " 条结果，点击条目可下载最新版本。"))
  end
end

function onCommunityStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "状态已更新"
  if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText(msg) end
end

function onCommunityProgress(payload) end

function onCommunityKeyword(payload) end

function onLaunchFinished(payload)
  refreshVersion()
end

function onOpenSubpage(token)
  if CONFIG.pages[token] and launcher.action then launcher.action("open:" .. token) end
end

function onPageChange(page)
  currentPage = page

  -- 顶栏：首页=品牌（图标+标题+版本）；子页=← 返回 + 页面标题
  local isHome = (page == "home")
  if launcher.view("barBack") then launcher.view("barBack"):setVisible(not isHome) end
  if launcher.view("logoIcon") then launcher.view("logoIcon"):setVisible(isHome) end
  if launcher.view("logo") then launcher.view("logo"):setVisible(isHome) end
  if launcher.view("logoSub") then launcher.view("logoSub"):setVisible(isHome) end
  if launcher.view("barTitle") then
    launcher.view("barTitle"):setVisible(not isHome)
    launcher.view("barTitle"):setText((not isHome) and (CONFIG.pageTitles[page] or "") or "")
  end

  -- 左栏选中态：白色悬浮卡片
  local railId = PAGE_RAIL[page]
  for _, r in ipairs(RAIL) do
    local sel = (r.id == railId)
    local rv = launcher.view(r.id)
    if rv then
      rv:setStyle({ background = sel and C.card or C.transparent,
        borderColor = sel and C.cardBorder or C.transparent })
    end
    local iv = launcher.view(r.id .. "_ico")
    if iv then iv:setStyle({ tint = sel and C.accent or C.mid }) end
  end

  if page == "download" then
    dlLevel = "groups"
    refreshDownloadVersions()
    refreshDownloadState()
    refreshLoaderCards()
  elseif page == "version_settings" then
    refreshVersionSettings()
  elseif page == "more" then
    refreshMoreContent()
  elseif page == "versionManager" then
    refreshVersionManager()
  elseif page == "accountManager" then
    refreshAccountManager()
  elseif page == "gameDirectory" then
    refreshGameDirectory()
  end

  refreshVersion()
  refreshAccount()
end

function onClick(id)
  id = tostring(id or ""):gsub(":", "_")

  -- 导航栏（顶栏/图标栏 id 兜底）
  for _, r in ipairs(RAIL) do
    if r.id == id then
      if launcher.action then launcher.action(r.action) end
      return
    end
  end

  -- 版本设置分类切换
  local vcat = id:match("^vsCat_(.+)$")
  if vcat then
    vsSelCat = vcat
    refreshVersionSettings()
    return
  end

  -- 安装向导：加载器选择
  local ldr = id:match("^insLdr_(%d+)$")
  if ldr then
    loaderSel = tonumber(ldr) or 1
    refreshLoaderCards()
    return
  end

  -- 下载：安装
  if id == "insStart" then
    local name = (launcher.view("insNameIn") and launcher.view("insNameIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if not PLC.mc or PLC.mc == "" then
      if launcher.view("dlProgressLabel") then launcher.view("dlProgressLabel"):setText("请先选择 Minecraft 版本") end
      if launcher.view("dlProgress") then launcher.view("dlProgress"):setVisible(true) end
      return
    end
    launcher.service("download", "start", { versionId = PLC.mc, name = name })
    if launcher.view("dlProgress") then launcher.view("dlProgress"):setVisible(true) end
    if launcher.view("dlProgressLabel") then
      launcher.view("dlProgressLabel"):setText("准备下载 " .. PLC.mc .. (name ~= "" and ("（" .. name .. "）") or "") .. " …")
    end
    return
  end
  if id == "dlBackGrp" then
    dlLevel = "groups"
    refreshDownloadState()
    return
  end
  if id == "dlMcToggle" then
    refreshDownloadVersions()
    return
  end

  -- 下载：版本分组展开 / 具体版本选择
  local dgh = id:match("^dlGh_(.+)$")
  if dgh then
    dlOpenGroup[dgh] = not (dlOpenGroup[dgh] == true)
    refreshDownloadGroups()
    return
  end
  local dgGroup, dgIndex = id:match("^dlGrpVer_(.+)_(%d+)$")
  if dgGroup then
    local it = (dlGroups[dgGroup] or {})[tonumber(dgIndex)]
    if it and it.id then
      PLC.mc = it.id
      dlLevel = "install"
      refreshInstallPanel()
      refreshDownloadState()
      if launcher.view("dlMcVersion") then launcher.view("dlMcVersion"):setText(it.id) end
    end
    return
  end

  -- 下载：组件卡展开 / 组件版本
  local cph = id:match("^dlCompH_(%d+)$")
  if cph then
    local i = tonumber(cph)
    compOpen[i] = not (compOpen[i] == true)
    local list = launcher.view("dlCompList_" .. i)
    if list then list:setVisible(compOpen[i] == true) end
    for j = 1, CONFIG.download.componentRows do
      local v = launcher.view("dlCompV_" .. i .. "_" .. j)
      if v then v:setVisible(compOpen[i] == true) end
    end
    return
  end
  local cpIndex = id:match("^dlCompV_(%d+)_(%d+)$")
  if cpIndex then
    local i = tonumber(cpIndex)
    compSel[i] = true
    refreshInstallPanel()
    return
  end

  -- 下载：社区资源
  if id == "dlCommSearch" then
    launcher.service("community", "search", { keyword = "minecraft", object = "mod" })
    if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText("正在搜索…") end
    return
  end
  if id == "dlCommKeyword" then
    launcher.service("community", "promptKeyword", { object = "mod" })
    return
  end
  local dim = id:match("^dlComm_(%d+)$")
  if dim then
    local it = dlCommItems[tonumber(dim)]
    if it and it.id then
      launcher.service("community", "download", { id = it.id })
    end
    return
  end

  -- 联机
  if id == "mpCreate" then launcher.service("multiplayer", "promptCreate", {}) return end
  if id == "mpJoin" then launcher.service("multiplayer", "promptJoin", {}) return end
  local segm = id:match("^segM_(%d+)$")
  if segm then
    mpBranch = tonumber(segm) or 1
    for i = 1, #CONFIG.multi.branches do
      local b = launcher.view("segM_" .. i)
      local sel = (i == mpBranch)
      if b then
        b:setStyle(sel and { background = C.faintBlue, borderColor = C.accentBorder }
          or { background = C.card, borderColor = C.cardBorder })
      end
    end
    if launcher.view("mpStatus") then
      launcher.view("mpStatus"):setText("已切换到「" .. (CONFIG.multi.branches[mpBranch] or "局域网") .. "」模式。")
    end
    return
  end

  -- 设置：单选列表
  local rkey, ridx = id:match("^set_(.+)_opt(%d+)$")
  if rkey and SET_ROWS[rkey] then
    setRadio[rkey] = tonumber(ridx) or 1
    refreshRadio(rkey)
    return
  end

  -- 设置：toggle / select / button（onClick 剥后缀匹配，整行亦可点）
  local ssw = id:match("^set_(.+)_sw$")
  if ssw and SET_ROWS[ssw] then applyToggle(ssw) return end
  local ssel = id:match("^set_(.+)_v$")
  if ssel and SET_ROWS[ssel] then cycleSelect(ssel) return end
  local sbt = id:match("^set_(.+)_btn$")
  if sbt and SET_ROWS[sbt] then pushStatus("已执行：" .. (SET_ROWS[sbt].label or sbt)) return end
  local skey = id:match("^set_(.+)$")
  if skey and SET_ROWS[skey] then
    local srow = SET_ROWS[skey]
    if srow.type == "toggle" then
      applyToggle(skey)
    elseif srow.type == "select" then
      cycleSelect(skey)
    else
      pushStatus("已执行：" .. (srow.label or skey))
    end
    return
  end

  -- 版本设置：打开目录
  if id == "vsOpenDir" then
    if launcher.action then launcher.action("open:gameDirectory") end
    return
  end

  -- 实例列表 / 账号 / 目录 槽位
  local vms = id:match("^vmSlot_(%d+)$")
  if vms then
    if launcher.action then launcher.action("open_subpage:versionDetail") end
    return
  end
  local ams = id:match("^amSlot_(%d+)$")
  if ams then
    pushStatus("已选择账号槽位 " .. ams)
    return
  end
  local gds = id:match("^gd_(%d+)$")
  if gds then
    pushStatus("已选择游戏目录 " .. gds)
    return
  end
  if id == "gdCreate" then
    local name = (launcher.view("gdNameIn") and launcher.view("gdNameIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then
      pushStatus("请输入新目录名称。")
      return
    end
    if launcher.service then launcher.service("gameDir", "create", { name = name }) end
    pushStatus("已创建游戏目录：" .. name)
    refreshGameDirectory()
    return
  end

  -- 实例详情：加载器切换 / 安装
  local vdl = id:match("^vdL_(%d+)$")
  if vdl then
    local sel = tonumber(vdl) or 1
    for li, _ in ipairs(CONFIG.download.loaders) do
      local b = launcher.view("vdL_" .. li)
      local on = (li == sel)
      if b then
        b:setStyle(on and { background = C.faintBlue, borderColor = C.accentBorder }
          or { background = C.card, borderColor = C.cardBorder })
      end
    end
    return
  end
  if id == "vdInstall" then
    if PLC.mc and PLC.mc ~= "" then
      launcher.service("download", "start", { versionId = PLC.mc })
    end
    if launcher.action then launcher.action("open:download") end
    return
  end
end