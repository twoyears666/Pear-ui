-- Pear 启动器 · 暖茶琥珀 UI 包 —— v0.1.0-beta
--
-- 全新视觉：暖调茶室风。深琥珀顶栏 + 奶油米色渐变底 + 白卡/暖金描边。
-- 与 PCL 蓝色系无任何关联、非克隆，从零设计、数据驱动以支持材质包。
--
-- 契约（引擎通用，零特例）：
--   尺寸：全部按窗口高 1H 比例（vh = 0.01H）；横向用 %。最小可点区域 >= 0.06H。
--   布局：只通过容器组件（split_column/vertical_flow/card/row_item/row/column）表达，
--         禁止绝对定位、禁止规格外元素。所有子元素只在父容器内流式排布。
--   主题：仅浅色（暖茶色系），禁止任何深色/黑色兜底（背景必须在 colors.json）。
--   页面：内容区 content 挂纯 Lua 页子树，页 token ∈ CONFIG.pages。

function describe()
  return { name = "暖茶琥珀", version = "0.1.1-beta" }
end

local C = {
  topbar      = "$color:topbar",
  pageFrom    = "$color:pageFrom",
  pageTo      = "$color:pageTo",
  bg          = "$color:background_start",
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
  pink        = "$color:brandPink",
  cyan        = "$color:brandCyan",
  hintBg      = "$color:faintBlue",
  faintBlue   = "$color:faintBlue",
  fieldBorder = "$color:fieldBorder",
}

local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local SHADOW   = { blur = "0.3vh", opacity = 0.08, x = 0, y = "0.15vh" }

local setSelCat = "launcher_settings"

local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:cup.and.saucer.fill",
    action = "open:home",     page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",
    action = "open:download", page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:wifi",
    action = "open:multiplayer", page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:slider.horizontal.3",
    action = "open:settings",   page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",
    action = "open:more",       page = "more" },
}

local PAGE_TAB = {
  home = "tab.home", download = "tab.download", multi = "tab.multi",
  settings = "tab.setup", more = "tab.other",
}

local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore", version_settings = "pageVersionSettings",
    versionManager = "pageVersionManager", accountManager = "pageAccountManager",
    gameDirectory = "pageGameDirectory", versionDetail = "pageVersionDetail",
  },
  download = {
    segRows = {
      { "最新版本", "正式版", "快照" },
      { "Mods", "光影", "整合包" },
    },
    latest = {
      { icon = "sf:cup.and.saucer.fill",  tint = C.orange, title = "最新 Java 版本", sub = "正式版 · 稳定 · 更新于 ···" },
      { icon = "sf:cart.fill",            tint = C.green,  title = "光影整合包",     sub = "光影 · 热门 · 更新于 ···" },
      { icon = "sf:map.fill",             tint = C.cyan,   title = "地图资源",       sub = "地图 · 精选 · 更新于 ···" },
    },
    searchLabels = { "搜索源", "搜索对象", "搜索关键词" },
    searchSources = { { id = "modrinth", name = "Modrinth" }, { id = "curseforge", name = "CurseForge" } },
    searchObjects = { "mod", "modpack", "datapack", "resourcepack", "shader" },
    keywordPlaceholder = "点击输入关键词…",
    searchStatusPreset = "点击「搜索」获取社区资源，点击结果条目可下载最新版本",
    vanillaTypes = { "最新版本", "正式版", "快照" },
    installHint = "安装后请留意版本与 Mod 兼容性；Fabric/Forge 需安装对应加载器。",
    loaders = { "无", "Fabric", "Forge", "Quilt", "NeoForge" },
    mcLabel = "Minecraft",
    compVersionSlots = 4,
    compConflictTip = "与 Forge 不兼容",
    conflictTip2 = "与对应的加载器不兼容",
    conflicts = { { a = "Forge", b = "Fabric" }, { a = "Forge", b = "Quilt" }, { a = "Forge", b = "NeoForge" } },
    maxVersionRows = 12,
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "测试版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
  },
  online = {
    branch = { "局域网", "在线" },
    rooms = {},
  },
  settingsGroups = {
    { id = "launcher_settings", label = "启动器设置", rows = {
        { type = "toggle", label = "启动器主题",    key = "theme" },
        { type = "select", label = "界面语言",      key = "lang",  options = { "简体中文", "English" } },
        { type = "switch", label = "检查更新",      key = "checkUpdate" },
        { type = "button", label = "打开日志目录",  key = "logs" },
      } },
    { id = "download_mirror", label = "下载镜像策略", rows = {
        { type = "select", label = "下载源", key = "source", options = { "自动", "BMCLAPI", "MCBBS" } },
        { type = "switch", label = "自动检测延迟", key = "ping" },
      } },
    { id = "video_settings", label = "视频设置", rows = {
        { type = "toggle", label = "垂直同步", key = "vsync" },
        { type = "toggle", label = "最大帧率", key = "fps" },
        { type = "select", label = "画面质量", key = "gfx", options = { "流畅", "均衡", "高品质" } },
      } },
    { id = "account_settings", label = "账号管理", rows = {
        { type = "button", label = "添加账号",  key = "addAccount" },
        { type = "button", label = "退出登录",  key = "logout" },
      } },
  },
  settingsGroupNames = { "常规", "下载", "视频", "账号" },
  settingsStatus = "设置保存以输入为准，开关与选项即时生效。",
  moreGroups = {
    { name = "资源", rows = {
        { id = "moreDefaultVersion", icon = "sf:cube.fill", label = "默认版本",
          right = "version", action = "open:versionManager" },
        { id = "moreVersions", icon = "sf:square.grid.3x3.fill", label = "版本管理",
          right = "chevron", action = "open:versionManager" },
        { id = "moreMods", icon = "sf:shippingbox.fill", label = "资源中心",
          right = "chevron", action = "open:mods" },
      } },
    { name = "高级", rows = {
        { id = "moreDirectory", icon = "sf:folder.fill", label = "游戏目录",
          right = "chevron", action = "open:gameDirectory" },
        { id = "moreAccount", icon = "sf:person.crop.circle.fill", label = "账号管理",
          right = "chevron", action = "open:accountManager" },
      } },
    { name = "帮助", rows = {
        { id = "moreAbout", icon = "sf:info.circle.fill", label = "关于加载器",
          right = "chevron", action = "open:more" },
        { id = "moreLogs", icon = "sf:doc.text.fill", label = "日志",
          right = "chevron", action = "open:more" },
      } },
  },
  versionManager = {
    title = "版本管理",
    addAction = "open:download",
    emptyText = "尚未安装任何游戏版本，可前往下载页获取。",
  },
  accountManager = {
    title = "账号管理",
    addAction = "open:settings",
    emptyText = "暂无已登录账号，登录后即可联机同步。",
  },
  gameDirectory = {
    title = "游戏目录",
    emptyText = "尚未创建其他游戏目录，可在下方输入目录名新建。",
    addPlaceholder = "输入新目录名…",
  },
  vs_categories = {
    { token = "overview",  label = "概览"   },
    { token = "settings",  label = "设置"   },
    { token = "mods",      label = "Mod 管理" },
    { token = "advanced",  label = "高级"   },
  },
}

