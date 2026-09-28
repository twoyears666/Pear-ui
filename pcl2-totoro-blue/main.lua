-- Pear 启动器 · 仿 PCL 浅色 UI 包 —— 结构对齐真实 PCL2（PCL-CE）
--
-- 页面（顶栏 4 页签，无独立「联机」页签）：启动 / 下载 / 设置 / 更多
--   版本设置页由启动页「版本设置」按钮进入（token = version_settings）。
--
-- 契约（引擎通用，零特例）：
--   主题：仿 PCL 浅色——蓝顶栏 topbar、内容区浅蓝灰渐变、白卡、深色字；禁止深色/透明兜底。
--   尺寸：纵向按窗口高 1H 比例（vh = 0.01H）；横向用 %（内容区左右各留 ≈3%）。
--   布局：容器语义 split_column≈row、vertical_flow≈column、card≈白底圆角卡、row_item≈整行条目。
--   颜色：全部走 colors.json 令牌（$color:*），不新增令牌、不硬编码。
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：CONFIG.pages 的 token → 内容区页节点 id。

function describe()
  return { name = "PCL 浅色", version = "1.25.0-beta" }
end

local C = {
  topbar      = "$color:topbar",
  topbarFrom  = "$color:topbarFrom",
  topbarTo    = "$color:topbarTo",
  pageFrom    = "$color:pageFrom",
  pageTo      = "$color:pageTo",
  card        = "$color:card",
  cardBorder  = "$color:cardBorder",
  dark        = "$color:cardText",
  mid         = "$color:subText",
  white       = "$color:white",
  transparent = "$color:transparent",
  accent      = "$color:accent",
  accentBorder = "$color:accentBorder",
  hover       = "$color:hover",
  avatarBg    = "$color:avatarBg",
  avatarLine  = "$color:avatarLine",
  success     = "$color:success",
  danger      = "$color:danger",
  orange      = "$color:brandOrange",
  green       = "$color:brandGreen",
  purple      = "$color:brandPurple",
  cyan        = "$color:brandCyan",
  pink        = "$color:brandPink",
  hintBg      = "$color:faintBlue",
  faintBlue   = "$color:faintBlue",
  fieldBorder = "$color:fieldBorder",
}

local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local BORDER_D = { width = "0.18vh", color = C.danger }
local SHADOW   = { blur = "0.3vh", opacity = 0.07, x = 0, y = "0.15vh" }

local SECTION_W = "94%" -- 内容区左右各留 3%

-- 顶栏 4 页签（真实 PCL2：启动 / 下载 / 设置 / 更多）
local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",             action = "open:home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill", action = "open:download" },
  { id = "tab.settings", label = "设置", icon = "sf:gearshape.fill",         action = "open:settings" },
  { id = "tab.more",     label = "更多", icon = "sf:ellipsis.circle.fill",   action = "open:more" },
}
local PAGE_TAB = {
  home = "tab.home", download = "tab.download", settings = "tab.settings",
  more = "tab.more", version_settings = "tab.home",
}

local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", settings = "pageSettings",
    more = "pageMore", version_settings = "pageVersionSettings",
  },
  home = { versionSlots = 8 },
  download = {
    -- 左栏 3 组：游戏 / 社区资源 / 安装
    sidebarGroups = {
      { name = "游戏", items = {
        { id = "Download.Left.Minecraft", label = "原版游戏", icon = "sf:cube.fill", kind = "mc", key = "vanilla" },
      } },
      { name = "社区资源", items = {
        { id = "dlCat_mod",          label = "Mod",     icon = "sf:puzzlepiece.extension.fill", kind = "comm",  key = "mod" },
        { id = "dlCat_modpack",      label = "整合包",  icon = "sf:shippingbox.fill",            kind = "comm",  key = "modpack" },
        { id = "dlCat_datapack",     label = "数据包",  icon = "sf:doc.text.fill",               kind = "comm",  key = "datapack" },
        { id = "dlCat_resourcepack", label = "资源包",  icon = "sf:photo.fill",                  kind = "comm",  key = "resourcepack" },
        { id = "dlCat_shader",       label = "光影包",  icon = "sf:sun.max.fill",                kind = "comm",  key = "shader" },
        { id = "dlCat_world",        label = "世界",    icon = "sf:globe",                       kind = "empty", key = "world" },
        { id = "dlCat_favorite",     label = "收藏",    icon = "sf:star.fill",                   kind = "empty", key = "favorite" },
      } },
      { name = "安装", items = {
        { id = "dlCat_loader_vanilla",      label = "原版",          icon = "sf:cube.fill",   kind = "loader", key = "vanilla" },
        { id = "dlCat_loader_optifine",     label = "OptiFine",      icon = "sf:bolt.fill",   kind = "loader", key = "optifine" },
        { id = "dlCat_loader_forge",        label = "Forge",         icon = "sf:hammer.fill", kind = "loader", key = "forge" },
        { id = "dlCat_loader_neoforge",     label = "NeoForge",      icon = "sf:hammer.fill", kind = "loader", key = "neoforge" },
        { id = "dlCat_loader_cleanroom",    label = "Cleanroom",     icon = "sf:leaf.fill",   kind = "loader", key = "cleanroom" },
        { id = "dlCat_loader_fabric",       label = "Fabric",        icon = "sf:square.stack.3d.up.fill", kind = "loader", key = "fabric" },
        { id = "dlCat_loader_liteloader",   label = "LiteLoader",    icon = "sf:circle.grid.2x2.fill",    kind = "loader", key = "liteloader" },
        { id = "dlCat_loader_legacyfabric", label = "LegacyFabric",  icon = "sf:square.stack.3d.up.fill", kind = "loader", key = "legacyfabric" },
        { id = "dlCat_loader_labymod",      label = "LabyMod",       icon = "sf:puzzlepiece.fill",        kind = "loader", key = "labymod" },
      } },
    },
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "测试版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
    maxVersionRows = 12,
    communitySlots = 6,
    mcLabel = "Minecraft",
    installHint = "选择版本后点击「开始安装」，引擎将从官方源下载并安装该版本。",
    loaderSuffix = "。引擎当前仅能安装原版 Minecraft，加载器本体需由引擎后续版本或游戏内补充安装。",
    emptyText = {
      world = "引擎暂不支持「世界」下载：未提供世界资源服务，无法在此检索或安装存档世界。",
      favorite = "「收藏」是 PCL 本地收藏夹；引擎暂未提供收藏服务，故此处无内容可展示。",
    },
  },
  -- 设置页：左栏 4 组 11 项
  settings = {
    groups = {
      { name = "游戏", items = {
        { key = "game.launch", label = "启动",     icon = "sf:play.fill" },
        { key = "game.java",   label = "Java",     icon = "sf:cup.and.saucer.fill" },
        { key = "game.manage", label = "游戏管理", icon = "sf:folder.fill" },
      } },
      { name = "工具", items = {
        { key = "tool.multi", label = "游戏联机", icon = "sf:antenna.radiowaves.left.and.right" },
      } },
      { name = "启动器", items = {
        { key = "launcher.ui",   label = "界面", icon = "sf:paintbrush.fill" },
        { key = "launcher.lang", label = "语言", icon = "sf:globe" },
        { key = "launcher.misc", label = "杂项", icon = "sf:slider.horizontal.3" },
      } },
      { name = "关于", items = {
        { key = "about.about",    label = "关于", icon = "sf:info.circle.fill" },
        { key = "about.update",   label = "更新", icon = "sf:arrow.triangle.2.circlepath" },
        { key = "about.feedback", label = "反馈", icon = "sf:exclamationmark.bubble.fill" },
        { key = "about.log",      label = "日志", icon = "sf:doc.text.fill" },
      } },
    },
    launchKeys = { "versionIsolation", "windowTitle", "windowInfo", "serverIp", "loginMode" },
    javaKeys   = { "javaVersion", "ramType", "ram", "ramOptimize" },
    tokenSections = {
      ui   = { "video_settings", "gl_renderer", "ui_theme" },
      misc = { "launcher_settings", "download_mirror", "control_keys", "java_tuning", "ai_assistant" },
    },
  },
  -- 更多页：左栏 2 组
  more = {
    groups = {
      { name = "联机", items = {
        { key = "mp.hall", label = "联机大厅", icon = "sf:antenna.radiowaves.left.and.right" },
      } },
      { name = "工具", items = {
        { key = "tool.test", label = "测试", icon = "sf:wrench.and.screwdriver.fill" },
      } },
    },
  },
  -- 版本设置页：左栏 2 组 11 项
  versions = {
    groups = {
      { name = "游戏", items = {
        { key = "info",    label = "概览", icon = "sf:info.circle.fill" },
        { key = "launch",  label = "设置", icon = "sf:play.fill" },
        { key = "install", label = "安装", icon = "sf:arrow.down.circle.fill" },
        { key = "export",  label = "导出", icon = "sf:square.and.arrow.up" },
      } },
      { name = "资源", items = {
        { key = "saves",      label = "存档",   icon = "sf:folder.fill" },
        { key = "shots",      label = "截图",   icon = "sf:camera.fill" },
        { key = "mods",       label = "Mod",    icon = "sf:puzzlepiece.extension.fill" },
        { key = "rp",         label = "资源包", icon = "sf:photo.fill" },
        { key = "shaders",    label = "光影",   icon = "sf:sun.max.fill" },
        { key = "litematica", label = "投影",   icon = "sf:square.grid.3x3.fill" },
        { key = "servers",    label = "服务器", icon = "sf:server.rack" },
      } },
    },
    slots = 8,
    serverSlots = 6,
  },
  multiplayer = { roomSlots = 6 },
}

-- token → 中文名（引擎 settings.list 的 open_subpage:<token>）
local TOKEN_LABEL = {
  launcher_settings = "启动器设置", download_mirror = "下载镜像策略", video_settings = "视频设置",
  gl_renderer = "MobileGlues 渲染器", control_keys = "自定义控制键", java_tuning = "Java 调整",
  ui_theme = "UI 设置", ai_assistant = "AI 助手",
}

-- 左栏分类表：id → item（onClick 用精确查表）
local DL_CAT = {}
for _, g in ipairs(CONFIG.download.sidebarGroups) do
  for _, it in ipairs(g.items) do DL_CAT[it.id] = it end
end
local function groupKeys(groups)
  local keys = {}
  for _, g in ipairs(groups) do for _, it in ipairs(g.items) do keys[#keys + 1] = it.key end end
  return keys
end
local SET_KEYS  = groupKeys(CONFIG.settings.groups)
local MORE_KEYS = groupKeys(CONFIG.more.groups)
local VS_KEYS   = groupKeys(CONFIG.versions.groups)

-- ===== 通用构件 =====
local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.mid } }
end

-- 白底圆角卡片（横向满宽；由外层 section 提供 3% 边距）
local function card(id, children, opts)
  opts = opts or {}
  return ui.column { id = id, width = opts.width or "100%", background = C.card, border = BORDER,
    corner = opts.corner or "1.2vh", shadow = SHADOW,
    padding = opts.padding or { left = "2.2vh", right = "2.2vh", top = "1.6vh", bottom = "1.6vh" },
    spacing = opts.spacing or "2vh", crossAlign = opts.crossAlign,
    height = opts.height, children = children }
end

-- 内容 section：横向 94%（左右各 3%）
local function section(id, children)
  return ui.column { id = id, width = SECTION_W, crossAlign = "center", spacing = "2vh", children = children }
end

local function hintRow(id, textId, text)
  return ui.row { id = id, width = "100%", background = C.hintBg, corner = "1vh",
    crossAlign = "center", spacing = "1.2vh", padding = "1.4vh", children = {
      ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
      ui.text { id = textId, text = text, weight = 1, style = { font = "2.1vh", color = C.dark } },
    } }
end