-- 通用卡片：70% 宽 / 圆角 1vh / 白底 / 边框 / 阴影 / hover（打包统一结构）
local function card(id, children, opts)
  opts = opts or {}
  return ui.column { id = id, width = opts.width or "100%", crossAlign = "stretch",
    background = C.card, border = opts.border or BORDER, corner = opts.corner or "1vh",
    shadow = SHADOW, padding = opts.padding or "1.5vh", spacing = opts.spacing or "0.8vh",
    hoverColor = opts.hoverColor, children = children }
end

local function chevron()
  return ui.image { icon = "sf:chevron.right", size = "2.4vh", style = { tint = C.mid } }
end

local function topTab(t)
  return ui.row { id = t.id, action = t.action, width = "auto", crossAlign = "center",
    spacing = "0.8vh", padding = { left = "1.5vh", right = "1.5vh", top = "0.6vh", bottom = "0.6vh" },
    corner = "pill", background = C.transparent, children = {
      ui.image { icon = t.icon, size = "2.6vh", style = { tint = C.white } },
      ui.text { text = t.label, style = { font = "2.4vh", weight = "bold", color = C.white } },
    } }
end

local function bodyCard(children, opts)
  opts = opts or {}
  return ui.column { width = "94%", crossAlign = "stretch", background = C.card,
    border = BORDER, corner = "1.2vh", shadow = SHADOW, padding = opts.padding or "2.5vh",
    spacing = opts.spacing or "1.2vh", children = children }
end

-- ============ 首页侧栏（左列 32%）============
local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.row { id = "meRow", width = "100%", height = "13vh", crossAlign = "center",
    spacing = "1.5vh", padding = "1.2vh", children = {
      ui.image { id = "meAvatar", icon = "sf:cup.and.saucer", size = "7vh", corner = "pill",
        background = C.accent, style = { tint = C.white } },
      ui.column { weight = 1, spacing = "0.4vh", children = {
        ui.text { id = "accountName", text = "未登录", style = { font = "2.8vh", weight = "bold", color = C.dark } },
        ui.text { id = "accountType", text = "离线", style = { font = "2vh", color = C.mid } },
      } },
    } }
  kids[#kids + 1] = ui.row { id = "launchPrimary", height = "6.5vh", width = "100%", crossAlign = "center",
    justify = "center", background = C.accent, corner = "1vh", padding = "1.2vh",
    action = "open:home", hoverColor = C.accentBorder, children = {
      ui.image { icon = "sf:play.fill", size = "2.8vh", style = { tint = C.white } },
      ui.text { text = "启动游戏", style = { font = "2.6vh", weight = "bold", color = C.white } },
    } }
  kids[#kids + 1] = ui.text { text = "启动选项", width = "100%",
    style = { font = "2vh", weight = "bold", color = C.mid } }
  local rows = {
    { id = "launchVer",  icon = "sf:cube.fill",         label = "版本",        right = "value", action = "open:versionManager" },
    { id = "launchDir",  icon = "sf:folder.fill",       label = "版本隔离",    right = "value", action = "open:gameDirectory" },
    { id = "launchMem",  icon = "sf:memorychip.fill",   label = "内存分配",    right = "value", action = "open:settings" },
    { id = "launchJava", icon = "sf:chevron.left.forwardslash.chevron.right", label = "Java", right = "value", action = "open:settings" },
  }
  for _, r in ipairs(rows) do
    local rightNode = ui.text { id = r.id .. "_v", text = "· · ·", style = { font = "2.2vh", color = C.mid } }
    kids[#kids + 1] = ui.row { id = r.id, width = "100%", height = "6vh", crossAlign = "center",
      spacing = "1.4vh", padding = "1.2vh", corner = "1vh", hoverColor = C.hover, action = r.action, children = {
        ui.image { icon = r.icon, size = "3.6vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
        ui.text { text = r.label, weight = 1, style = { font = "2.4vh", color = C.dark } },
        rightNode,
      } }
  end
  return kids
end

-- ============ 首页（右区 68%）============
local function buildHomePage()
  local kids = {}
  local hero = bodyCard({
    ui.text { text = "欢迎回来", width = "100%", style = { font = "4.5vh", weight = "bold", color = C.dark } },
    ui.text { text = "在暖意满满的茶室风格界面里，开始你的新冒险。",
      width = "100%", style = { font = "2.5vh", color = C.mid } },
  }, { spacing = "1vh" })
  kids[#kids + 1] = hero
  local entries = {
    { id = "homeVersions", icon = "sf:cube.fill",         tint = C.orange, title = "版本管理", sub = "查看与安装游戏版本",
      action = "open:versionManager" },
    { id = "homeDownload", icon = "sf:arrow.down.circle.fill", tint = C.green, title = "下载", sub = "下载游戏、Mod 与整合包",
      action = "open:download" },
    { id = "homeMulti",    icon = "sf:wifi",               tint = C.cyan, title = "联机", sub = "局域网或在线联机",
      action = "open:multiplayer" },
    { id = "homeSettings", icon = "sf:slider.horizontal.3", tint = C.purple, title = "设置", sub = "自定义启动器行为",
      action = "open:settings" },
  }
  kids[#kids + 1] = ui.column { width = "94%", spacing = "1.6vh", crossAlign = "stretch", children = {
    ui.text { text = "常用功能", width = "100%", style = { font = "2.6vh", weight = "bold", color = C.dark } },
    (function()
      local cells = {}
      for _, e in ipairs(entries) do
        cells[#cells + 1] = ui.row { id = e.id, action = e.action, height = "12vh", width = "100%",
          crossAlign = "center", spacing = "1.6vh", corner = "1.2vh", padding = "1.5vh",
          background = C.card, border = BORDER, shadow = SHADOW, hoverColor = C.hover, children = {
            ui.image { icon = e.icon, size = "6vh", corner = "1.2vh", background = { from = e.tint, to = e.tint, angle = 0 },
              style = { tint = C.white } },
            ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
              ui.text { text = e.title, style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = e.sub, style = { font = "2.2vh", color = C.mid } },
            } },
            chevron(),
          } }
      end
      return ui.column { width = "100%", spacing = "1.6vh", crossAlign = "stretch", children = cells }
    end)(),
  } }
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.8vh", children = kids }
end

-- ============ 下载页（垂直流：预览卡 → Minecraft → 组件）============
local PLC = {} -- 选择状态
local dlLevel = "groups"
local dlOpenGroup = {}
local dlGroups = {}
local flatVersions = {}
local compOpen = {}
local compSel = {}
local dlLoader = 1
local dlSelCat = 1
local dlKeyword = ""
local dlCommItems = {}
local dlCurrent = nil -- 版本详情页当前版本