local function navRow(id, label, sub, action)
  local kids = {
    ui.text { text = label, weight = 1, style = { font = "2.5vh", color = C.dark } },
  }
  if sub then kids[#kids + 1] = ui.text { text = sub, style = { font = "2.1vh", color = C.mid } } end
  kids[#kids + 1] = chevron()
  return ui.row { id = id, height = "6.5vh", width = "100%", crossAlign = "center", spacing = "1.2vh",
    hoverColor = C.hover, action = action, padding = { left = "1.2vh", right = "1.2vh" }, children = kids }
end

local function plainButton(id, label, accent, action)
  return ui.button { id = id, label = label, height = "5.5vh", weight = 1, background = C.card,
    corner = "0.7vh", border = (accent and BORDER_A or BORDER), action = action,
    style = { font = "2.4vh", tint = C.dark } }
end

local function actionRow(id, labels, actions)
  local kids = {}
  for i, lab in ipairs(labels) do kids[#kids + 1] = plainButton(id .. "_" .. i, lab, false, actions and actions[i]) end
  return ui.row { width = "100%", height = "5.5vh", spacing = "2vh", children = kids }
end

-- 左栏条目：图标 + 标题（+ 可选圆点指示），整行可点
local function sidebarItem(id, icon, label, action)
  local kids = {}
  if icon then
    kids[#kids + 1] = ui.image { id = id .. "Icon", icon = icon, size = "3vh", corner = "pill",
      background = C.faintBlue, style = { tint = C.accent } }
  end
  kids[#kids + 1] = ui.column { weight = 1, crossAlign = "stretch", children = {
    ui.text { id = id .. "Txt", text = label, width = "100%", style = { font = "2.3vh", color = C.dark } },
  } }
  return ui.row { id = id, height = "6vh", width = "100%", background = C.card, corner = "0.9vh",
    hoverColor = C.hover, action = action, crossAlign = "center", spacing = "1vh",
    padding = { left = "1.4vh", right = "1.4vh" }, children = kids }
end

-- 侧栏项选中态（PCL2：选中=主题蓝实底白字）
local function applySidebarSel(id, sel)
  local row = launcher.view(id)
  if row then
    row:setStyle(sel and { background = C.accent, borderColor = C.accentBorder }
      or { background = C.card, borderColor = C.cardBorder })
  end
  local txt = launcher.view(id .. "Txt")
  if txt then txt:setTextColor(sel and C.white or C.dark) end
  local ic = launcher.view(id .. "Icon")
  if ic then ic:setStyle({ background = sel and C.white or C.faintBlue, tint = C.accent }) end
end

local function sidebarFromGroups(prefix, groups)
  local kids = {}
  for _, g in ipairs(groups) do
    kids[#kids + 1] = ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } }
    for _, it in ipairs(g.items) do
      kids[#kids + 1] = sidebarItem(prefix .. it.key, it.icon, it.label, prefix .. it.key)
    end
  end
  return kids
end

local function refreshSidebarGroups(prefix, groups, selKey)
  for _, g in ipairs(groups) do
    for _, it in ipairs(g.items) do applySidebarSel(prefix .. it.key, it.key == selKey) end
  end
end

-- 进度条：track = 底槽 row，fill = 绝对定位填充 column（setStyle 不支持 width）
local function makeBar(trackId, fillId)
  return ui.row { id = trackId, width = "100%", height = "1.6vh", background = C.faintBlue,
    corner = "pill", children = {
      ui.column { id = fillId, absolute = true, width = "0vh", height = "1.6vh",
        background = C.accent, corner = "pill" },
    } }
end
local function updateBar(trackId, fillId, pct)
  pct = tonumber(pct) or 0
  if pct < 0 then pct = 0 elseif pct > 100 then pct = 100 end
  local fr = launcher.view(trackId):getFrame() or {}
  local w = (tonumber(fr.w) or 0) * pct / 100
  local h = tonumber(fr.h) or 0
  if h <= 0 then h = 1.6 end
  launcher.view(fillId):setFrame({ x = 0, y = 0, w = w, h = h })
end

local function topTab(t)
  return ui.button { id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill", padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" } }
end

-- 行内 id 后缀归一化：引擎派发的 onClick 是「节点 id」，剥掉子节点后缀还原到行 id 再分发。
local ID_SUFFIXES = {
  "_status", "_title", "_date", "_name", "_meta", "_ico", "_btn", "_sw", "_v",
  "Title", "Sub", "Name", "Meta", "Val", "Txt", "Icon", "Text",
}
local function baseId(id)
  if type(id) ~= "string" then return id end
  for _, sfx in ipairs(ID_SUFFIXES) do
    if #id > #sfx and id:sub(-#sfx) == sfx then return id:sub(1, #id - #sfx) end
  end
  return id
end

-- ===== 版本独立设置：标签 / 可选值 =====
local VS_LABELS = {
  versionIsolation = "默认版本隔离", windowTitle = "游戏窗口标题", windowInfo = "自定义信息",
  javaVersion = "游戏 Java", ramType = "内存分配", ram = "内存大小", ramOptimize = "启动前内存优化",
  serverIp = "服务器地址", loginMode = "登录模式",
}
local VS_OPTIONS = {
  versionIsolation = { "true", "false" },
  loginMode        = { "正版登录", "离线登录", "第三方登录" },
  javaVersion      = { "自动选择", "Java 8", "Java 17", "Java 21" },
  ramType          = { "自动配置", "全局", "自定义" },
  ram              = { "1024", "2048", "4096", "8192" },
  ramOptimize      = { "true", "false" },
}
local function vsRow(prefix, key)
  return ui.row { id = prefix .. key, action = prefix .. key, height = "6.5vh", width = "100%",
    crossAlign = "center", spacing = "1.5vh", hoverColor = C.hover,
    padding = { left = "1.2vh", right = "1.2vh" }, children = {
      ui.text { text = VS_LABELS[key] or key, weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = prefix .. key .. "Val", text = "···", style = { font = "2.3vh", color = C.mid } },
      ui.text { text = " ▾", style = { font = "2.3vh", color = C.mid } },
    } }
end
local function vsItemsByKey()
  local resp = launcher.service and launcher.service("versionSettings", "list", {}) or nil
  local map = {}
  if type(resp) == "table" and resp.ok and type(resp.items) == "table" then
    for _, it in ipairs(resp.items) do if it.key then map[it.key] = it.value end end
  end
  return map
end
local function refreshVSInto(prefix, keys, map)
  for _, k in ipairs(keys) do
    local v = launcher.view(prefix .. k .. "Val")
    if v then v:setText(tostring(map[k] or "···")) end
  end
end

-- ===== 运行时状态 =====
local currentPage = "home"
local setSelCat = SET_KEYS[1]
local moreSelCat = MORE_KEYS[1]
local vsSelCat = VS_KEYS[1]
local dlSelId = "Download.Left.Minecraft"
local dlLevel = "groups"
local PLC = { mc = "", mcOpen = false }
local dlGroups, dlOpenGroup, dlGroupAppended, flatVersions = {}, {}, {}, {}
local dlSources = { { id = "modrinth", name = "Modrinth" } }
local dlSourceIdx = 1
local dlKeyword = ""
local dlCommItems = {}
local commDownloading = false
local homeItems = {}
local langIdx = 1
local LANGS = { "简体中文", "English", "日本語" }
local selectedCap = 3
local CAPS = { "mojang", "microsoft", "offline" }
local CAPS_LABEL = { "Mojang", "微软", "离线" }

-- ===== 启动页 =====
local function setHomeStatus(msg)
  local v = launcher.view("Launch.Status.Text")
  if v then v:setText(msg) end
end

local function refreshAccount()
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  if launcher.view("accountName") then launcher.view("accountName"):setText(name) end
end

local function refreshVersionText()
  local ver = launcher.state and launcher.state.version
  local name = (ver and ver.name) or "尚未选择版本"
  if launcher.view("launchSub") then launcher.view("launchSub"):setText(name) end
  if launcher.view("Launch.Home.VersionList") then end
end

local function refreshHomeVersionList()
  local resp = launcher.service and launcher.service("version", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  homeItems = items
  local n = CONFIG.home.versionSlots
  for i = 1, n do
    local it = items[i]
    local row = launcher.view("HomeVer_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("HomeVer_" .. i .. "_name"):setText(it.id or "")
        launcher.view("HomeVer_" .. i .. "_meta"):setText((it.selected == true) and "当前使用" or tostring(it.type or "custom"))
      end
    end
  end
end

local function selectHomeVersion(i)
  local it = homeItems[i]
  if it and it.id then
    launcher.service("version", "select", { id = it.id })
    setHomeStatus("已切换版本：" .. tostring(it.id))
    refreshHomeVersionList()
    refreshVersionText()
  end
end

local function selectCap(idx)
  selectedCap = idx
  for i, key in ipairs(CAPS) do
    local sel = (i == idx)
    launcher.view("cap." .. key):setStyle(sel
      and { background = C.accent, tint = C.white, borderWidth = 1.5, borderColor = C.accent }
      or { background = C.card, tint = C.accent, borderWidth = 1.5, borderColor = C.accent })
  end
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  if launcher.view("accountName") then launcher.view("accountName"):setText(name) end
  if launcher.view("accountType") then launcher.view("accountType"):setText(CAPS_LABEL[idx]) end
end

local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  kids[#kids + 1] = ui.row { id = "capsules", width = "90%", height = "4vh", spacing = "1vh", children = {
    ui.button { id = "cap.mojang", label = "Mojang", height = "4vh", weight = 1, corner = "pill",
      action = "cap.mojang", hoverColor = C.hover, style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
    ui.button { id = "cap.microsoft", label = "微软", height = "4vh", weight = 1, corner = "pill",
      action = "cap.microsoft", hoverColor = C.hover, style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
    ui.button { id = "cap.offline", label = "离线", height = "4vh", weight = 1, corner = "pill",
      action = "cap.offline", hoverColor = C.hover, style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
  } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  kids[#kids + 1] = ui.column { id = "avatarBox", width = "14vh", height = "14vh", corner = "1.2vh",
    background = C.avatarBg, border = BORDER, justify = "center", crossAlign = "center", children = {
      ui.image { id = "avatar", icon = "sf:person.crop.square.fill", size = "9vh",
        background = C.transparent, style = { tint = C.avatarLine } },
    } }
  kids[#kids + 1] = ui.spacer { height = "1.2vh" }
  kids[#kids + 1] = ui.text { id = "accountName", text = "未登录", width = "90%",
    style = { font = "2.4vh", weight = "bold", color = C.dark } }
  kids[#kids + 1] = ui.text { id = "accountType", text = "点击登录账号", width = "90%",
    style = { font = "2vh", color = C.mid } }
  kids[#kids + 1] = ui.spacer { height = "1.4vh" }
  kids[#kids + 1] = ui.button { id = "Launch.Home.Account.Login", label = "登录 / 管理账号", width = "90%", height = "5vh",
    background = C.accent, corner = "0.8vh", action = "Launch.Home.Account.Login",
    style = { font = "2.3vh", weight = "bold", tint = C.white } }
  kids[#kids + 1] = ui.row { id = "homeLinks", width = "90%", height = "4vh", crossAlign = "center", spacing = "1vh", children = {
    ui.button { id = "linkBuy", label = "购买正版", weight = 1, height = "4vh", corner = "pill",
      action = "open:download", hoverColor = C.hover, style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
    ui.button { id = "linkSkin", label = "更换皮肤", weight = 1, height = "4vh", corner = "pill",
      action = "open:home", hoverColor = C.hover, style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
  } }
  kids[#kids + 1] = ui.spacer { weight = 1 }
  -- 启动按钮（Launch.Home.Button.Loading）
  kids[#kids + 1] = ui.column { id = "Launch.Home.Button.Loading", action = "launch", width = "90%", height = "10vh",
    corner = "1.2vh", background = C.card, border = BORDER_A, justify = "center", crossAlign = "center",
    spacing = "0.6vh", hoverColor = C.hover, children = {
      ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3.2vh", weight = "bold", color = C.accent } },
      ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
    } }
  kids[#kids + 1] = ui.spacer { height = "1.2vh" }
  -- 版本选择 / 版本设置
  kids[#kids + 1] = ui.row { id = "versionRow", width = "90%", height = "5.5vh", spacing = "1.2vh", children = {
    ui.button { id = "Launch.Home.SelectInstance", label = "版本选择", action = "Launch.Home.SelectInstance", weight = 1,
      height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
      style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
    ui.button { id = "Launch.Home.InstanceSettings", label = "版本设置", action = "open:version_settings", weight = 1,
      height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
      style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
  } }
  kids[#kids + 1] = ui.spacer { height = "1.2vh" }
  -- 状态卡（Launch.Status.*）
  kids[#kids + 1] = ui.row { id = "Launch.Status", width = "90%", background = C.hintBg, corner = "1vh",
    crossAlign = "center", spacing = "1.2vh", padding = "1.2vh", children = {
      ui.text { id = "Launch.Status.Icon", text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
      ui.text { id = "Launch.Status.Text", text = "就绪，等待启动", weight = 1, style = { font = "2.1vh", color = C.dark } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  return kids
end

local function buildHomePage()
  local slots = {}
  for i = 1, CONFIG.home.versionSlots do
    slots[#slots + 1] = ui.row { id = "HomeVer_" .. i, height = "6.5vh", width = "100%", background = C.card,
      corner = "0.8vh", border = BORDER, hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.4vh", right = "1.4vh" }, action = "HomeVer_" .. i, children = {
        ui.image { id = "HomeVer_" .. i .. "_ico", icon = "sf:cube.fill", size = "3vh", style = { tint = C.accent } },
        ui.text { id = "HomeVer_" .. i .. "_name", text = "", weight = 1, style = { font = "2.4vh", color = C.dark } },
        ui.text { id = "HomeVer_" .. i .. "_meta", text = "", style = { font = "2vh", color = C.mid } },
      } }
  end
  local vsKids = {
    ui.text { text = "版本列表", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
  }
  for _, s in ipairs(slots) do vsKids[#vsKids + 1] = s end
  local noticeKids = {
    ui.row { width = "100%", height = "5vh", crossAlign = "center", spacing = "1.5vh", children = {
      ui.image { icon = "sf:info.circle.fill", size = "4vh", corner = "pill", background = C.faintBlue, style = { tint = C.accent } },
      ui.text { text = "公告", style = { font = "2.8vh", weight = "bold", color = C.dark } },
    } },
    ui.divider { height = "0.2vh", background = C.cardBorder },
    ui.text { text = "欢迎使用 Pear 启动器。", width = "100%", style = { font = "2.4vh", color = C.dark } },
    ui.text { text = "· 左侧选择账号类型并登录。", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { text = "· 点击「版本选择」在版本列表中切换版本。", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { text = "· 点击「版本设置」进入版本设置页。", width = "100%", style = { font = "2.2vh", color = C.mid } },
  }
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center", padding = "1.6vh",
    spacing = "2vh", children = {
      section("homeNotice", { card("homeNoticeCard", noticeKids, { spacing = "1.8vh" }) }),
      section("homeVersions", { card("Launch.Home.VersionList", vsKids, { spacing = "1.2vh" }) }),
    } }
end

-- ===== 下载页 =====
local refreshDownloadGroups, refreshInstallPanel

local function groupItems(p, key)
  local groups = (type(p) == "table") and p.groups or nil
  if type(groups) ~= "table" then return {} end
  local direct = groups[key]
  if type(direct) == "table" and direct[1] ~= nil then return direct end
  for _, grp in ipairs(groups) do
    if type(grp) == "table" and grp.key == key and type(grp.items) == "table" then return grp.items end
  end
  return {}
end

local function refreshDownloadVersions()
  local p = launcher.service and launcher.service("download", "versions", {}) or {}
  if type(p) ~= "table" then p = {} end
  dlGroups = {}
  flatVersions = {}
  for _, g in ipairs(CONFIG.download.versionGroups or {}) do
    local items
    if g.key == "latest" then
      items = {}
      local lr, ls = p.latestRelease, p.latestSnapshot
      if type(lr) == "table" and lr.id then items[#items + 1] = lr end
      if type(ls) == "table" and ls.id then items[#items + 1] = ls end
      if #items == 0 then items = groupItems(p, "latest") end
    else
      items = groupItems(p, g.key)
    end
    dlGroups[g.key] = items
    for _, it in ipairs(items) do flatVersions[#flatVersions + 1] = it end
  end
  refreshDownloadGroups()
  refreshInstallPanel()
end

refreshInstallPanel = function()
  local maxR = CONFIG.download.maxVersionRows or 12
  for i = 1, maxR do
    local it = flatVersions[i]
    launcher.view("dlIv_" .. i .. "_name"):setText(it and (it.id or "") or "")
    launcher.view("dlIv_" .. i .. "_date"):setText(it and (it.date or it.name or "") or "")
    launcher.view("dlIv_" .. i .. "_ico"):setStyle({ tint = (it and it.id == PLC.mc) and C.accent or C.mid })
    launcher.view("dlIv_" .. i):setVisible(PLC.mcOpen and it ~= nil)
  end
  local label = (PLC.mc ~= "" and PLC.mc) or "未选择版本"
  if launcher.view("insVersion") then launcher.view("insVersion"):setText(label) end
  if launcher.view("dlMcVersion") then launcher.view("dlMcVersion"):setText(label) end
end

local function dlGrpVersionRow(gkey, j, it)
  local vid = (type(it) == "table" and it.id) or ""
  local sub = (type(it) == "table" and (it.date or it.name)) or ""
  return ui.row { id = "dlGrpVer_" .. gkey .. "_" .. j, width = "100%", height = "6.5vh",
    background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
    hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
    padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGrpVer_" .. gkey .. "_" .. j, children = {
      ui.image { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_ico", icon = "sf:cube.fill", size = "2.6vh", style = { tint = C.accent } },
      ui.column { weight = 1, crossAlign = "stretch", spacing = "0.5vh", children = {
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_name", text = vid, width = "100%", style = { font = "2.3vh", color = C.dark } },
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_date", text = sub, width = "100%", style = { font = "1.9vh", color = C.mid } },
      } },
      chevron(),
    } }
end

refreshDownloadGroups = function()
  for _, g in ipairs(CONFIG.download.versionGroups or {}) do
    local key = g.key
    local open = dlOpenGroup[key] == true
    if open and not dlGroupAppended[key] then
      local rows = dlGroups[key] or {}
      local nodes = {}
      for j = 1, #rows do nodes[#nodes + 1] = dlGrpVersionRow(key, j, rows[j]) end
      if #nodes > 0 then
        launcher.view("dlGrpList_" .. key):append(nodes)
        dlGroupAppended[key] = true
      end
    end
    launcher.view("dlGrpList_" .. key):setVisible(open)
    launcher.view("dlGh_" .. key):setStyle({ background = open and C.hover or C.card })
  end
end

local function refreshDownloadState()
  local showMc = (dlLevel == "groups" or dlLevel == "install")
  launcher.view("dlGroupsCard"):setVisible(showMc and dlLevel == "groups")
  launcher.view("dlViewer"):setVisible(showMc and dlLevel == "install")
  if dlLevel == "groups" then refreshDownloadGroups() else refreshInstallPanel() end
end

local function currentDlCat()
  return DL_CAT[dlSelId] or DL_CAT["Download.Left.Minecraft"]
end

-- 社区资源搜索
local function commCategory()
  local it = currentDlCat()
  return (it and it.key) or "mod"
end
local function commSource()
  return dlSources[dlSourceIdx] or dlSources[1] or { id = "modrinth", name = "Modrinth" }
end
local function clearCommunityResults()
  for i = 1, CONFIG.download.communitySlots do launcher.view("dlComm_" .. i):setVisible(false) end
  dlCommItems = {}
end
local function refreshCommunitySearch()
  launcher.view("dlSrcVal"):setText(commSource().name or "…")
  launcher.view("dlObjVal"):setText((TOKEN_LABEL[commCategory()] or (currentDlCat() and currentDlCat().label)) or "Mod")
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or "点击输入关键词…")
  clearCommunityResults()
  launcher.view("dlCommStatus"):setText("点击「搜索」获取社区资源，点击结果条目可下载最新版本。")
  launcher.view("dlCommBarBox"):setVisible(false)
  commDownloading = false
end
local function doCommunitySearch()
  local kw = tostring(dlKeyword):gsub("^%s+", ""):gsub("%s+$", "")
  if kw == "" then
    launcher.view("dlCommStatus"):setText("请先点击「搜索关键词」输入要搜索的内容。")
    return
  end
  launcher.service("community", "search", {
    source = commSource().id, category = commCategory(), keyword = kw,
    limit = CONFIG.download.communitySlots,
  })
  launcher.view("dlCommStatus"):setText("正在搜索「" .. kw .. "」…")
end

local function refreshDownloadCategory()
  local it = currentDlCat()
  local kind = (it and it.kind) or "mc"
  launcher.view("dlTitle"):setText((it and it.label) or "原版游戏")
  launcher.view("dlSecMC"):setVisible(kind == "mc" or kind == "loader")
  launcher.view("dlSecC"):setVisible(kind == "comm")
  launcher.view("dlSecEmpty"):setVisible(kind == "empty")
  launcher.view("dlProgress"):setVisible(false)
  if kind == "loader" then
    launcher.view("insSummary"):setText("已选择安装「" .. tostring(it.label) .. "」" .. CONFIG.download.loaderSuffix)
    launcher.view("dlLoaderNote"):setVisible(true)
    launcher.view("dlLoaderNoteText"):setText("加载器（" .. tostring(it.label) .. "）需在对应原版版本上安装；引擎暂不提供加载器本体下载。")
  else
    launcher.view("insSummary"):setText(CONFIG.download.installHint)
    launcher.view("dlLoaderNote"):setVisible(false)
  end
  if kind == "empty" then
    launcher.view("dlEmptyText"):setText(CONFIG.download.emptyText[it.key] or "引擎暂不支持该分类。")
  end
  if kind == "comm" then refreshCommunitySearch() end
  dlLevel = "groups"
  refreshDownloadState()
end

local function refreshDownloadSidebar()
  for _, g in ipairs(CONFIG.download.sidebarGroups) do
    for _, it in ipairs(g.items) do applySidebarSel(it.id, it.id == dlSelId) end
  end
end

local function buildDownloadSidebar()
  local kids = {}
  for _, g in ipairs(CONFIG.download.sidebarGroups) do
    kids[#kids + 1] = ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } }
    for _, it in ipairs(g.items) do
      kids[#kids + 1] = sidebarItem(it.id, it.icon, it.label, it.id)
    end
  end
  return kids
end

local function buildDownloadPage()
  local D = CONFIG.download
  local maxR = D.maxVersionRows or 12
  -- 版本分组（首屏）
  local grpRows = {}
  for _, g in ipairs(D.versionGroups or {}) do
    grpRows[#grpRows + 1] = ui.row { id = "dlGh_" .. g.key, height = "7vh", width = "100%",
      background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
      hoverColor = C.hover, crossAlign = "center", spacing = "1.4vh",
      padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGh_" .. g.key, children = {
        ui.image { icon = "sf:shippingbox.fill", size = "3vh", corner = "pill", background = C.faintBlue, style = { tint = C.accent } },
        ui.text { text = g.name, weight = 1, style = { font = "2.6vh", color = C.dark } },
        chevron(),
      } }
    grpRows[#grpRows + 1] = ui.column { id = "dlGrpList_" .. g.key, width = "100%", crossAlign = "stretch", spacing = "0", children = {} }
  end
  local groupsCard = ui.column { id = "dlGroupsCard", width = "100%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = "0", children = grpRows }

  -- 行内 Minecraft 版本列表槽位
  local mcRows = {}
  for i = 1, maxR do
    mcRows[#mcRows + 1] = ui.row { id = "dlIv_" .. i, width = "100%", height = "7vh", background = C.card,
      corner = "0", border = { width = "0", color = C.cardBorder }, hoverColor = C.hover,
      crossAlign = "center", spacing = "1.2vh", padding = { left = "1.2vh", right = "1.2vh" },
      action = "dlIv_" .. i, children = {
        ui.image { id = "dlIv_" .. i .. "_ico", icon = "sf:cube.fill", size = "2.6vh", style = { tint = C.mid } },
        ui.column { weight = 1, crossAlign = "stretch", spacing = "0.4vh", children = {
          ui.text { id = "dlIv_" .. i .. "_name", text = "", width = "100%", style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "dlIv_" .. i .. "_date", text = "", width = "100%", style = { font = "1.9vh", color = C.mid } },
        } },
        chevron(),
      } }
  end

  local viewer = ui.column { id = "dlViewer", width = "100%", crossAlign = "center", spacing = "2vh", children = {
    card("dlPrevCard", {
      ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.5vh", children = {
        ui.image { icon = "sf:shippingbox.fill", size = "6vh", corner = "1.2vh",
          background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
          ui.text { id = "insVersion", text = "未选择版本", width = "100%", style = { font = "2.9vh", weight = "bold", color = C.dark } },
          ui.text { id = "insSummary", text = D.installHint, width = "100%", style = { font = "2.1vh", color = C.mid } },
        } },
        ui.button { id = "dlBackGrp", label = "‹ 版本列表", width = "18vh", height = "5.5vh",
          background = C.faintBlue, corner = "0.9vh", action = "dlBackGrp", style = { font = "2.2vh", tint = C.accent, weight = "bold" } },
        ui.button { id = "insStart", label = "开始安装", width = "22vh", height = "5.5vh",
          background = C.accent, corner = "0.9vh", action = "insStart", style = { font = "2.4vh", weight = "bold", tint = C.white } },
      } },
    }, { spacing = "1.2vh" }),
    ui.column { id = "dlMcW", width = "100%", background = C.card, border = BORDER_A, corner = "1.2vh",
      shadow = SHADOW, padding = "0", children = {
        ui.row { id = "dlMcToggle", width = "100%", height = "7vh", background = C.card, hoverColor = C.hover,
          crossAlign = "center", spacing = "1vh", padding = { left = "1.6vh", right = "1.6vh" }, action = "dlMcToggle", children = {
            ui.text { text = D.mcLabel or "Minecraft", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.accent } },
            ui.image { icon = "sf:cube.fill", size = "3vh", style = { tint = C.mid } },
            ui.text { id = "dlMcVersion", text = "未选择版本", style = { font = "2.4vh", color = C.dark } },
            ui.text { text = "▾", style = { font = "2.6vh", color = C.mid } },
          } },
        ui.column { id = "dlMcList", width = "100%", crossAlign = "stretch", spacing = "0", children = mcRows },
      } },
    hintRow("dlLoaderNote", "dlLoaderNoteText", "加载器需在对应原版版本上安装。"),
    ui.column { id = "dlProgress", width = "100%", spacing = "1vh", crossAlign = "stretch", children = {
      makeBar("dlBarTrack", "dlBarFill"),
      ui.text { id = "dlProgressLabel", text = "准备中…", width = "100%", style = { font = "2.2vh", color = C.dark } },
      ui.button { id = "dlCancel", label = "取消下载", width = "100%", height = "5.2vh",
        background = C.card, border = BORDER_D, corner = "0.7vh", action = "dlCancel", style = { font = "2.3vh", tint = C.danger } },
    } },
  } }

  -- 社区资源搜索 + 结果
  local function commPickerRow(id, label, valueId, action)
    return ui.row { id = id, height = "4.8vh", width = "100%", crossAlign = "center", hoverColor = C.hover,
      action = action, children = {
        ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
        ui.spacer { weight = 1 },
        ui.row { width = "60%", height = "4.5vh", background = C.card,
          border = { width = "0.12vh", color = C.fieldBorder }, corner = "0.8vh", crossAlign = "center",
          padding = { left = "1.2vh", right = "1.2vh" }, children = {
            ui.text { id = valueId, text = "…", weight = 1, style = { font = "2.2vh", color = C.dark } },
            ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
          } },
      } }
  end
  local commSlots = {}
  for i = 1, (D.communitySlots or 6) do
    commSlots[#commSlots + 1] = ui.row { id = "dlComm_" .. i, height = "9vh", background = C.card, corner = "1.1vh",
      border = BORDER, hoverColor = C.hover, crossAlign = "center", spacing = "1.5vh", padding = "1.5vh",
      action = "dlComm_" .. i, children = {
        ui.image { icon = "sf:cube.fill", size = "6vh", corner = "pill", background = C.accent, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
          ui.text { id = "dlComm_" .. i .. "_title", text = "", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { id = "dlComm_" .. i .. "_meta", text = "", width = "100%", style = { font = "2vh", color = C.mid } },
        } },
        ui.text { id = "dlComm_" .. i .. "_btn", text = "下载", style = { font = "2.2vh", color = C.accent } },
      } }
  end
  local searchKids = {
    ui.text { text = "搜索社区资源", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } },
    commPickerRow("dlSrcRow", "搜索源", "dlSrcVal", "dlSrcRow"),
    commPickerRow("dlObjRow", "搜索对象", "dlObjVal", nil),
    commPickerRow("dlKwRow", "搜索关键词", "dlKwVal", "dlKwRow"),
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("dlBtnSearch", "搜索", false, "dlBtnSearch"),
      plainButton("dlBtnReset", "重置", false, "dlBtnReset"),
    } },
  }
  local resultKids = { ui.text { text = "结果", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
  for _, s in ipairs(commSlots) do resultKids[#resultKids + 1] = s end
  resultKids[#resultKids + 1] = ui.text { id = "dlCommStatus", text = "点击「搜索」获取社区资源。",
    width = "100%", style = { font = "2.2vh", color = C.mid } }
  resultKids[#resultKids + 1] = ui.column { id = "dlCommBarBox", width = "100%", spacing = "1vh",
    crossAlign = "stretch", children = {
      makeBar("dlCommBarTrack", "dlCommBarFill"),
      ui.text { id = "dlCommBarLabel", text = "", width = "100%", style = { font = "2.2vh", color = C.dark } },
    } }

  local emptyCard = card("dlEmptyCard", {
    ui.text { id = "dlEmptyTitle", text = "暂不可用", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } },
    ui.text { id = "dlEmptyText", text = "引擎暂不支持该分类。", width = "100%", style = { font = "2.2vh", color = C.mid } },
  }, { spacing = "1.6vh" })

  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center", padding = "1.6vh", spacing = "2vh", children = {
    section("dlTitleSec", {
      ui.text { id = "dlTitle", text = "原版游戏", width = "100%", style = { font = "3vh", weight = "bold", color = C.dark } },
    }),
    section("dlSecMC", { groupsCard, viewer }),
    section("dlSecC", { card("dlSearchCard", searchKids, { spacing = "1.5vh" }), card("dlResultCard", resultKids, { spacing = "1.5vh" }) }),
    section("dlSecEmpty", { emptyCard }),
  } }
end

-- ===== 设置页 =====
local function setStatusText(msg)
  local v = launcher.view("setStatus")
  if v then v:setText(msg) end
end

local function cycleVS(prefix, key)
  local opts = VS_OPTIONS[key]
  local vv = launcher.view(prefix .. key .. "Val")
  if not opts then
    setStatusText("「" .. (VS_LABELS[key] or key) .. "」：" .. tostring(vv and vv:getText() or ""))
    return
  end
  local cur = vv and vv:getText() or ""
  local idx = 0
  for i, o in ipairs(opts) do if tostring(o) == tostring(cur) then idx = i break end end
  local nxt = opts[(idx % #opts) + 1]
  launcher.service("versionSettings", "set", { key = key, value = tostring(nxt) })
  if vv then vv:setText(tostring(nxt)) end
  setStatusText("已设置「" .. (VS_LABELS[key] or key) .. "」为 " .. tostring(nxt))
end

-- 前向声明：以下函数在设置/更多/版本设置页构建器中被引用，具体实现位于文件后部。
local mpCards, mpRoomCard, refreshMp, refreshAbout, refreshTest

local function refreshGameDir()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  local n = 6
  for i = 1, n do
    local it = items[i]
    local row = launcher.view("gd_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("gd_" .. i .. "_name"):setText(it.name or it.id or "")
        launcher.view("gd_" .. i .. "_meta"):setText((it.selected == true) and "当前使用目录" or "点击「使用」切换")
        launcher.view("gdPick_" .. i):setText((it.selected == true) and "使用中" or "使用")
      end
    end
  end
  if launcher.view("gdEmpty") then launcher.view("gdEmpty"):setVisible(#items == 0) end
end

local function refreshSettingsData()
  local map = vsItemsByKey()
  refreshVSInto("setL_", CONFIG.settings.launchKeys, map)
  refreshVSInto("setJ_", CONFIG.settings.javaKeys, map)
  refreshGameDir()
  refreshMp("setMp")
  refreshAbout()
end

local function refreshSettingsContent()
  for _, k in ipairs(SET_KEYS) do
    local v = launcher.view("setSec_" .. k)
    if v then v:setVisible(k == setSelCat) end
  end
end

local function buildSettingsPage()
  local SEC = {}
  local function sec(key, children) SEC[#SEC + 1] = ui.column { id = "setSec_" .. key, width = SECTION_W,
    crossAlign = "center", spacing = "2vh", children = children } end

  -- 游戏 · 启动
  local launchRows = {}
  for _, k in ipairs(CONFIG.settings.launchKeys) do launchRows[#launchRows + 1] = vsRow("setL_", k) end
  launchRows[#launchRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
    plainButton("setLReset", "重置这些设置", false, "setLReset"),
  } }
  sec("game.launch", { card("setLCard", launchRows, { spacing = "1.5vh" }) })

  -- 游戏 · Java
  local javaRows = {}
  for _, k in ipairs(CONFIG.settings.javaKeys) do javaRows[#javaRows + 1] = vsRow("setJ_", k) end
  javaRows[#javaRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
    plainButton("setJReset", "重置这些设置", false, "setJReset"),
  } }
  sec("game.java", { card("setJCard", javaRows, { spacing = "1.5vh" }) })

  -- 游戏 · 游戏管理
  local gdRows = {}
  for i = 1, 6 do
    gdRows[#gdRows + 1] = ui.row { id = "gd_" .. i, height = "7vh", width = "100%", background = C.card,
      border = BORDER, corner = "0.8vh", crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.2vh", right = "1.2vh" }, children = {
        ui.image { id = "gd_" .. i .. "_ico", icon = "sf:folder.fill", size = "3vh", style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "gd_" .. i .. "_name", text = "", width = "100%", style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "gd_" .. i .. "_meta", text = "", width = "100%", style = { font = "1.9vh", color = C.mid } },
        } },
        ui.button { id = "gdPick_" .. i, label = "使用", width = "14vh", height = "4.4vh", corner = "pill",
          action = "gdPick_" .. i, hoverColor = C.hover, background = C.card, border = BORDER_A,
          style = { font = "2.2vh", tint = C.accent, weight = "bold" } },
      } }
  end
  gdRows[#gdRows + 1] = ui.text { id = "gdEmpty", text = "尚未创建其他游戏目录，可在下方输入目录名新建。",
    width = "100%", style = { font = "2.2vh", color = C.mid } }
  gdRows[#gdRows + 1] = ui.row { width = "100%", height = "6vh", crossAlign = "center", spacing = "1.2vh", children = {
    ui.input { id = "gdNewIn", placeholder = "输入新目录名…", weight = 1, height = "4.6vh",
      background = C.card, corner = "0.8vh", border = BORDER, style = { font = "2.3vh", tint = C.dark } },
    ui.button { id = "gdCreate", label = "新建", width = "18vh", height = "5vh", corner = "pill",
      action = "gdCreate", hoverColor = C.hover, background = C.card, border = BORDER_A,
      style = { font = "2.3vh", tint = C.accent, weight = "bold" } },
  } }
  sec("game.manage", { card("gdCard", gdRows, { spacing = "1.5vh" }) })

  -- 工具 · 游戏联机
  sec("tool.multi", { mpCards("setMp") })

  -- 启动器 · 界面
  local uiRows = {}
  for _, tok in ipairs(CONFIG.settings.tokenSections.ui) do
    uiRows[#uiRows + 1] = navRow("setTok_" .. tok, TOKEN_LABEL[tok] or tok, "引擎原生页", "setTok_" .. tok)
  end
  sec("launcher.ui", { card("setUICard", uiRows, { spacing = "1.2vh" }) })

  -- 启动器 · 语言
  sec("launcher.lang", { card("setLangCard", {
    ui.row { id = "setLangRow", height = "6.5vh", width = "100%", crossAlign = "center", spacing = "1.2vh",
      hoverColor = C.hover, action = "setLangRow", padding = { left = "1.2vh", right = "1.2vh" }, children = {
        ui.text { text = "界面语言", weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = "setLangVal", text = LANGS[1], style = { font = "2.3vh", color = C.mid } },
        chevron(),
      } },
    ui.text { id = "setLangHint", text = "界面语言随启动器语言设置生效；这里切换仅作本地预览。",
      width = "100%", style = { font = "2.1vh", color = C.mid } },
  }, { spacing = "1.4vh" }) })

  -- 启动器 · 杂项
  local miscRows = {}
  for _, tok in ipairs(CONFIG.settings.tokenSections.misc) do
    miscRows[#miscRows + 1] = navRow("setTok_" .. tok, TOKEN_LABEL[tok] or tok, "引擎原生页", "setTok_" .. tok)
  end
  sec("launcher.misc", { card("setMiscCard", miscRows, { spacing = "1.2vh" }) })

  -- 关于 · 关于
  sec("about.about", { card("aboutInfoCard", {
    ui.text { id = "aboutInfoName", text = "PCL 浅色", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } },
    ui.text { id = "aboutInfoVer", text = "版本 ···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { id = "aboutInfoOs", text = "系统：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { id = "aboutInfoModel", text = "设备：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { id = "aboutInfoStorage", text = "存储：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
  }, { spacing = "1.4vh" }) })

  -- 关于 · 更新
  sec("about.update", { card("aboutUpdateCard", {
    ui.text { id = "aboutUpdateCur", text = "当前版本 ···", width = "100%", style = { font = "2.5vh", color = C.dark } },
    ui.text { id = "aboutUpdateStatus", text = "引擎暂不提供在线更新检查服务。", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("aboutUpdateBtn", "检查更新", false, "aboutUpdateBtn"),
    } },
  }, { spacing = "1.4vh" }) })

  -- 关于 · 反馈
  sec("about.feedback", { card("aboutFeedbackCard", {
    ui.text { id = "aboutFeedbackText", text = "反馈渠道由启动器原生页面提供；引擎未暴露反馈服务。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("aboutFeedbackBtn", "查看说明", false, "aboutFeedbackBtn"),
    } },
  }, { spacing = "1.4vh" }) })

  -- 关于 · 日志
  sec("about.log", { card("aboutLogCard", {
    ui.text { text = "日志", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
    ui.text { id = "aboutLogText", text = "引擎未提供日志读取服务，无法在此展示启动日志；请在系统日志或引擎原生界面查看。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
  }, { spacing = "1.4vh" }) })

  local kids = {}
  for _, s in ipairs(SEC) do kids[#kids + 1] = s end
  kids[#kids + 1] = section("setStatusBar", { ui.row { id = "setStatusBarRow", width = "100%", background = C.hintBg,
    corner = "1vh", crossAlign = "center", spacing = "1.2vh", padding = "1.4vh", children = {
      ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
      ui.text { id = "setStatus", text = "设置项已按分组展示；点击开关或按钮可即时反馈。", weight = 1,
        style = { font = "2.2vh", color = C.dark } },
    } } })

  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center", padding = "1.6vh", spacing = "2vh", children = kids }
end

-- ===== 更多页 =====
local function refreshMoreContent()
  for _, k in ipairs(MORE_KEYS) do
    local v = launcher.view("moreSec_" .. k)
    if v then v:setVisible(k == moreSelCat) end
  end
  refreshMp("mp")
  refreshTest()
end

local function buildMorePage()
  local SEC = {}
  local function sec(key, children) SEC[#SEC + 1] = ui.column { id = "moreSec_" .. key, width = SECTION_W,
    crossAlign = "center", spacing = "2vh", children = children } end

  -- 联机 · 联机大厅
  local mpKids = {
    ui.row { id = "mpStatusRow", width = "100%", background = C.hintBg, corner = "1vh", crossAlign = "center",
      spacing = "1.2vh", padding = "1.4vh", children = {
        ui.text { id = "mpStatusIcon", text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
        ui.text { id = "mpStatus", text = "联机需要双方都能访问服务器，房间连接码用于分享。", weight = 1,
          style = { font = "2.2vh", color = C.dark } },
        ui.button { id = "mpShare", label = "分享房间", width = "16vh", height = "4.5vh", corner = "pill",
          action = "mpShare", hoverColor = C.hover, style = { font = "2.2vh", tint = C.accent, background = C.card, weight = "bold" } },
      } },
    ui.row { id = "mpJoinRow", width = "100%", height = "5.5vh", background = C.card, border = BORDER,
      corner = "1.2vh", crossAlign = "center", padding = "1.4vh", spacing = "1.2vh", hoverColor = C.hover,
      action = "mpJoin", children = {
        ui.image { icon = "sf:link", size = "2.6vh", style = { tint = C.mid } },
        ui.text { weight = 1, text = "输入房间连接码加入房间…", style = { font = "2.2vh", color = C.mid } },
        ui.button { id = "mpJoin", label = "加入", height = "4vh", background = C.accent, corner = "pill",
          action = "mpJoin", style = { font = "2.2vh", tint = C.white } },
      } },
    ui.row { id = "mpCreateRow", width = "100%", height = "5.5vh", background = C.card, border = BORDER,
      corner = "1.2vh", crossAlign = "center", padding = "1.4vh", spacing = "1.2vh", hoverColor = C.hover,
      action = "mpCreate", children = {
        ui.image { icon = "sf:plus.circle", size = "2.6vh", style = { tint = C.mid } },
        ui.text { weight = 1, text = "输入 Network ID 创建房间…", style = { font = "2.2vh", color = C.mid } },
        ui.button { id = "mpCreate", label = "创建", height = "4vh", background = C.accent, corner = "pill",
          action = "mpCreate", style = { font = "2.2vh", tint = C.white } },
      } },
  }
  mpKids[#mpKids + 1] = mpRoomCard("mp")
  mpKids[#mpKids + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
    plainButton("mpRefresh", "刷新房间列表", false, "mpRefresh"),
  } }
  sec("mp.hall", { card("mpHallCard", mpKids, { spacing = "1.5vh" }) })

  -- 工具 · 测试
  sec("tool.test", { card("testCard", {
    ui.text { text = "诊断信息", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
    ui.text { id = "testSysOs", text = "系统：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { id = "testSysModel", text = "设备：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.text { id = "testStorage", text = "存储：···", width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh", children = {
      plainButton("testOpenDir", "打开版本目录", false, "testOpenDir"),
      plainButton("testOpenMods", "打开 Mod 目录", false, "testOpenMods"),
      plainButton("testOpenSaves", "打开存档目录", false, "testOpenSaves"),
    } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("testRefresh", "刷新诊断", false, "testRefresh"),
    } },
  }, { spacing = "1.4vh" }) })

  local kids = {}
  for _, s in ipairs(SEC) do kids[#kids + 1] = s end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center", padding = "1.6vh", spacing = "2vh", children = kids }
end

-- ===== 版本设置页 =====
local function refreshVsContent()
  for _, k in ipairs(VS_KEYS) do
    local v = launcher.view("vsSec_" .. k)
    if v then v:setVisible(k == vsSelCat) end
  end
end

local function refreshVsInstall()
  local resp = launcher.service and launcher.service("version", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  local n = CONFIG.versions.slots
  for i = 1, n do
    local it = items[i]
    local row = launcher.view("vsInst_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("vsInst_" .. i .. "_name"):setText(it.id or "")
        launcher.view("vsInst_" .. i .. "_meta"):setText((it.selected == true) and "当前使用" or tostring(it.type or "custom"))
      end
    end
  end
end

local function refreshMods()
  local resp = launcher.service and launcher.service("mods", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  local n = CONFIG.versions.slots
  for i = 1, n do
    local it = items[i]
    local row = launcher.view("vsMod_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("vsMod_" .. i .. "_name"):setText(it.name or it.fileName or "")
        local meta = {}
        if type(it.author) == "string" and it.author ~= "" then meta[#meta + 1] = it.author end
        if type(it.gameVersion) == "string" and it.gameVersion ~= "" then meta[#meta + 1] = it.gameVersion end
        launcher.view("vsMod_" .. i .. "_meta"):setText(#meta > 0 and table.concat(meta, " · ") or (it.fileName or ""))
        launcher.view("vsModT_" .. i):setText((it.enabled == true) and "停用" or "启用")
      end
    end
  end
  if launcher.view("vsModEmpty") then launcher.view("vsModEmpty"):setVisible(#items == 0) end
end

local function refreshShadersInto(prefix, emptyId)
  local resp = launcher.service and launcher.service("shaders", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  local n = CONFIG.versions.slots
  for i = 1, n do
    local it = items[i]
    local row = launcher.view(prefix .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view(prefix .. i .. "_name"):setText(it.name or it.fileName or "")
        local meta = {}
        if type(it.author) == "string" and it.author ~= "" then meta[#meta + 1] = it.author end
        if type(it.gameVersion) == "string" and it.gameVersion ~= "" then meta[#meta + 1] = it.gameVersion end
        launcher.view(prefix .. i .. "_meta"):setText(#meta > 0 and table.concat(meta, " · ") or (it.fileName or ""))
        local t = launcher.view(prefix .. "T_" .. i)
        if t then t:setText((it.enabled == true) and "停用" or "启用") end
      end
    end
  end
  if emptyId and launcher.view(emptyId) then launcher.view(emptyId):setVisible(#items == 0) end
end

local function refreshVsData()
  local ver = launcher.state and launcher.state.version
  local name = (ver and ver.name) or "未选择版本"
  if launcher.view("vsName") then launcher.view("vsName"):setText(name) end
  if launcher.view("vsMeta") then launcher.view("vsMeta"):setText("版本信息 · " .. (name == "未选择版本" and "请在启动页版本列表中选择" or "本地已安装")) end
  local map = vsItemsByKey()
  refreshVSInto("vset_", VS_LABEL_KEYS, map)
  refreshVsInstall()
  refreshMods()
  refreshShadersInto("vsShade_", "vsShadeEmpty")
  refreshShadersInto("vsRp_", "vsRpEmpty")
  refreshMp("vsSrv")
end

VS_LABEL_KEYS = { "versionIsolation", "windowTitle", "windowInfo", "javaVersion", "ramType", "ram", "ramOptimize", "serverIp", "loginMode" }

local function vsListCard(prefix, title, emptyText, withToggle)
  local rows = {
    ui.text { text = title, width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
  }
  local n = CONFIG.versions.slots
  for i = 1, n do
    local kids = {
      ui.image { id = prefix .. i .. "_ico", icon = "sf:puzzlepiece.extension.fill", size = "3vh", style = { tint = C.accent } },
      ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
        ui.text { id = prefix .. i .. "_name", text = "", width = "100%", style = { font = "2.3vh", color = C.dark } },
        ui.text { id = prefix .. i .. "_meta", text = "", width = "100%", style = { font = "1.9vh", color = C.mid } },
      } },
    }
    if withToggle then
      kids[#kids + 1] = ui.button { id = prefix .. "T_" .. i, label = "启用", width = "12vh", height = "4.2vh",
        corner = "pill", action = prefix .. "T_" .. i, hoverColor = C.hover,
        style = { font = "2.1vh", tint = C.accent, background = C.faintBlue, weight = "bold" } }
      kids[#kids + 1] = ui.button { id = prefix .. "X_" .. i, label = "删除", width = "10vh", height = "4.2vh",
        corner = "pill", action = prefix .. "X_" .. i, hoverColor = C.hover,
        style = { font = "2.1vh", tint = C.danger, background = C.card, weight = "bold" } }
    end
    rows[#rows + 1] = ui.row { id = prefix .. i, height = "7vh", width = "100%", background = C.card,
      border = BORDER, corner = "0.8vh", crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.2vh", right = "1.2vh" }, children = kids }
  end
  rows[#rows + 1] = ui.text { id = prefix .. "Empty", text = emptyText, width = "100%", style = { font = "2.2vh", color = C.mid } }
  return rows
end

local function buildVersionSettingsPage()
  local SEC = {}
  local function sec(key, children) SEC[#SEC + 1] = ui.column { id = "vsSec_" .. key, width = SECTION_W,
    crossAlign = "center", spacing = "2vh", children = children } end

  -- 概览
  sec("info", {
    card("vsOverviewCard", {
      ui.row { width = "100%", height = "11vh", crossAlign = "center", spacing = "2vh", padding = "1vh", children = {
        ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent, corner = "1.2vh", style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
          ui.text { id = "vsName", text = "···", style = { font = "2.8vh", weight = "bold", color = C.dark } },
          ui.text { id = "vsMeta", text = "版本信息 ···", style = { font = "2.1vh", color = C.mid } },
        } },
      } },
    }, { spacing = "1.2vh" }),
    card("vsShortcutCard", {
      ui.text { text = "快捷方式", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      actionRow("vsShortcutRow", { "版本文件夹", "存档文件夹", "Mod 文件夹" }, { "vsOpenDir", "vsOpenSaves", "vsOpenMods" }),
    }, { spacing = "1.6vh" }),
    card("vsDangerCard", {
      ui.text { text = "高级管理", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.button { id = "vsDeleteTop", label = "删除本版本", width = "100%", height = "5.5vh", background = C.card,
        border = BORDER_D, corner = "0.7vh", action = "vsDeleteTop", style = { font = "2.4vh", tint = C.danger } },
    }, { spacing = "1.6vh" }),
  })

  -- 设置
  local setRows = {}
  for _, k in ipairs(VS_LABEL_KEYS) do setRows[#setRows + 1] = vsRow("vset_", k) end
  setRows[#setRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
    plainButton("vsetReset", "重置版本设置", false, "vsetReset"),
  } }
  sec("launch", { card("vsSetCard", setRows, { spacing = "1.5vh" }) })

  -- 安装
  local instRows = {}
  for i = 1, CONFIG.versions.slots do
    instRows[#instRows + 1] = ui.row { id = "vsInst_" .. i, height = "7vh", width = "100%", background = C.card,
      border = BORDER, corner = "0.8vh", hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.2vh", right = "1.2vh" }, action = "vsInst_" .. i, children = {
        ui.image { id = "vsInst_" .. i .. "_ico", icon = "sf:cube.fill", size = "3vh", style = { tint = C.accent } },
        ui.text { id = "vsInst_" .. i .. "_name", text = "", weight = 1, style = { font = "2.3vh", color = C.dark } },
        ui.text { id = "vsInst_" .. i .. "_meta", text = "", style = { font = "1.9vh", color = C.mid } },
        chevron(),
      } }
  end
  instRows[#instRows + 1] = hintRow("vsInstHint", "vsInstHintText", "引擎未提供「补全文件 / 安装加载器」服务，可在此选择已安装版本，或前往下载页安装新版本。")
  instRows[#instRows + 1] = actionRow("vsInstRow", { "打开版本目录", "前往下载页" }, { "vsInstOpenDir", "open:download" })
  sec("install", { card("vsInstCard", instRows, { spacing = "1.5vh" }) })

  -- 导出
  sec("export", { card("vsExportCard", {
    ui.text { text = "导出启动脚本", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
    ui.text { id = "vsExportText", text = "引擎未提供启动脚本导出服务；可打开版本目录手动导出所需文件。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("vsExportOpenDir", "打开版本目录", false, "vsExportOpenDir"),
    } },
  }, { spacing = "1.4vh" }) })

  -- 存档
  sec("saves", { card("vsSavesCard", {
    ui.text { text = "存档", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
    ui.text { id = "vsSavesText", text = "在系统文件 App 中打开当前版本的 saves 存档目录。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("vsSavesOpen", "打开存档目录", false, "vsSavesOpen"),
    } },
  }, { spacing = "1.4vh" }) })

  -- 截图
  sec("shots", { card("vsShotsCard", {
    ui.text { text = "截图", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
    ui.text { id = "vsShotsText", text = "引擎未提供截图读取服务，无法在此展示截图；可打开版本目录查看。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("vsShotsOpenDir", "打开版本目录", false, "vsShotsOpenDir"),
    } },
  }, { spacing = "1.4vh" }) })

  -- Mod
  local modRows = vsListCard("vsMod_", "Mod 列表", "当前版本未安装 Mod 加载器或暂无 Mod。", true)
  modRows[#modRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh", children = {
    plainButton("vsModOpenDir", "打开 Mod 目录", false, "vsModOpenDir"),
    plainButton("vsModRefresh", "刷新列表", false, "vsModRefresh"),
    plainButton("vsModDownload", "下载新 Mod", false, "open:download"),
  } }
  sec("mods", { card("vsModCard", modRows, { spacing = "1.5vh" }) })

  -- 资源包（引擎无独立资源包服务：复用光影扫描结果占位）
  local rpRows = vsListCard("vsRp_", "资源包", "引擎暂无独立资源包服务；此处以光影扫描结果占位显示。", false)
  rpRows[#rpRows + 1] = ui.text { id = "vsRpText", text = "资源包与光影包同为压缩资源；引擎仅暴露光影扫描，故此处内容可能不完整。",
    width = "100%", style = { font = "2.1vh", color = C.mid } }
  rpRows[#rpRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh", children = {
    plainButton("vsRpOpenDir", "打开版本目录", false, "vsRpOpenDir"),
    plainButton("vsRpRefresh", "刷新列表", false, "vsRpRefresh"),
  } }
  sec("rp", { card("vsRpCard", rpRows, { spacing = "1.5vh" }) })

  -- 光影
  local shadeRows = vsListCard("vsShade_", "光影包列表", "当前版本暂无光影包。", true)
  shadeRows[#shadeRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh", children = {
    plainButton("vsShadeOpenDir", "打开版本目录", false, "vsShadeOpenDir"),
    plainButton("vsShadeRefresh", "刷新列表", false, "vsShadeRefresh"),
  } }
  sec("shaders", { card("vsShadeCard", shadeRows, { spacing = "1.5vh" }) })

  -- 投影
  sec("litematica", { card("vsLitCard", {
    ui.text { text = "投影", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
    ui.text { id = "vsLitText", text = "引擎未提供投影（Litematica）服务，无法在此管理投影文件。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh", children = {
      plainButton("vsLitOpenDir", "打开版本目录", false, "vsLitOpenDir"),
    } },
  }, { spacing = "1.4vh" }) })

  -- 服务器
  local srvKids = {
    ui.text { text = "服务器", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
    ui.row { id = "vsSrvStatusRow", width = "100%", background = C.hintBg, corner = "1vh", crossAlign = "center",
      spacing = "1.2vh", padding = "1.4vh", children = {
        ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
        ui.text { id = "vsSrvStatus", text = "服务器列表来自引擎联机服务。", weight = 1, style = { font = "2.2vh", color = C.dark } },
      } },
  }
  srvKids[#srvKids + 1] = mpRoomCard("vsSrv")
  srvKids[#srvKids + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh", children = {
    plainButton("vsSrvJoin", "加入服务器", false, "vsSrvJoin"),
    plainButton("vsSrvCreate", "创建房间", false, "vsSrvCreate"),
  } }
  sec("servers", { card("vsSrvCard", srvKids, { spacing = "1.5vh" }) })

  local kids = {}
  for _, s in ipairs(SEC) do kids[#kids + 1] = s end
  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center", padding = "1.6vh", spacing = "2vh", children = kids }
end

-- ===== 联机：房间卡 + 刷新（三种前缀：setMp / mp / vsSrv） =====
local MP_UI = {
  setMp = { status = "setMpStatus", row = "setMpRoom_", connect = "setMpRoomC_", del = "setMpRoomD_", join = "setMpJoin", create = "setMpCreate", share = "setMpShare" },
  mp    = { status = "mpStatus",    row = "mpRoom_",    connect = "mpRoomC_",    del = "mpRoomD_",    join = "mpJoin",    create = "mpCreate",    share = "mpShare" },
  vsSrv = { status = "vsSrvStatus", row = "vsSrv_",     connect = "vsSrvC_",     del = "vsSrvD_",     join = "vsSrvJoin", create = "vsSrvCreate", share = nil },
}
refreshMp = function(kind)
  local cfg = MP_UI[kind]
  if not cfg then return end
  local resp = launcher.service and launcher.service("multiplayer", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  local n = CONFIG.multiplayer.roomSlots
  for i = 1, n do
    local it = items[i]
    local row = launcher.view(cfg.row .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view(cfg.row .. i .. "_name"):setText(it.name or ("房间 " .. i))
        local st = it.status or "未连接"
        if it.hostIP and it.hostIP ~= "" then st = st .. " · " .. tostring(it.hostIP) .. ":" .. tostring(it.hostPort or "25565") end
        launcher.view(cfg.row .. i .. "_status"):setText(st)
        launcher.view(cfg.connect .. i):setText((it.isCurrent == true) and "断开" or "连接")
      end
    end
  end
end

mpRoomCard = function(kind)
  local cfg = MP_UI[kind]
  local kids = { ui.text { text = "房间列表", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } } }
  for i = 1, CONFIG.multiplayer.roomSlots do
    kids[#kids + 1] = ui.row { id = cfg.row .. i, height = "7vh", width = "100%", background = C.card,
      border = BORDER, corner = "1vh", hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
      padding = "1.4vh", children = {
        ui.image { id = cfg.row .. i .. "_ico", icon = "sf:square.3.layers.3d", size = "4.4vh", corner = "1vh",
          background = C.accent, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = cfg.row .. i .. "_name", text = "", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { id = cfg.row .. i .. "_status", text = "", width = "100%", style = { font = "2vh", color = C.mid } },
        } },
        ui.button { id = cfg.connect .. i, label = "连接", width = "12vh", height = "4.5vh", corner = "pill",
          action = cfg.connect .. i, hoverColor = C.hover, style = { font = "2.2vh", tint = C.white, background = C.accent, weight = "bold" } },
        ui.button { id = cfg.del .. i, label = "删除", width = "10vh", height = "4.5vh", corner = "pill",
          action = cfg.del .. i, hoverColor = C.hover, style = { font = "2.2vh", tint = C.danger, background = C.card, weight = "bold" } },
      } }
  end
  return ui.column { id = kind .. "RoomCard", width = "100%", spacing = "1.2vh", crossAlign = "stretch", children = kids }
end

-- 联机区块（设置页「工具 · 游戏联机」使用）
mpCards = function(kind)
  local cfg = MP_UI[kind]
  local kids = {
    ui.row { id = cfg.status .. "Row", width = "100%", background = C.hintBg, corner = "1vh", crossAlign = "center",
      spacing = "1.2vh", padding = "1.4vh", children = {
        ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
        ui.text { id = cfg.status, text = "联机需要双方都能访问服务器，房间连接码用于分享。", weight = 1,
          style = { font = "2.2vh", color = C.dark } },
        ui.button { id = cfg.share, label = "分享房间", width = "16vh", height = "4.5vh", corner = "pill",
          action = cfg.share, hoverColor = C.hover, style = { font = "2.2vh", tint = C.accent, background = C.card, weight = "bold" } },
      } },
    ui.row { id = cfg.join .. "Row", width = "100%", height = "5.5vh", background = C.card, border = BORDER,
      corner = "1.2vh", crossAlign = "center", padding = "1.4vh", spacing = "1.2vh", hoverColor = C.hover,
      action = cfg.join, children = {
        ui.image { icon = "sf:link", size = "2.6vh", style = { tint = C.mid } },
        ui.text { weight = 1, text = "输入房间连接码加入房间…", style = { font = "2.2vh", color = C.mid } },
        ui.button { id = cfg.join, label = "加入", height = "4vh", background = C.accent, corner = "pill",
          action = cfg.join, style = { font = "2.2vh", tint = C.white } },
      } },
    ui.row { id = cfg.create .. "Row", width = "100%", height = "5.5vh", background = C.card, border = BORDER,
      corner = "1.2vh", crossAlign = "center", padding = "1.4vh", spacing = "1.2vh", hoverColor = C.hover,
      action = cfg.create, children = {
        ui.image { icon = "sf:plus.circle", size = "2.6vh", style = { tint = C.mid } },
        ui.text { weight = 1, text = "输入 Network ID 创建房间…", style = { font = "2.2vh", color = C.mid } },
        ui.button { id = cfg.create, label = "创建", height = "4vh", background = C.accent, corner = "pill",
          action = cfg.create, style = { font = "2.2vh", tint = C.white } },
      } },
  }
  kids[#kids + 1] = mpRoomCard(kind)
  return card(kind .. "MpCard", kids, { spacing = "1.5vh" })
end

-- ===== 关于 / 测试 刷新 =====
refreshAbout = function()
  local info = launcher.service and launcher.service("system", "info", {}) or nil
  local st = launcher.service and launcher.service("storage", "summary", {}) or nil
  local d = describe()
  if launcher.view("aboutInfoName") then launcher.view("aboutInfoName"):setText(d.name or "PCL 浅色") end
  if launcher.view("aboutInfoVer") then launcher.view("aboutInfoVer"):setText("版本 " .. tostring(d.version or "未知")) end
  local os = (type(info) == "table" and info.os) or "iOS"
  local v = (type(info) == "table" and info.systemVersion) or ""
  local model = (type(info) == "table" and info.model) or ""
  if launcher.view("aboutInfoOs") then launcher.view("aboutInfoOs"):setText("系统：" .. tostring(os) .. " " .. tostring(v)) end
  if launcher.view("aboutInfoModel") then launcher.view("aboutInfoModel"):setText("设备：" .. tostring(model)) end
  local summ = (type(st) == "table" and st.summary) or ""
  if launcher.view("aboutInfoStorage") then launcher.view("aboutInfoStorage"):setText("存储：" .. ((summ ~= "" and summ) or "引擎未上报")) end
  if launcher.view("aboutUpdateCur") then launcher.view("aboutUpdateCur"):setText("当前版本 " .. tostring(d.version or "")) end
end

refreshTest = function()
  local info = launcher.service and launcher.service("system", "info", {}) or nil
  local st = launcher.service and launcher.service("storage", "summary", {}) or nil
  if launcher.view("testSysOs") then launcher.view("testSysOs"):setText("系统：" .. tostring((type(info) == "table" and info.os) or "iOS") .. " " .. tostring((type(info) == "table" and info.systemVersion) or "")) end
  if launcher.view("testSysModel") then launcher.view("testSysModel"):setText("设备：" .. tostring((type(info) == "table" and info.model) or "")) end
  local summ = (type(st) == "table" and st.summary) or ""
  if launcher.view("testStorage") then launcher.view("testStorage"):setText("存储：" .. ((summ ~= "" and summ) or "引擎未上报")) end
end

-- ===== 根构建 =====
function build(ui)
  local contentChildren = {
    buildHomePage(),
    buildDownloadPage(),
    buildSettingsPage(),
    buildMorePage(),
    buildVersionSettingsPage(),
  }
  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0, children = {
      ui.row { id = "titlebar", height = "8.5vh",
        background = { from = C.topbarFrom, to = C.topbarTo, angle = 90 }, crossAlign = "center",
        padding = { left = "1.4vh", right = "1.5vh" }, children = {
          ui.row { id = "logoBadge", corner = "0.7vh", background = C.white, crossAlign = "center",
            padding = { left = "0.9vh", right = "0.9vh", top = "0.35vh", bottom = "0.35vh" }, children = {
              ui.text { id = "logo", text = "PCL", style = { font = "2.7vh", weight = "bold", color = C.topbarTo } },
            } },
          ui.text { id = "logoII", text = "II", style = { font = "2.3vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row { id = "tabs", spacing = "5vh", crossAlign = "center", children = (function()
            local nodes = {}
            for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
            return nodes
          end)() },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        } },
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0, children = {
        ui.column { id = "left", width = "32%", background = C.card, crossAlign = "center",
          spacing = "0.4vh", padding = { left = "2vh", right = "2vh", top = "1vh", bottom = "1vh" }, children = {
            ui.column { id = "leftHome", width = "100%", weight = 1, crossAlign = "center", spacing = "0.4vh", children = buildHomeSidebar() },
            ui.column { id = "leftDownload", width = "100%", weight = 1, crossAlign = "center", spacing = "0.4vh", children = buildDownloadSidebar() },
            ui.column { id = "leftSettings", width = "100%", weight = 1, crossAlign = "center", spacing = "0.4vh", children = sidebarFromGroups("stCat_", CONFIG.settings.groups) },
            ui.column { id = "leftMore", width = "100%", weight = 1, crossAlign = "center", spacing = "0.4vh", children = sidebarFromGroups("moreCat_", CONFIG.more.groups) },
            ui.column { id = "leftVersionSettings", width = "100%", weight = 1, crossAlign = "center", spacing = "0.4vh", children = sidebarFromGroups("vsCat_", CONFIG.versions.groups) },
          } },
        ui.content { id = "content", weight = 1, initialPage = "home",
          background = { from = C.pageFrom, to = C.pageTo, angle = 45 }, pages = CONFIG.pages, children = contentChildren },
      } },
    },
  }
end

-- ===== 交互 =====
local function selectTab(tabId)
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.card, tint = C.accent, corner = "pill" }
      or { background = C.transparent, tint = C.white, corner = "pill" })
  end
end

local function selectDownloadCat(item)
  dlSelId = item.id
  dlLevel = "groups"
  refreshDownloadSidebar()
  refreshDownloadCategory()
end

local function connectMp(kind, idx)
  launcher.service("multiplayer", "connect", { index = idx })
  refreshMp(kind)
end
local function deleteMp(kind, idx)
  launcher.service("multiplayer", "delete", { index = idx })
  refreshMp(kind)
end

function onReady()
  refreshAccount()
  refreshVersionText()
  selectCap(selectedCap)
  local srcResp = launcher.service and launcher.service("community", "sources", {}) or nil
  if type(srcResp) == "table" and srcResp.ok and type(srcResp.items) == "table" and #srcResp.items > 0 then
    dlSources = srcResp.items
  end
  refreshHomeVersionList()
  refreshDownloadVersions()
  if launcher.view("setLangVal") then launcher.view("setLangVal"):setText(LANGS[langIdx]) end
  onPageChange(currentPage)
end

function onLayout()
  -- 无绝对定位游标，保留钩子供引擎调用
end

function onAccountChange(account)
  if type(account) ~= "table" then return end
  if launcher.view("accountName") then launcher.view("accountName"):setText(account.name or "未登录") end
end

function onOpenSubpage(token)
  setStatusText("「" .. tostring(TOKEN_LABEL[token] or token) .. "」由引擎原生页处理（Lua 侧无对应页）。")
end

function onPageChange(page)
  currentPage = page or currentPage
  page = currentPage
  launcher.view("leftHome"):setVisible(page == "home")
  launcher.view("leftDownload"):setVisible(page == "download")
  launcher.view("leftSettings"):setVisible(page == "settings")
  launcher.view("leftMore"):setVisible(page == "more")
  launcher.view("leftVersionSettings"):setVisible(page == "version_settings")

  if page == "home" then
    refreshHomeVersionList()
    refreshVersionText()
  elseif page == "download" then
    refreshDownloadSidebar()
    refreshDownloadVersions()
    refreshDownloadCategory()
  elseif page == "settings" then
    refreshSidebarGroups("stCat_", CONFIG.settings.groups, setSelCat)
    refreshSettingsContent()
    refreshSettingsData()
  elseif page == "more" then
    refreshSidebarGroups("moreCat_", CONFIG.more.groups, moreSelCat)
    refreshMoreContent()
  elseif page == "version_settings" then
    refreshSidebarGroups("vsCat_", CONFIG.versions.groups, vsSelCat)
    refreshVsContent()
    refreshVsData()
  end
  selectTab(PAGE_TAB[page])
end

-- ===== 事件：下载 / 社区 / 联机 / 扫描 =====
function onDownloadUpdate(payload)
  local p = payload or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  updateBar("dlBarTrack", "dlBarFill", pct)
  if launcher.view("dlProgressLabel") then
    launcher.view("dlProgressLabel"):setText(p.finished and ("安装完成（" .. pct .. "%）") or ("下载中 " .. pct .. "%…"))
  end
end

function onDownloadFinished(payload)
  local p = payload or {}
  if not launcher.view("dlProgressLabel") then return end
  if p.cancelled then
    launcher.view("dlProgressLabel"):setText("下载已取消")
    updateBar("dlBarTrack", "dlBarFill", 0)
  elseif p.success then
    launcher.view("dlProgressLabel"):setText("安装完成：" .. tostring(p.versionId or PLC.mc or ""))
    refreshHomeVersionList()
    refreshVsInstall()
  else
    launcher.view("dlProgressLabel"):setText("下载失败：" .. tostring(p.error or "未知错误"))
  end
end

function onRemoteVersions(payload)
  refreshDownloadVersions()
end

function onCommunityResults(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  for i = 1, CONFIG.download.communitySlots do
    local it = items[i]
    local row = launcher.view("dlComm_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("dlComm_" .. i .. "_title"):setText(it.title or "未知资源")
        local author = it.author or ""
        launcher.view("dlComm_" .. i .. "_meta"):setText((author ~= "") and (author .. " · 下载 " .. tostring(it.downloads or 0)) or ("下载 " .. tostring(it.downloads or 0)))
      end
    end
  end
  dlCommItems = items
  launcher.view("dlCommStatus"):setText(#items == 0 and "未找到结果，换个关键词试试。" or ("共 " .. #items .. " 条结果，点击条目下载最新版本。"))
end

function onCommunityStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or ""
  if msg == "" then return end
  if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText(msg) end
end

function onCommunityProgress(payload)
  local p = (type(payload) == "table" and payload.items and payload.items[1]) or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  launcher.view("dlCommBarBox"):setVisible(true)
  updateBar("dlCommBarTrack", "dlCommBarFill", pct)
  launcher.view("dlCommBarLabel"):setText(p.finished and "下载完成" or ("下载中 " .. pct .. "%…"))
end

function onCommunityKeyword(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  dlKeyword = (items[1] ~= nil) and items[1] or ""
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or "点击输入关键词…")
end

function onModsUpdated(payload)
  refreshMods()
end

function onShadersUpdated(payload)
  refreshShadersInto("vsShade_", "vsShadeEmpty")
  refreshShadersInto("vsRp_", "vsRpEmpty")
end

function onMultiplayerStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "联机状态已更新"
  for kind, cfg in pairs(MP_UI) do
    if cfg.status and launcher.view(cfg.status) then launcher.view(cfg.status):setText(msg) end
    refreshMp(kind)
  end
end

function onMultiplayerRooms(payload)
  for kind in pairs(MP_UI) do refreshMp(kind) end
end

function onMultiplayerProgress(payload)
  local msg = (type(payload) == "table" and payload.message) or "连接中…"
  for _, cfg in pairs(MP_UI) do
    if cfg.status and launcher.view(cfg.status) then launcher.view(cfg.status):setText(msg) end
  end
end

-- ===== 点击分发（引擎传节点 id；baseId 归一化后按行 id 分发）=====
function onClick(id)
  if type(id) ~= "string" then return end
  launcher.log("[Lua.onClick] id=" .. id)
  for _, t in ipairs(TABS) do if t.id == id then selectTab(t.id) return end end
  if id == "cap.mojang" then selectCap(1) return end
  if id == "cap.microsoft" then selectCap(2) return end
  if id == "cap.offline" then selectCap(3) return end

  local base = baseId(id)

  -- ===== 启动页 =====
  if base == "Launch.Home.SelectInstance" then
    refreshHomeVersionList()
    setHomeStatus("已在右侧展开版本列表，点击版本即可切换。")
    return
  end
  if base == "Launch.Home.InstanceSettings" then launcher.action("open:version_settings") return end
  if base == "Launch.Home.Button.Loading" then setHomeStatus("正在启动游戏…") return end
  if base == "Launch.Home.Account.Login" then launcher.service("account", "manage", {}) return end
  local hv = base:match("^HomeVer_(%d+)$")
  if hv then selectHomeVersion(tonumber(hv)) return end

  -- ===== 下载页 =====
  local cat = DL_CAT[base]
  if cat then selectDownloadCat(cat) return end
  local dgh = base:match("^dlGh_(.+)$")
  if dgh then
    if #(dlGroups[dgh] or {}) == 0 then return end -- 清单为空时不展开
    dlOpenGroup[dgh] = not (dlOpenGroup[dgh] == true)
    refreshDownloadGroups()
    return
  end
  -- 注意：string.match 多捕获返回多值，必须分别接收
  local gkey, jStr = base:match("^dlGrpVer_(.+)_(%d+)$")
  if gkey then
    local it = (dlGroups[gkey] or {})[tonumber(jStr)]
    if it and it.id then
      PLC.mc = it.id
      PLC.mcOpen = false
      dlLevel = "install"
      refreshDownloadState()
      refreshInstallPanel()
    end
    return
  end
  if base == "dlMcToggle" then
    PLC.mcOpen = not PLC.mcOpen
    for i = 1, (CONFIG.download.maxVersionRows or 12) do
      local rowV = launcher.view("dlIv_" .. i)
      if rowV then rowV:setVisible(PLC.mcOpen and flatVersions[i] ~= nil) end
    end
    return
  end
  local mcv = base:match("^dlIv_(%d+)$")
  if mcv then
    local it = flatVersions[tonumber(mcv)]
    if it and it.id then
      PLC.mc = it.id
      PLC.mcOpen = false
      refreshInstallPanel()
    end
    return
  end
  if base == "dlBackGrp" then dlLevel = "groups" refreshDownloadState() return end
  if base == "insStart" then
    if PLC.mc == "" or PLC.mc == nil then
      launcher.view("dlProgress"):setVisible(true)
      launcher.view("dlProgressLabel"):setText("请先选择 Minecraft 版本")
      return
    end
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("准备下载 " .. PLC.mc .. " …")
    updateBar("dlBarTrack", "dlBarFill", 0)
    launcher.service("download", "start", { versionId = PLC.mc })
    return
  end
  if base == "dlCancel" then launcher.service("download", "cancel", {}) return end

  -- 社区资源
  if base == "dlSrcRow" then
    dlSourceIdx = (dlSourceIdx % #dlSources) + 1
    launcher.view("dlSrcVal"):setText(commSource().name or "…")
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText("已切换搜索源，请重新搜索。")
    return
  end
  if base == "dlObjRow" then return end
  if base == "dlKwRow" then launcher.service("community", "promptKeyword", { category = commCategory() }) return end
  if base == "dlBtnSearch" then doCommunitySearch() return end
  if base == "dlBtnReset" then
    dlKeyword = ""
    refreshCommunitySearch()
    return
  end
  local ci = base:match("^dlComm_(%d+)$")
  if ci then
    local it = dlCommItems[tonumber(ci)]
    if it and not commDownloading then
      commDownloading = true
      launcher.view("dlCommBarBox"):setVisible(true)
      updateBar("dlCommBarTrack", "dlCommBarFill", 0)
      launcher.view("dlCommBarLabel"):setText("准备下载…")
      launcher.view("dlCommStatus"):setText("准备下载「" .. (it.title or "") .. "」最新版本…")
      launcher.service("community", "download", { source = commSource().id, category = commCategory(), projectId = it.id, title = it.title })
    end
    return
  end

  -- ===== 设置页 =====
  local sc = base:match("^stCat_(.+)$")
  if sc then
    setSelCat = sc
    refreshSidebarGroups("stCat_", CONFIG.settings.groups, setSelCat)
    refreshSettingsContent()
    refreshSettingsData()
    return
  end
  local sl = base:match("^setL_(.+)$")
  if sl then cycleVS("setL_", sl) return end
  local sj = base:match("^setJ_(.+)$")
  if sj then cycleVS("setJ_", sj) return end
  if base == "setLReset" or base == "setJReset" then
    launcher.service("versionSettings", "reset", {})
    refreshSettingsData()
    setStatusText("已重置版本独立设置。")
    return
  end
  local gdp = base:match("^gdPick_(%d+)$") or base:match("^gd_(%d+)$")
  if gdp then
    local r = launcher.service and launcher.service("gameDir", "list", {}) or nil
    local its = (type(r) == "table" and type(r.items) == "table") and r.items or {}
    local m = its[tonumber(gdp)]
    if m and type(m.name) == "string" and m.name ~= "" then
      launcher.service("gameDir", "set", { name = m.name })
      refreshGameDir()
    end
    return
  end
  if base == "gdCreate" then
    local name = (launcher.view("gdNewIn") and launcher.view("gdNewIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if name ~= "" and name ~= "输入新目录名…" then
      launcher.service("gameDir", "new", { name = name })
      refreshGameDir()
    end
    return
  end
  local stok = base:match("^setTok_(.+)$")
  if stok then
    launcher.action("open_subpage:" .. stok)
    setStatusText("「" .. tostring(TOKEN_LABEL[stok] or stok) .. "」为引擎原生设置页。")
    return
  end
  if base == "setLangRow" then
    langIdx = (langIdx % #LANGS) + 1
    launcher.view("setLangVal"):setText(LANGS[langIdx])
    setStatusText("界面语言预览：" .. LANGS[langIdx])
    return
  end
  if base == "aboutUpdateBtn" then
    local d = describe()
    launcher.view("aboutUpdateStatus"):setText("引擎未提供在线更新检查服务；当前版本 " .. tostring(d.version or "未知") .. "。")
    return
  end
  if base == "aboutFeedbackBtn" then
    launcher.view("aboutFeedbackText"):setText("反馈请通过启动器原生页面提交；引擎未暴露反馈服务。")
    return
  end

  -- ===== 更多页 =====
  local mc = base:match("^moreCat_(.+)$")
  if mc then
    moreSelCat = mc
    refreshSidebarGroups("moreCat_", CONFIG.more.groups, moreSelCat)
    refreshMoreContent()
    return
  end
  if base == "testOpenDir" then launcher.service("versionSettings", "openDir", {}) return end
  if base == "testOpenMods" then launcher.service("versionSettings", "openMods", {}) return end
  if base == "testOpenSaves" then launcher.service("versionSettings", "openSaves", {}) return end
  if base == "testRefresh" then refreshTest() return end

  -- ===== 版本设置页 =====
  local vcat = base:match("^vsCat_(.+)$")
  if vcat then
    vsSelCat = vcat
    refreshSidebarGroups("vsCat_", CONFIG.versions.groups, vsSelCat)
    refreshVsContent()
    refreshVsData()
    return
  end
  local vk = base:match("^vset_(.+)$")
  if vk then cycleVS("vset_", vk) return end
  if base == "vsetReset" then
    launcher.service("versionSettings", "reset", {})
    refreshVsData()
    return
  end
  local vi = base:match("^vsInst_(%d+)$")
  if vi then
    local resp = launcher.service and launcher.service("version", "list", {}) or nil
    local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
    local it = items[tonumber(vi)]
    if it and it.id then launcher.service("version", "select", { id = it.id }) refreshVsData() end
    return
  end
  if base == "vsInstOpenDir" or base == "vsOpenDir" or base == "vsExportOpenDir" or base == "vsShotsOpenDir" or base == "vsLitOpenDir" then
    launcher.service("versionSettings", "openDir", {})
    return
  end
  if base == "vsOpenSaves" or base == "vsSavesOpen" then launcher.service("versionSettings", "openSaves", {}) return end
  if base == "vsOpenMods" or base == "vsModOpenDir" or base == "vsShadeOpenDir" or base == "vsRpOpenDir" then
    launcher.service("versionSettings", "openMods", {})
    return
  end
  local vmt = base:match("^vsModT_(%d+)$")
  if vmt then launcher.service("mods", "toggle", { index = tonumber(vmt) - 1 }) return end
  local vmx = base:match("^vsModX_(%d+)$")
  if vmx then launcher.service("mods", "delete", { index = tonumber(vmx) - 1 }) return end
  local vst = base:match("^vsShadeT_(%d+)$")
  if vst then launcher.service("shaders", "toggle", { index = tonumber(vst) - 1 }) return end
  local vsx = base:match("^vsShadeX_(%d+)$")
  if vsx then launcher.service("shaders", "delete", { index = tonumber(vsx) - 1 }) return end
  if base == "vsModRefresh" then launcher.service("mods", "refresh", {}) return end
  if base == "vsShadeRefresh" or base == "vsRpRefresh" then launcher.service("shaders", "refresh", {}) return end
  if base == "vsDeleteTop" then launcher.service("versionSettings", "delete", {}) return end

  -- ===== 联机（三种前缀共用）=====
  for kind, cfg in pairs(MP_UI) do
    if base == cfg.join and cfg.join then launcher.service("multiplayer", "promptJoin", {}) return end
    if base == cfg.create and cfg.create then launcher.service("multiplayer", "promptCreate", {}) return end
    if base == cfg.share and cfg.share then launcher.service("multiplayer", "share", {}) return end
    local ci2 = base:match("^" .. cfg.connect .. "(%d+)$")
    if ci2 then connectMp(kind, tonumber(ci2)) return end
    local di2 = base:match("^" .. cfg.del .. "(%d+)$")
    if di2 then deleteMp(kind, tonumber(di2)) return end
  end
  if base == "mpRefresh" then refreshMp("mp") return end
end