local function refreshInstallPanel()
  for i = 1, CONFIG.download.compVersionSlots do
    local sel = compSel[i]
    local lab = launcher.view("dlCompVer_" .. i)
    if lab then lab:setText((sel == nil) and "未选择" or "已选择") end
  end
  local iv = launcher.view("insVersion")
  if iv then iv:setText(PLC.mc ~= "" and PLC.mc or "未选择版本") end
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
            hoverColor = C.hover, children = {
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
  local resp = launcher.service("download", "versions") or {}
  local groups = (type(resp.groups) == "table") and resp.groups or {}
  dlGroups = groups
  flatVersions = {}
  for _, it in ipairs(groups.release or {}) do flatVersions[#flatVersions + 1] = it end
  refreshDownloadGroups()
end

local function refreshDownloadState()
  if launcher.view("dlGroupsCard") then launcher.view("dlGroupsCard"):setVisible(dlLevel == "groups") end
  if launcher.view("dlvRoot") then launcher.view("dlvRoot"):setVisible(dlLevel == "install") end
end

local function buildMinecraftCard()
  return card("dlMc", {
    ui.row { id = "dlMcH", width = "100%", height = "6.5vh", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, action = "dlMcToggle", children = {
        ui.image { icon = "sf:cube.fill", size = "4vh", corner = "1vh", background = { from = C.accent, to = C.orange, angle = 30 },
          style = { tint = C.white } },
        ui.text { text = CONFIG.download.mcLabel .. " · 版本", weight = 1,
          style = { font = "2.6vh", weight = "bold", color = C.dark } },
        ui.text { id = "dlMcVersion", text = PLC.mc ~= "" and PLC.mc or "未选择",
          style = { font = "2.4vh", color = C.accent } },
        chevron(),
      } },
    ui.column { id = "dlMcList", width = "100%", visible = false, spacing = "0.4vh", children = {} },
  }, { padding = "0.8vh" })
end

local function buildComponentCard(i)
  local rows = {}
  for j = 1, CONFIG.download.compVersionSlots do
    rows[#rows + 1] = ui.row { id = "dlCompV_" .. i .. "_" .. j, height = "5.5vh",
      crossAlign = "center", spacing = "1.4vh", hoverColor = C.hover, action = "dlCompV:" .. i .. ":" .. j, display = false,
      children = {
        ui.image { icon = "sf:arrow.right.circle.fill", size = "3.2vh", style = { tint = C.accent } },
        ui.text { text = "组件版本 " .. j, weight = 1, style = { font = "2.4vh", color = C.dark } },
      } }
  end
  return card("dlComp_" .. i, {
    ui.row { id = "dlCompH_" .. i, width = "100%", height = "6.5vh", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, action = "dlCompH:" .. i, children = {
        ui.image { icon = "sf:shippingbox.fill", size = "4vh", corner = "1vh",
          background = { from = C.green, to = C.cyan, angle = 30 }, style = { tint = C.white } },
        ui.text { text = "组件 " .. i, weight = 1, style = { font = "2.6vh", color = C.dark } },
        ui.text { id = "dlCompVer_" .. i, text = "未选择", style = { font = "2.3vh", color = C.mid } },
        chevron(),
      } },
    ui.column { id = "dlCompList_" .. i, width = "100%", visible = false, spacing = "0.4vh", children = rows },
  }, { padding = "0.8vh" })
end

local function buildVersionGroupsCard()
  local grpChildren = {}
  for _, g in ipairs(CONFIG.download.versionGroups) do
    local key = g.key
    grpChildren[#grpChildren + 1] = ui.column { width = "100%", spacing = "0", children = {
      ui.row { id = "dlGh_" .. key, height = "6.5vh", width = "100%", crossAlign = "center",
        spacing = "1.5vh", hoverColor = C.hover, action = "dlGh_" .. key, children = {
          ui.image { icon = "sf:list.bullet", size = "3.6vh", corner = "pill",
            background = C.hintBg, style = { tint = C.accent } },
          ui.text { text = g.name, weight = 1, style = { font = "2.6vh", color = C.dark } },
          ui.text { id = "dlGh_" .. key .. "_cnt", text = "▸", style = { font = "2.4vh", color = C.mid } },
        } },
      ui.column { id = "dlGrpList_" .. key, width = "100%", visible = false,
        spacing = "0.3vh", padding = { left = "1vh" }, children = {} },
    } }
  end
  return card("dlGroupsCard", {
    ui.text { text = "选择要安装的原版版本", width = "100%",
      style = { font = "2.6vh", weight = "bold", color = C.dark } },
    ui.column { width = "100%", spacing = "0.2vh", children = grpChildren },
  })
end

local function buildInstallPreview()
  return card("dlvRoot", {
    ui.row { id = "dlBackGrp", height = "5vh", crossAlign = "center", spacing = "1vh",
      hoverColor = C.hover, action = "dlBackGrp", children = {
        ui.image { icon = "sf:chevron.left", size = "2.6vh", style = { tint = C.accent } },
        ui.text { text = "版本列表", style = { font = "2.4vh", color = C.accent } },
      } },
    ui.row { height = "10vh", crossAlign = "center", spacing = "2vh", padding = "1vh", children = {
      ui.image { icon = "sf:cube.fill", size = "7vh", corner = "1.4vh",
        background = { from = C.accent, to = C.orange, angle = 45 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.6vh", children = {
        ui.text { id = "insVersion", text = "未选择版本",
          style = { font = "3vh", weight = "bold", color = C.dark } },
        ui.text { id = "insMcVer",  text = "Minecraft", style = { font = "2.4vh", color = C.mid } },
      } },
    } },
    ui.divider { height = "0.08vh", background = C.cardBorder },
    ui.text { text = "安装名称", width = "100%", style = { font = "2.2vh", weight = "bold", color = C.dark } },
    ui.input { id = "insNameIn", width = "100%", height = "6vh", placeholder = "输入版本名称（留空为默认）",
      corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
    ui.row { height = "7vh", crossAlign = "center", justify = "end", spacing = "1.5vh", children = {
      ui.text { text = CONFIG.download.installHint, weight = 1, style = { font = "2vh", color = C.mid } },
      ui.row { id = "insStart", action = "insStart", corner = "pill", padding = { left = "3vh", right = "3vh", top = "1vh", bottom = "1vh" },
        background = C.accent, hoverColor = C.accentBorder, children = {
          ui.text { text = "开始安装", style = { font = "2.5vh", weight = "bold", color = C.white } },
        } },
    } },
    ui.row { id = "dlProgress", width = "100%", visible = false, crossAlign = "center", spacing = "1vh",
      padding = "1vh", children = {
        ui.text { id = "dlProgressLabel", text = "", weight = 1, style = { font = "2.2vh", color = C.dark } },
        ui.row { width = "40%", height = "1.4vh", corner = "pill", background = C.hintBg, children = {
          ui.row { id = "dlBarFill", width = "0%", height = "100%", corner = "pill",
            background = C.accent, children = {} },
        } },
      } },
  }, { spacing = "1vh" })
end

local function buildDownloadPage()
  local kids = {}
  kids[#kids + 1] = card("dlGroupsWrap", {
    buildVersionGroupsCard(),
  }, { padding = "0.5vh", width = "94%" })
  kids[#kids + 1] = ui.column { width = "94%", spacing = "1.8vh", crossAlign = "stretch", children = {
    buildInstallPreview(),
    buildMinecraftCard(),
    buildComponentCard(1),
    buildComponentCard(2),
    ui.row { id = "dlSelCatRow", width = "100%", spacing = "1.2vh", crossAlign = "center", children = {
      ui.text { text = "社区资源", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.dark } },
      ui.row { id = "dlCommSearch", action = "dlCommSearch", corner = "pill", padding = { left = "2.5vh", right = "2.5vh", top = "0.8vh", bottom = "0.8vh" },
        background = C.accent, children = { ui.text { text = "搜索", style = { font = "2.4vh", weight = "bold", color = C.white } } } },
      ui.row { id = "dlCommKeyword", action = "dlCommKeyword", corner = "pill", padding = { left = "2.5vh", right = "2.5vh", top = "0.8vh", bottom = "0.8vh" },
        background = C.card, border = BORDER, children = { ui.text { text = "关键词", style = { font = "2.4vh", color = C.dark } } } },
    } },
    ui.text { id = "dlCommStatus", text = CONFIG.download.searchStatusPreset,
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    (function()
      local slots = {}
      for i = 1, 6 do
        slots[#slots + 1] = ui.row { id = "dlComm_" .. i, width = "100%", height = "6.5vh",
          crossAlign = "center", spacing = "1.5vh", hoverColor = C.hover, action = "dlComm:" .. i, display = false,
          children = {
            ui.image { icon = "sf:doc.richtext.fill", size = "4vh", corner = "pill",
              background = C.hintBg, style = { tint = C.accent } },
            ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
              ui.text { id = "dlComm_" .. i .. "_title", text = "· · ·",
                style = { font = "2.5vh", weight = "bold", color = C.dark } },
              ui.text { id = "dlComm_" .. i .. "_meta", text = "· · ·", style = { font = "2.1vh", color = C.mid } },
            } },
            ui.text { id = "dlComm_" .. i .. "_btn", text = "下载", style = { font = "2.3vh", color = C.accent } },
          } }
      end
      return card("dlCommCard", slots, { spacing = "0.3vh" })
    end)(),
  } }
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.8vh", children = kids }
end

-- ============ 联机页 ============
local function buildMultiPage()
  local kid = bodyCard({
    ui.text { text = "联机大厅", width = "100%", style = { font = "3vh", weight = "bold", color = C.dark } },
    ui.row { height = "6.5vh", crossAlign = "center", spacing = "1.5vh", children = {
      ui.text { text = "模式", style = { font = "2.4vh", color = C.mid } },
      ui.row { id = "segM_1", action = "segM:1", corner = "pill", padding = { left = "2.5vh", right = "2.5vh", top = "0.7vh", bottom = "0.7vh" },
        background = C.accent, children = { ui.text { text = "局域网", style = { font = "2.3vh", weight = "bold", color = C.white } } } },
      ui.row { id = "segM_2", action = "segM:2", corner = "pill", padding = { left = "2.5vh", right = "2.5vh", top = "0.7vh", bottom = "0.7vh" },
        background = C.card, border = BORDER, children = { ui.text { text = "在线", style = { font = "2.3vh", color = C.dark } } } },
    } },
    ui.text { id = "mpStatus", text = "选择模式后创建或加入房间。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
    ui.row { height = "7vh", crossAlign = "center", spacing = "1.5vh", children = {
      ui.row { id = "mpCreate", action = "mpCreate", corner = "pill", padding = { left = "3vh", right = "3vh", top = "0.8vh", bottom = "0.8vh" },
        background = C.accent, children = { ui.text { text = "创建房间", style = { font = "2.4vh", weight = "bold", color = C.white } } } },
      ui.row { id = "mpJoin",  action = "mpJoin",  corner = "pill", padding = { left = "3vh", right = "3vh", top = "0.8vh", bottom = "0.8vh" },
        background = C.card, border = BORDER, children = { ui.text { text = "加入房间", style = { font = "2.4vh", color = C.dark } } } },
    } },
  })
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = { kid } }
end

-- ============ 设置页（数据驱动：左侧目录 + 行内展开单卡）============
local function settingsRow(s)
  local id = "set_" .. s.key
  local right
  if s.type == "toggle" or s.type == "switch" then
    right = ui.row { id = id .. "_sw", action = "set_toggle:" .. s.key, height = "3.4vh", width = "7vh",
      corner = "pill", background = C.accent, children = {
        ui.row { height = "100%", justify = "end", crossAlign = "center", padding = { left = "0.6vh", right = "0.6vh", top = "0.4vh", bottom = "0.4vh" },
          children = { ui.row { height = "2.6vh", width = "2.6vh", corner = "pill", background = C.white } } },
      } }
  elseif s.type == "select" then
    right = ui.row { id = id .. "_v", action = "set_select:" .. s.key, corner = "pill",
      padding = { left = "2vh", right = "2vh", top = "0.6vh", bottom = "0.6vh" },
      background = C.card, border = BORDER_A, children = {
        ui.text { id = id .. "_val", text = (s.options and s.options[1]) or "···",
          style = { font = "2.3vh", color = C.accent } },
      } }
  elseif s.type == "button" then
    right = ui.row { id = id .. "_btn", action = "set_button:" .. s.key, corner = "pill",
      padding = { left = "2.5vh", right = "2.5vh", top = "0.6vh", bottom = "0.6vh" },
      background = C.card, border = BORDER_A, children = {
        ui.text { text = "执行", style = { font = "2.3vh", color = C.accent } },
      } }
  else
    right = ui.text { text = "···", style = { font = "2.3vh", color = C.mid } }
  end
  return ui.row { id = id, height = "6.5vh", width = "100%", crossAlign = "center",
    spacing = "1.5vh", hoverColor = C.hover, children = {
      ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
      right,
    } }
end

local function buildSettingsPage()
  local kids = {}
  local aboutCard = bodyCard({
    ui.image { icon = "sf:cup.and.saucer.fill", size = "9vh", corner = "1.8vh",
      background = { from = C.accent, to = C.orange, angle = 30 }, style = { tint = C.white } },
    ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
    ui.text { text = "版本 · · ·", style = { font = "2.2vh", color = C.mid } },
  }, { spacing = "0.8vh", crossAlign = "center" })
  kids[#kids + 1] = aboutCard
  local grpRows = {}
  for gi, g in ipairs(CONFIG.settingsGroups) do
    local rows = {}
    rows[#rows + 1] = ui.text { text = (CONFIG.settingsGroupNames[gi] or g.label),
      width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } }
    for _, s in ipairs(g.rows) do rows[#rows + 1] = settingsRow(s) end
    grpRows[#grpRows + 1] = ui.column { id = "setSec_" .. g.id, width = "94%", crossAlign = "center",
      spacing = "1.8vh", visible = (g.id == setSelCat), children = {
        card("setCard_" .. g.id, rows, { spacing = "0.8vh" }) } }
  end
  for _, v in ipairs(grpRows) do kids[#kids + 1] = v end
  kids[#kids + 1] = ui.row { id = "setStatusBar", width = "94%", background = C.hintBg,
    corner = "1vh", crossAlign = "center", spacing = "1.2vh", padding = "1.5vh", children = {
      ui.text { text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
      ui.text { id = "setStatus", weight = 1, text = CONFIG.settingsStatus,
        style = { font = "2.2vh", color = C.dark } },
    } }
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.8vh", children = kids }
end

-- ============ 更多页 ============
local function buildMorePage()
  local kids = {}
  kids[#kids + 1] = ui.column { width = "94%", spacing = "1.2vh", crossAlign = "stretch", children = {
    ui.text { text = "主题包", width = "100%", style = { font = "2.5vh", weight = "bold", color = C.dark } },
    bodyCard({
      ui.row { height = "6.5vh", crossAlign = "center", spacing = "1.6vh", padding = "1vh", children = {
        ui.image { icon = "sf:paintbrush.fill", size = "4.5vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
        ui.text { text = "主题包名称", weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = "moreThemeName_text", text = "暖茶琥珀", style = { font = "2.4vh", color = C.mid } },
      } },
      ui.row { height = "6.5vh", crossAlign = "center", spacing = "1.6vh", padding = "1vh", children = {
        ui.image { icon = "sf:tag.fill", size = "4.5vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
        ui.text { text = "主题包版本", weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = "moreThemeVersion", text = "· · ·", style = { font = "2.4vh", color = C.mid } },
      } },
    }, { padding = "0.8vh" }),
  } }
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, rr in ipairs(g.rows) do
      local rightNode
      if rr.right == "version" then
        rightNode = ui.text { id = rr.id .. "_val", text = "未选择", style = { font = "2.5vh", color = C.mid } }
      else
        rightNode = chevron()
      end
      rows[#rows + 1] = ui.row { id = rr.id, height = "7vh", crossAlign = "center",
        spacing = "1.6vh", padding = "1.4vh", hoverColor = C.hover, action = rr.action or "open:more", children = {
          ui.image { icon = rr.icon or "sf:gearshape.fill", size = "4.5vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
          ui.text { text = rr.label, weight = 1, style = { font = "2.6vh", color = C.dark } },
          rightNode,
        } }
    end
    kids[#kids + 1] = ui.column { width = "94%", spacing = "1.2vh", crossAlign = "stretch", children = {
      ui.text { text = g.name, width = "100%", style = { font = "2.5vh", weight = "bold", color = C.dark } },
      bodyCard(rows, { padding = "0.6vh", spacing = "0.3vh" }),
    } }
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.8vh", children = kids }
end

-- ============ 版本设置页 ============
local vsSelCat = "overview"
local VS_CATS = CONFIG.vs_categories or {}
local function buildVersionSettingsPage()
  local overview = card("vsOverviewCard", {
    ui.row { width = "100%", height = "11vh", crossAlign = "center", spacing = "2vh", padding = "1vh", children = {
      ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent, corner = "1.2vh", style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
        ui.text { id = "vsName", text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
        ui.text { id = "vsMeta", text = "版本信息 · · ·", style = { font = "2.1vh", color = C.mid } },
      } },
    } },
  }, { spacing = "1vh" })
  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.8vh", children = {
      bodyCard({
        ui.text { text = "版本设置", width = "100%", style = { font = "3vh", weight = "bold", color = C.dark } },
        overview,
      }, { spacing = "1.6vh" }),
    } }
end

-- ============ 版本详情页 ============
local function buildVersionDetailPage()
  return ui.column { id = "pageVersionDetail", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = {
      bodyCard({
        ui.text { text = "版本详情", width = "100%", style = { font = "3vh", weight = "bold", color = C.dark } },
        ui.row { height = "10vh", crossAlign = "center", spacing = "2vh", padding = "1vh", children = {
          ui.image { icon = "sf:cube.fill", size = "6.5vh", background = C.accent, corner = "1.2vh", style = { tint = C.white } },
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vdVersion", text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
            ui.text { id = "vdType", text = "类型 · · ·", style = { font = "2.2vh", color = C.mid } },
          } },
        } },
        ui.text { text = "加载器", width = "100%", style = { font = "2.2vh", weight = "bold", color = C.dark } },
        ui.row { width = "100%", spacing = "1.2vh", children = (function()
          local arr = {}
          for li, lname in ipairs(CONFIG.download.loaders) do
            arr[#arr + 1] = ui.row { id = "vdL_" .. li, action = "vdL:" .. li, corner = "pill",
              padding = { left = "2.5vh", right = "2.5vh", top = "0.7vh", bottom = "0.7vh" },
              background = (li == 1) and C.accent or C.card, border = BORDER_A, children = {
                ui.text { text = lname, style = { font = "2.3vh", color = (li == 1) and C.white or C.dark } },
              } }
          end
          return arr
        end)() },
        ui.divider { height = "0.08vh", background = C.cardBorder },
        ui.row { id = "vdInstall", action = "vdInstall", corner = "pill", alignSelf = "end",
          padding = { left = "4vh", right = "4vh", top = "1vh", bottom = "1vh" },
          background = C.accent, children = {
            ui.text { text = "下载并安装", style = { font = "2.5vh", weight = "bold", color = C.white } },
          } },
      }, { spacing = "1.4vh" }),
    } }
end

-- ============ 版本管理 / 账号 / 游戏目录 二级页 ============
local function buildVersionManagerPage()
  return ui.column { id = "pageVersionManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = {
      bodyCard({
        ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
          ui.text { text = CONFIG.versionManager.title, weight = 1,
            style = { font = "3vh", weight = "bold", color = C.dark } },
          ui.row { id = "vmAdd", action = CONFIG.versionManager.addAction, corner = "pill",
            padding = { left = "2.5vh", right = "2.5vh", top = "0.7vh", bottom = "0.7vh" },
            background = C.accent, children = { ui.text { text = "添加", style = { font = "2.3vh", weight = "bold", color = C.white } } } },
        } },
        ui.text { id = "vmEmpty", text = CONFIG.versionManager.emptyText,
          style = { font = "2.2vh", color = C.mid } },
      }, { spacing = "1.2vh" }),
    } }
end

local function buildAccountManagerPage()
  return ui.column { id = "pageAccountManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = {
      bodyCard({
        ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
          ui.text { text = CONFIG.accountManager.title, weight = 1,
            style = { font = "3vh", weight = "bold", color = C.dark } },
          ui.row { id = "amAdd", action = CONFIG.accountManager.addAction, corner = "pill",
            padding = { left = "2.5vh", right = "2.5vh", top = "0.7vh", bottom = "0.7vh" },
            background = C.accent, children = { ui.text { text = "添加", style = { font = "2.3vh", weight = "bold", color = C.white } } } },
        } },
        ui.text { text = CONFIG.accountManager.emptyText, style = { font = "2.2vh", color = C.mid } },
      }, { spacing = "1.2vh" }),
    } }
end

local function buildGameDirectoryPage()
  return ui.column { id = "pageGameDirectory", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = {
      bodyCard({
        ui.text { text = CONFIG.gameDirectory.title, width = "100%",
          style = { font = "3vh", weight = "bold", color = C.dark } },
        ui.input { id = "gdNameIn", width = "100%", height = "6vh", placeholder = CONFIG.gameDirectory.addPlaceholder,
          corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
        ui.text { text = CONFIG.gameDirectory.emptyText, style = { font = "2.2vh", color = C.mid } },
      }, { spacing = "1.4vh" }),
    } }
end

-- ============ 壳 + 构建 ============
function build(ui)
  local homeSidebar = buildHomeSidebar()
  local pageHome = buildHomePage()
  local contentChildren = {
    pageHome,
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
    id = "shell", crossAlign = "stretch", spacing = 0,
    children = {
      ui.row { id = "titlebar", height = "8.5vh", background = C.topbar, crossAlign = "center",
        padding = { left = "2vh", right = "1.5vh" },
        children = {
          ui.text { id = "logo", text = "暖茶", width = "10vh", style = { font = "3.2vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row { id = "tabs", spacing = "1.5vh", crossAlign = "center",
            children = (function()
              local nodes = {}
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
              return nodes
            end)() },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        } },
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0,
        children = {
          ui.column { id = "left", width = "32%", background = C.card, crossAlign = "center",
            spacing = "0.5vh", padding = { left = "2vh", right = "2vh", top = "1vh", bottom = "1vh" },
            children = {
              ui.column { id = "leftHome", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.5vh", children = homeSidebar },
            } },
          ui.content {
            id = "content", weight = 1, initialPage = "home",
            background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
            pages = CONFIG.pages,
            children = contentChildren,
          },
        } },
    },
  }
end

-- ===== 交互 =====
local currentPage = "home"
local CAPS_LABEL = { "离线", "Mojang", "微软" }

local function selectTab(tabId)
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.white, tint = C.accent, corner = "pill" }
      or  { background = C.transparent, tint = C.white, corner = "pill" })
  end
end

local function refreshAccount()
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  if launcher.view("accountName") then launcher.view("accountName"):setText(name) end
end

local function refreshVersion()
  local ver = launcher.state and launcher.state.version
  local v = launcher.view("launchVer_v")
  if v then v:setText((ver and ver.name) or "未选择") end
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
  if launcher.view("dlBarFill") then launcher.view("dlBarFill"):setStyle({ width = pct .. "%" }) end
  if launcher.view("dlProgressLabel") then
    launcher.view("dlProgressLabel"):setText(p.finished and ("安装完成（" .. pct .. "%）") or ("下载中 " .. pct .. "%…"))
  end
  if launcher.view("dlProgress") then launcher.view("dlProgress"):setVisible(true) end
end

function onRemoteVersions(payload) refreshDownloadVersions() end

function onCommunityResults(payload)
  dlCommItems = {}
  for _, it in ipairs((type(payload) == "table" and payload.items) or {}) do
    dlCommItems[#dlCommItems + 1] = it
  end
  for i = 1, 6 do
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
    launcher.view("dlCommStatus"):setText(#dlCommItems == 0 and "未找到相关资源。" or ("找到 " .. #dlCommItems .. " 条结果，点击条目可下载最新版本。"))
  end
end

function onCommunityStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "状态已更新"
  if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText(msg) end
end

function onCommunityProgress(payload) end
function onCommunityKeyword(payload) end

local function refreshSettingsSidebar()
  for _, g in ipairs(CONFIG.settingsGroups) do
    local sec = launcher.view("setSec_" .. g.id)
    if sec then sec:setVisible(g.id == setSelCat) end
  end
end

local function refreshMoreContent()
  local st = launcher.getState and launcher.getState() or {}
  local ui = (type(st.ui) == "table") and st.ui or nil
  if launcher.view("moreThemeName_text") and ui and ui.name and ui.name ~= "" then
    launcher.view("moreThemeName_text"):setText(ui.name)
  end
  if launcher.view("moreThemeVersion") and ui and ui.version and ui.version ~= "" then
    launcher.view("moreThemeVersion"):setText(ui.version)
  end
  for _, g in ipairs(CONFIG.moreGroups) do
    for _, rr in ipairs(g.rows or {}) do
      if rr.right == "version" and rr.id then
        local val = launcher.view(rr.id .. "_val")
        if val then
          if rr.id == "moreDefaultVersion" then
            local vi = (type(st.version) == "table" and st.version.name) or ""
            val:setText((vi ~= "" and vi) or "未选择")
          end
        end
      end
    end
  end
end

function onPageChange(page)
  currentPage = page
  launcher.view("titlebar"):setVisible(true)
  launcher.view("left"):setVisible(page ~= "versionManager"
    and page ~= "accountManager" and page ~= "gameDirectory" and page ~= "versionDetail"
    and CONFIG.settingsSubpages == nil)
  launcher.view("leftHome"):setVisible(page == "home")

  if page == "download" then
    refreshDownloadVersions()
    dlLevel = "groups"
    refreshDownloadState()
  elseif page == "settings" then
    refreshSettingsSidebar()
  elseif page == "more" then
    refreshMoreContent()
  end

  local tabId = PAGE_TAB[page]
  if tabId then selectTab(tabId) end
end

function onClick(id)
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id) return end
  end
  -- 下载
  if id == "dlMcToggle" then
    local mcn = launcher.service("download", "versions")
    refreshDownloadVersions()
    return
  end
  if id == "insStart" then
    local name = (launcher.view("insNameIn") and launcher.view("insNameIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if PLC.mc == "" or PLC.mc == nil then
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
  local dgh = id:match("^dlGh_(.+)$")
  if dgh then
    dlOpenGroup[dgh] = not (dlOpenGroup[dgh] == true)
    refreshDownloadGroups()
    return
  end
  local dgv = id:match("^dlGrpVer_(.+)_(%d+)$")
  if dgv then
    local it = (dlGroups[dgv[1]] or {})[tonumber(dgv[2])]
    if it and it.id then
      PLC.mc = it.id
      dlLevel = "install"
      refreshInstallPanel()
      refreshDownloadState()
      if launcher.view("dlMcVersion") then launcher.view("dlMcVersion"):setText(it.id) end
    end
    return
  end
  if id == "dlBackGrp" then
    dlLevel = "groups"
    refreshDownloadState()
    return
  end
  if id == "dlCommSearch" then
    launcher.service("community", "search", { keyword = (dlKeyword ~= "" and dlKeyword or "minecraft"),
      object = "mod" })
    if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText("正在搜索…") end
    return
  end
  if id == "dlCommKeyword" then
    launcher.service("community", "promptKeyword", { object = "mod" })
    return
  end
  local dim = id:match("^dlComm:(%d+)$")
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
  local segm = id:match("^segM:(%d+)$")
  if segm then return end
  -- 设置
  local sset = id:match("^set_toggle:(.+)$")
  if sset then return end
  local ssel = id:match("^set_select:(.+)$")
  if ssel then
    local v = launcher.view("set_" .. ssel .. "_val")
    if v then
      local txt = v:getText() or ""
      v:setText(txt == "···" and ssel .. " ✓" or "···")
      v:setStyle({ borderColor = C.success })
    end
    return
  end
  local sbtn = id:match("^set_button:(.+)$")
  if sbtn then return end
  -- 版本详情
  local vdl = id:match("^vdL:(%d+)$")
  if vdl then
    dlLoader = tonumber(vdl) or 1
    local loaders = CONFIG.download.loaders or {}
    for li = 1, #loaders do
      local b = launcher.view("vdL_" .. li)
      if b then
        b:setStyle((li == dlLoader)
          and { background = C.accent, borderColor = C.accentBorder }
          or  { background = C.card, borderColor = C.accentBorder })
        local txt = launcher.view("vdL_" .. li .. "_text")
      end
    end
    return
  end
  if id == "vdInstall" then
    if dlCurrent and dlCurrent.id then
      launcher.service("download", "start", { versionId = dlCurrent.id })
      launcher.action("open:download")
    end
    return
  end
end