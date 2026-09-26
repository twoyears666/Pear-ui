-- Pear 启动器 · HMCL 清风蓝调 UI 包 —— v0.1.0-beta
--
-- 视觉仿 HMCL（Hello Minecraft! Launcher）：
--   · 最左侧一条窄的纯图标导航栏（白底 + 选中浅蓝圆角高亮 + 蓝色图标）
--   · 主区大幅 hero 渐变横幅（#4C7FC4 → #8FB6DE，45°）
--   · 横幅右下角悬浮半透明白色圆角启动面板（头像 + 账号名/类型 + 蓝色药丸「启动游戏」）
--   · 其余为白色卡片 + 浅灰蓝描边(#E0E6EF) + 圆角 + 轻阴影，区块标题用 accent 蓝
--
-- 契约（引擎通用，零特例）：
--   尺寸：全部按窗口高 1H 比例（vh = 0.01H）；横向用 %。最小可点区域 >= 0.06H。
--   布局：只通过容器组件流式排布，禁止绝对定位。
--   主题：仅浅色；背景色一律来自 colors.json。
--   页面：内容区 content 挂纯 Lua 页子树，页 token ∈ CONFIG.pages。
--   点击：引擎派发下划线形式的节点 id，onClick 用 string.match 剥后缀/前缀匹配。

function describe()
  return { name = "清风蓝调", version = "0.1.0-beta" }
end

local C = {
  topbar       = "$color:topbar",
  pageFrom     = "$color:pageFrom",
  pageTo       = "$color:pageTo",
  bg           = "$color:background_start",
  bgEnd        = "$color:background_end",
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
  faintBlue    = "$color:faintBlue",
  fieldBorder  = "$color:fieldBorder",
  green        = "$color:brandGreen",
  orange       = "$color:brandOrange",
  purple       = "$color:brandPurple",
  pink         = "$color:brandPink",
  cyan         = "$color:brandCyan",
  surface      = "$color:surface",
  primary      = "$color:textPrimary",
  secondary    = "$color:textSecondary",
  border       = "$color:border",
}

local BORDER    = { width = "0.12vh", color = C.cardBorder }
local BORDER_A  = { width = "0.18vh", color = C.accentBorder }
local SHADOW    = { blur = "0.35vh", opacity = 0.10, x = 0, y = "0.16vh" }
-- hero 横幅渐变（HMCL 主视觉深蓝 → 浅蓝，包内无图片资源，用渐变模拟；色值取自 colors.json 便于换肤）
local HERO_FROM = "$color:heroFrom"
local HERO_TO   = "$color:heroTo"

-- ============ 窄图标导航栏（HMCL 最左侧竖排纯图标）============
local RAIL = {
  { id = "navHome",            icon = "sf:house.fill",                  action = "open:home",             page = "home" },
  { id = "navDownload",        icon = "sf:arrow.down.circle.fill",      action = "open:download",         page = "download" },
  { id = "navMulti",           icon = "sf:wifi",                        action = "open:multiplayer",      page = "multi" },
  { id = "navVersionManager",  icon = "sf:square.grid.3x3.fill",        action = "open:versionManager",   page = "versionManager" },
  { id = "navGameDirectory",   icon = "sf:folder.fill",                 action = "open:gameDirectory",    page = "gameDirectory" },
  { id = "navAccountManager",  icon = "sf:person.crop.circle.fill",     action = "open:accountManager",   page = "accountManager" },
  { id = "navVersionSettings", icon = "sf:wrench.and.screwdriver.fill", action = "open:version_settings", page = "version_settings" },
  { id = "navSettings",        icon = "sf:gearshape.fill",              action = "open:settings",         page = "settings" },
  { id = "navMore",            icon = "sf:ellipsis.circle.fill",        action = "open:more",             page = "more" },
}

local PAGE_RAIL = {}
for _, r in ipairs(RAIL) do PAGE_RAIL[r.page] = r.id end
PAGE_RAIL["versionDetail"] = "navVersionManager"

local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore", version_settings = "pageVersionSettings",
    versionManager = "pageVersionManager", accountManager = "pageAccountManager",
    gameDirectory = "pageGameDirectory", versionDetail = "pageVersionDetail",
  },
  download = {
    installHint = "安装后请留意版本与 Mod 兼容性；Fabric/Forge 需安装对应加载器。",
    searchStatusPreset = "点击「搜索」获取社区资源，点击结果条目可下载最新版本",
    communitySlots = 6,
    componentCount = 2,
    componentRows = 3,
    loaders = { "无", "Fabric", "Forge", "Quilt", "NeoForge" },
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "测试版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
  },
  multi = {
    branches = { "局域网", "在线" },
    preset = "选择模式后创建或加入房间。",
  },
  settingsGroups = {
    { id = "launcher_settings", label = "启动器设置", chip = "启动器", rows = {
        { type = "toggle", label = "跟随材质包主题", key = "theme" },
        { type = "select", label = "界面语言",       key = "lang",  options = { "简体中文", "English" } },
        { type = "toggle", label = "启动时检查更新", key = "checkUpdate" },
        { type = "button", label = "打开日志目录",   key = "logs" },
      } },
    { id = "download_mirror", label = "下载镜像策略", chip = "下载", rows = {
        { type = "select", label = "下载源",       key = "source", options = { "自动", "BMCLAPI", "MCBBS" } },
        { type = "toggle", label = "自动检测延迟", key = "ping" },
        { type = "toggle", label = "并发下载",     key = "parallel" },
      } },
    { id = "video_settings", label = "视频设置", chip = "视频", rows = {
        { type = "toggle", label = "垂直同步", key = "vsync" },
        { type = "toggle", label = "限制帧率", key = "fps" },
        { type = "select", label = "画面质量", key = "gfx", options = { "流畅", "均衡", "高品质" } },
      } },
    { id = "account_settings", label = "账号设置", chip = "账号", rows = {
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
        { type = "select", label = "游戏版本",   key = "vsVer", options = { "自动", "1.20.1", "1.19.4" } },
        { type = "button", label = "打开版本目录", key = "vsDir" },
      } },
    { id = "settings", rows = {
        { type = "toggle", label = "全屏启动",   key = "vsFull" },
        { type = "select", label = "窗口分辨率", key = "vsRes", options = { "自动", "1280x720", "1920x1080" } },
        { type = "toggle", label = "版本隔离",   key = "vsIso" },
      } },
    { id = "mods", rows = {
        { type = "toggle", label = "启用全部 Mod", key = "vsModAll" },
        { type = "button", label = "安装 Mod",     key = "vsModIn" },
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
        { id = "moreDefaultVersion", icon = "sf:cube.fill",           label = "默认版本", right = "version", action = "open:versionManager" },
        { id = "moreVersions",       icon = "sf:square.grid.3x3.fill", label = "版本管理", right = "chevron", action = "open:versionManager" },
        { id = "moreVersionSetup",   icon = "sf:wrench.and.screwdriver.fill", label = "版本设置", right = "chevron", action = "open:version_settings" },
      } },
    { name = "高级", rows = {
        { id = "moreDirectory", icon = "sf:folder.fill",             label = "游戏目录", right = "chevron", action = "open:gameDirectory" },
        { id = "moreAccount",   icon = "sf:person.crop.circle.fill", label = "账号管理", right = "chevron", action = "open:accountManager" },
    } },
    { name = "帮助", rows = {
        { id = "moreAbout", icon = "sf:info.circle.fill", label = "关于启动器", right = "chevron", action = "open:more" },
        { id = "moreLogs",  icon = "sf:doc.text.fill",    label = "日志",       right = "chevron", action = "open:more" },
      } },
  },
  versionManager = { title = "版本管理", emptyText = "尚未安装任何游戏版本，可前往下载页获取。", addAction = "open:download" },
  accountManager = { title = "账号管理", emptyText = "暂无已登录账号，登录后即可联机同步。", addAction = "open:settings" },
  gameDirectory = { title = "游戏目录", emptyText = "尚未创建其他游戏目录，可在下方输入名称新建。", addPlaceholder = "输入新目录名…" },
  detail = { title = "版本详情" },
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
  local border = BORDER
  if opts.plain then border = nil elseif opts.border then border = opts.border end
  local shadow = SHADOW
  if opts.flat then shadow = nil elseif opts.shadow then shadow = opts.shadow end
  return ui.column {
    id = id, width = opts.width or "100%", crossAlign = opts.crossAlign or "stretch",
    background = opts.background or C.card, border = border, corner = opts.corner or "1.4vh",
    shadow = shadow, padding = opts.padding or "1.8vh", spacing = opts.spacing or "0.9vh",
    hoverColor = opts.hoverColor, children = children,
  }
end

local function sectionTitle(text)
  return ui.text { text = text, width = "100%",
    style = { font = "2.7vh", weight = "bold", color = C.accent } }
end

local function chevron()
  return ui.image { icon = "sf:chevron.right", size = "2.3vh", style = { tint = C.mid } }
end

-- 列表行：左图标 + 中间标题/副标题 + 右侧值 + ›
local function listRow(spec)
  local right
  if spec.valueId or spec.value then
    right = ui.text { id = spec.valueId, text = spec.value or "", style = { font = "2.3vh", color = spec.valueColor or C.mid } }
  else
    right = chevron()
  end
  return ui.row { id = spec.id, action = spec.action, width = "100%", height = spec.height or "7vh",
    crossAlign = "center", spacing = "1.5vh", padding = "1.1vh", corner = "1vh", hoverColor = C.hover,
    children = {
      ui.image { icon = spec.icon, size = "4.2vh", corner = "1vh",
        background = spec.tintBg or C.faintBlue, style = { tint = spec.tint or C.accent } },
      ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
        ui.text { id = spec.titleId, text = spec.title, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = spec.subId, text = spec.sub or "", style = { font = "1.9vh", color = C.mid } },
      } },
      right,
    } }
end

-- 药丸按钮（主/次）
local function pillButton(id, label, primary, action)
  return ui.row { id = id, action = action or id, corner = "pill",
    padding = { left = "2.8vh", right = "2.8vh", top = "0.8vh", bottom = "0.8vh" },
    background = primary and C.accent or C.card,
    border = primary and BORDER or BORDER_A,
    hoverColor = primary and C.accentBorder or C.hover,
    children = { ui.text { text = label, style = { font = "2.4vh", weight = primary and "bold" or "normal", color = primary and C.white or C.dark } } } }
end

local function railItem(r)
  return ui.row { id = r.id, action = r.action, width = "100%", height = "6vh",
    crossAlign = "center", justify = "center", corner = "1.4vh",
    background = C.transparent, hoverColor = C.hover,
    children = { ui.image { id = r.id .. "_ico", icon = r.icon, size = "3.4vh", style = { tint = C.mid } } } }
end

-- ============ 设置行（数据驱动，id 剥离后缀匹配）============
local function settingsRow(s)
  local id = "set_" .. s.key
  local right
  if s.type == "toggle" then
    right = ui.row { id = id .. "_sw", action = id .. "_sw", height = "3.6vh", width = "7vh",
      corner = "pill", background = C.fieldBorder,
      children = {
        ui.row { height = "100%", justify = "end", crossAlign = "center",
          padding = { left = "0.6vh", right = "0.6vh", top = "0.4vh", bottom = "0.4vh" },
          children = {
            ui.row { id = id .. "_knob", height = "2.8vh", width = "2.8vh", corner = "pill", background = C.card },
          } },
      } }
  elseif s.type == "select" then
    right = ui.row { id = id .. "_v", action = id .. "_v", corner = "pill",
      padding = { left = "2.2vh", right = "2.2vh", top = "0.6vh", bottom = "0.6vh" },
      background = C.card, border = BORDER_A, hoverColor = C.hover,
      children = {
        ui.text { id = id .. "_val", text = (s.options and s.options[1]) or "···",
          style = { font = "2.3vh", color = C.accent } },
      } }
  elseif s.type == "button" then
    right = ui.row { id = id .. "_btn", action = id .. "_btn", corner = "pill",
      padding = { left = "2.6vh", right = "2.6vh", top = "0.6vh", bottom = "0.6vh" },
      background = C.card, border = BORDER_A, hoverColor = C.hover,
      children = { ui.text { text = "执行", style = { font = "2.3vh", color = C.accent } } } }
  else
    right = ui.text { text = "···", style = { font = "2.3vh", color = C.mid } }
  end
  return ui.row { id = id, width = "100%", height = "6.6vh", crossAlign = "center",
    spacing = "1.5vh", padding = "0.8vh", corner = "1vh", hoverColor = C.hover,
    children = {
      ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
      right,
    } }
end

-- ============ 首页：hero 横幅 + 悬浮启动面板 + 快捷项 ============
local function buildLaunchPanel()
  return ui.column { id = "launchPanel", width = "38%", background = C.card, corner = "1.4vh",
    shadow = SHADOW, padding = "1.7vh", spacing = "1.2vh", crossAlign = "stretch",
    children = {
      ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.4vh", children = {
        ui.image { id = "panelAvatar", icon = "sf:person.crop.circle.fill", size = "5.4vh",
          corner = "1vh", background = C.avatarBg, style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "accountName", text = "未登录", style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { id = "accountType", text = "离线账号", style = { font = "2vh", color = C.mid } },
        } },
      } },
      ui.row { id = "launchPrimary", action = "launch", width = "100%", height = "6.6vh",
        corner = "pill", background = C.accent, hoverColor = C.accentBorder,
        crossAlign = "center", justify = "center", spacing = "1vh",
        children = {
          ui.image { icon = "sf:play.fill", size = "2.8vh", style = { tint = C.white } },
          ui.text { text = "启动游戏", style = { font = "2.7vh", weight = "bold", color = C.white } },
        } },
      ui.row { width = "100%", justify = "center", children = {
        ui.text { id = "panelVersion", text = "未选择版本", style = { font = "2vh", color = C.mid } },
      } },
    } }
end

local function buildHomePage()
  local quick = {
    { id = "homeVer",  icon = "sf:cube.fill",   tint = C.accent, label = "游戏版本",   sub = "选择要启动的版本", action = "open:versionManager", value = "未选择" },
    { id = "homeMem",  icon = "sf:memorychip.fill", tint = C.green, label = "内存分配", sub = "自动按机型分配", action = "open:settings", value = "自动" },
    { id = "homeJava", icon = "sf:chevron.left.forwardslash.chevron.right", tint = C.orange, label = "Java 运行时", sub = "自动选择可用 JRE", action = "open:settings", value = "自动" },
    { id = "homeDir",  icon = "sf:folder.fill", tint = C.purple, label = "游戏目录", sub = "版本隔离与存档路径", action = "open:gameDirectory", value = "默认" },
  }
  local rows = {}
  for _, q in ipairs(quick) do
    rows[#rows + 1] = listRow {
      id = q.id, action = q.action, icon = q.icon, tint = q.tint,
      title = q.label, sub = q.sub, valueId = q.id .. "_v", value = q.value,
    }
  end

  return ui.column { id = "pageHome", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = {
      -- hero 横幅
      ui.column { id = "heroBanner", width = "100%", height = "34vh", corner = "1.6vh",
        background = { from = HERO_FROM, to = HERO_TO, angle = 45 },
        padding = { left = "3vh", right = "3vh", top = "2.6vh", bottom = "2.6vh" },
        spacing = "1vh", crossAlign = "stretch", children = {
          ui.text { text = "Pear 启动器", width = "100%",
            style = { font = "5vh", weight = "bold", color = C.white } },
          ui.text { text = "清风蓝调 · 简洁高效的 Minecraft 启动体验", width = "100%",
            style = { font = "2.5vh", color = C.white } },
          ui.row { width = "100%", weight = 1, justify = "end", crossAlign = "end", children = {
            buildLaunchPanel(),
          } },
        } },
      -- 快捷项列表
      card("homeQuick", (function()
        local kids = { sectionTitle("启动选项") }
        for _, r in ipairs(rows) do kids[#kids + 1] = r end
        return kids
      end)()),
      -- 快捷功能
      card("homeShortcut", {
        sectionTitle("常用功能"),
        ui.row { width = "100%", spacing = "1.4vh", crossAlign = "stretch", children = {
          (function()
            local chips = {
              { id = "homeGoDownload", icon = "sf:arrow.down.circle.fill", label = "下载版本", action = "open:download", tint = C.accent },
              { id = "homeGoMulti",    icon = "sf:wifi",                   label = "联机大厅", action = "open:multiplayer", tint = C.green },
              { id = "homeGoAccount",  icon = "sf:person.crop.circle.fill", label = "账号管理", action = "open:accountManager", tint = C.purple },
            }
            local out = {}
            for _, ch in ipairs(chips) do
              out[#out + 1] = ui.row { id = ch.id, action = ch.action, weight = 1, height = "11vh",
                corner = "1.2vh", background = C.hintBg, hoverColor = C.hover,
                crossAlign = "center", justify = "center", spacing = "0.8vh", children = {
                  ui.image { icon = ch.icon, size = "3.8vh", style = { tint = ch.tint } },
                  ui.text { text = ch.label, style = { font = "2.4vh", weight = "bold", color = C.dark } },
                } }
            end
            return out
          end)(),
        } },
      }),
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

local function refreshInstallPanel()
  local iv = launcher.view("insVersion")
  if iv then iv:setText((PLC.mc and PLC.mc ~= "") and PLC.mc or "未选择版本") end
  for i = 1, CONFIG.download.componentCount do
    local v = launcher.view("dlCompVer_" .. i)
    if v then v:setText(compSel[i] and "已选择" or "未选择") end
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

local function buildVersionGroupsCard()
  local grpChildren = {}
  for _, g in ipairs(CONFIG.download.versionGroups) do
    local key = g.key
    grpChildren[#grpChildren + 1] = ui.column { width = "100%", spacing = "0", children = {
      ui.row { id = "dlGh_" .. key, action = "dlGh_" .. key, width = "100%", height = "6.6vh",
        crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover,
        children = {
          ui.image { icon = "sf:list.bullet", size = "3.6vh", corner = "pill",
            background = C.hintBg, style = { tint = C.accent } },
          ui.text { text = g.name, weight = 1, style = { font = "2.6vh", color = C.dark } },
          ui.text { id = "dlGh_" .. key .. "_cnt", text = "▸", style = { font = "2.3vh", color = C.mid } },
        } },
      ui.column { id = "dlGrpList_" .. key, width = "100%", visible = false,
        spacing = "0.3vh", padding = { left = "1vh" }, children = {} },
    } }
  end
  return card("dlGroupsCard", {
    sectionTitle("选择 Minecraft 原版版本"),
    ui.text { text = "点击分组展开可用版本，点击具体版本进入安装预览。", width = "100%",
      style = { font = "2.1vh", color = C.mid } },
    ui.column { width = "100%", spacing = "0.2vh", children = grpChildren },
  }, { width = "94%" })
end

local function buildMinecraftCard()
  return card("dlMc", {
    ui.row { id = "dlMcToggle", action = "dlMcToggle", width = "100%", height = "6.6vh",
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover,
      children = {
        ui.image { icon = "sf:cube.fill", size = "4.2vh", corner = "1vh",
          background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
        ui.text { text = "Minecraft 版本", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.dark } },
        ui.text { id = "dlMcVersion", text = "未选择", style = { font = "2.4vh", color = C.accent } },
        chevron(),
      } },
    ui.column { id = "dlMcList", width = "100%", visible = false, spacing = "0.4vh", children = {} },
  }, { width = "94%" })
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
    ui.row { id = "dlCompH_" .. i, action = "dlCompH_" .. i, width = "100%", height = "6.6vh",
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, children = {
        ui.image { icon = "sf:shippingbox.fill", size = "4.2vh", corner = "1vh",
          background = { from = C.green, to = C.cyan, angle = 30 }, style = { tint = C.white } },
        ui.text { text = "组件 " .. i, weight = 1, style = { font = "2.6vh", color = C.dark } },
        ui.text { id = "dlCompVer_" .. i, text = "未选择", style = { font = "2.3vh", color = C.mid } },
        chevron(),
      } },
    ui.column { id = "dlCompList_" .. i, width = "100%", visible = false, spacing = "0.4vh", children = rows },
  }, { width = "94%" })
end

local function buildInstallPreview()
  return card("dlViewer", {
    ui.row { id = "dlBackGrp", action = "dlBackGrp", height = "5vh", crossAlign = "center",
      spacing = "1vh", corner = "1vh", hoverColor = C.hover, children = {
        ui.image { icon = "sf:chevron.left", size = "2.5vh", style = { tint = C.accent } },
        ui.text { text = "返回版本列表", style = { font = "2.4vh", color = C.accent } },
      } },
    ui.row { width = "100%", height = "10vh", crossAlign = "center", spacing = "2vh", children = {
      ui.image { icon = "sf:cube.fill", size = "6.6vh", corner = "1.4vh",
        background = { from = HERO_FROM, to = HERO_TO, angle = 45 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
        ui.text { id = "insVersion", text = "未选择版本", style = { font = "3vh", weight = "bold", color = C.dark } },
        ui.text { id = "insMcVer", text = "Minecraft", style = { font = "2.3vh", color = C.mid } },
      } },
    } },
    ui.divider { height = "0.08vh", background = C.cardBorder },
    ui.text { text = "安装名称", width = "100%", style = { font = "2.2vh", weight = "bold", color = C.dark } },
    ui.input { id = "insNameIn", width = "100%", height = "6vh", placeholder = "输入版本名称（留空为默认）",
      corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
    ui.row { width = "100%", height = "7vh", crossAlign = "center", justify = "end", spacing = "1.5vh", children = {
      ui.text { text = CONFIG.download.installHint, weight = 1, style = { font = "1.9vh", color = C.mid } },
      ui.row { id = "insStart", action = "insStart", corner = "pill",
        padding = { left = "3vh", right = "3vh", top = "1vh", bottom = "1vh" },
        background = C.accent, hoverColor = C.accentBorder, children = {
          ui.text { text = "开始安装", style = { font = "2.5vh", weight = "bold", color = C.white } },
        } },
    } },
    ui.row { id = "dlProgress", width = "100%", visible = false, crossAlign = "center", spacing = "1vh",
      padding = "1vh", children = {
        ui.text { id = "dlProgressLabel", text = "", weight = 1, style = { font = "2.2vh", color = C.dark } },
        ui.row { width = "40%", height = "1.4vh", corner = "pill", background = C.hintBg, children = {
          ui.row { id = "dlBarFill", width = "0%", height = "100%", corner = "pill", background = C.accent, children = {} },
        } },
      } },
  }, { width = "94%", spacing = "1vh" })
end

local function buildCommunityCard()
  local slots = {}
  for i = 1, CONFIG.download.communitySlots do
    slots[#slots + 1] = ui.row { id = "dlComm_" .. i, action = "dlComm_" .. i, width = "100%", height = "6.6vh",
      crossAlign = "center", spacing = "1.5vh", corner = "1vh", hoverColor = C.hover, visible = false, children = {
        ui.image { icon = "sf:doc.richtext.fill", size = "4vh", corner = "pill",
          background = C.hintBg, style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "dlComm_" .. i .. "_title", text = "· · ·", style = { font = "2.5vh", weight = "bold", color = C.dark } },
          ui.text { id = "dlComm_" .. i .. "_meta", text = "· · ·", style = { font = "2.1vh", color = C.mid } },
        } },
        ui.text { id = "dlComm_" .. i .. "_btn", text = "下载", style = { font = "2.3vh", color = C.accent } },
      } }
  end
  return card("dlCommCard", {
    ui.row { width = "100%", crossAlign = "center", spacing = "1.2vh", children = {
      ui.text { text = "社区资源搜索", weight = 1, style = { font = "2.7vh", weight = "bold", color = C.accent } },
      pillButton("dlCommKeyword", "关键词", false),
      pillButton("dlCommSearch", "搜索", true),
    } },
    ui.text { id = "dlCommStatus", text = CONFIG.download.searchStatusPreset, width = "100%",
      style = { font = "2.1vh", color = C.mid } },
    ui.column { width = "100%", spacing = "0.3vh", children = slots },
  }, { width = "94%" })
end

local function buildDownloadPage()
  local kids = {}
  kids[#kids + 1] = buildVersionGroupsCard()
  kids[#kids + 1] = buildInstallPreview()
  kids[#kids + 1] = buildMinecraftCard()
  for i = 1, CONFIG.download.componentCount do
    kids[#kids + 1] = buildComponentCard(i)
  end
  kids[#kids + 1] = buildCommunityCard()
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = kids }
end

-- ============ 联机页 ============
local function buildMultiPage()
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = {
      card("mpCard", {
        sectionTitle("联机大厅"),
        ui.text { text = "与好友在同一世界冒险：局域网直连或在线房间。", width = "100%",
          style = { font = "2.1vh", color = C.mid } },
        ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.5vh", children = {
          ui.text { text = "模式", style = { font = "2.4vh", color = C.mid } },
          ui.row { id = "segM_1", action = "segM_1", corner = "pill", height = "6vh",
            crossAlign = "center", justify = "center",
            padding = { left = "2.6vh", right = "2.6vh", top = "0.7vh", bottom = "0.7vh" },
            background = C.faintBlue, border = BORDER_A, hoverColor = C.hover,
            children = { ui.text { id = "segM_1_t", text = "局域网", style = { font = "2.3vh", weight = "bold", color = C.dark } } } },
          ui.row { id = "segM_2", action = "segM_2", corner = "pill", height = "6vh",
            crossAlign = "center", justify = "center",
            padding = { left = "2.6vh", right = "2.6vh", top = "0.7vh", bottom = "0.7vh" },
            background = C.card, border = BORDER, hoverColor = C.hover,
            children = { ui.text { id = "segM_2_t", text = "在线", style = { font = "2.3vh", color = C.dark } } } },
        } },
        ui.text { id = "mpStatus", text = CONFIG.multi.preset, width = "100%",
          style = { font = "2.2vh", color = C.dark } },
        ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.5vh", children = {
          pillButton("mpCreate", "创建房间", true),
          pillButton("mpJoin", "加入房间", false),
        } },
      }, { width = "94%" }),
    } }
end

-- ============ 设置页（分类目录 + 行内展开单卡）============
local setToggleState = {}
local setSelectIdx = {}
local setSelCat = "launcher_settings"

local function buildSettingsPage()
  local chips = {}
  for _, g in ipairs(CONFIG.settingsGroups) do
    chips[#chips + 1] = ui.row { id = "setCat_" .. g.id, action = "setCat_" .. g.id, corner = "pill",
      height = "6vh", crossAlign = "center", justify = "center",
      padding = { left = "2.4vh", right = "2.4vh", top = "0.7vh", bottom = "0.7vh" },
      background = C.card, border = BORDER, hoverColor = C.hover,
      children = { ui.text { id = "setCat_" .. g.id .. "_t", text = (g.chip or g.label),
        style = { font = "2.3vh", color = C.dark } } } }
  end
  local sections = {}
  for _, g in ipairs(CONFIG.settingsGroups) do
    local rows = {}
    for _, s in ipairs(g.rows) do rows[#rows + 1] = settingsRow(s) end
    sections[#sections + 1] = card("setSec_" .. g.id, (function()
      local kids = { sectionTitle(g.label) }
      for _, r in ipairs(rows) do kids[#kids + 1] = r end
      return kids
    end)(), { width = "94%", visible = (g.id == setSelCat) })
  end
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = {
      ui.row { id = "setCatRow", width = "94%", spacing = "1.2vh", crossAlign = "center", children = chips },
      (function()
        local out = {}
        for _, sec in ipairs(sections) do out[#out + 1] = sec end
        return ui.column { id = "setSections", width = "100%", spacing = "1.6vh", crossAlign = "center", children = out }
      end)(),
      ui.row { id = "setStatusBar", width = "94%", background = C.hintBg, corner = "1vh",
        crossAlign = "center", spacing = "1.2vh", padding = "1.5vh", children = {
          ui.image { icon = "sf:info.circle.fill", size = "2.6vh", style = { tint = C.accent } },
          ui.text { id = "setStatus", weight = 1, text = CONFIG.settingsStatus,
            style = { font = "2.2vh", color = C.dark } },
        } },
    } }
end

-- ============ 更多页 ============
local function buildMorePage()
  local kids = {}
  kids[#kids + 1] = card("moreThemeCard", {
    sectionTitle("主题包"),
    ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.6vh", children = {
      ui.image { icon = "sf:paintbrush.fill", size = "4.4vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
      ui.text { text = "主题包名称", weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = "moreThemeName_text", text = "清风蓝调", style = { font = "2.4vh", color = C.mid } },
    } },
    ui.row { width = "100%", height = "6.6vh", crossAlign = "center", spacing = "1.6vh", children = {
      ui.image { icon = "sf:tag.fill", size = "4.4vh", corner = "pill", background = C.hintBg, style = { tint = C.accent } },
      ui.text { text = "主题包版本", weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { id = "moreThemeVersion", text = "· · ·", style = { font = "2.4vh", color = C.mid } },
    } },
  }, { width = "94%" })
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, rr in ipairs(g.rows) do
      local spec = { id = rr.id, action = rr.action or "open:more", icon = rr.icon or "sf:gearshape.fill", title = rr.label }
      if rr.right == "version" then
        spec.valueId = rr.id .. "_val"
        spec.value = "未选择"
      end
      rows[#rows + 1] = listRow(spec)
    end
    local kids2 = { sectionTitle(g.name) }
    for _, r in ipairs(rows) do kids2[#kids2 + 1] = r end
    kids[#kids + 1] = card(nil, kids2, { width = "94%", spacing = "0.6vh" })
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = kids }
end

-- ============ 版本设置页 ============
local vsSelCat = "overview"
local VS_LABEL = {}
for _, cat in ipairs(CONFIG.vs_categories) do VS_LABEL[cat.token] = cat.label end

local function buildVersionSettingsPage()
  local chips = {}
  for _, cat in ipairs(CONFIG.vs_categories) do
    chips[#chips + 1] = ui.row { id = "vsCat_" .. cat.token, action = "vsCat_" .. cat.token, corner = "pill", height = "6vh",
      crossAlign = "center", justify = "center",
      padding = { left = "2.4vh", right = "2.4vh", top = "0.7vh", bottom = "0.7vh" },
      background = C.card, border = BORDER, hoverColor = C.hover,
      children = { ui.text { id = "vsCat_" .. cat.token .. "_t", text = cat.label,
        style = { font = "2.3vh", color = C.dark } } } }
  end
  local sections = {}
  for _, g in ipairs(CONFIG.vsGroups) do
    local rows = { sectionTitle(VS_LABEL[g.id] or g.id) }
    for _, s in ipairs(g.rows) do rows[#rows + 1] = settingsRow(s) end
    sections[#sections + 1] = card("vsSec_" .. g.id, rows, { width = "94%", visible = false })
  end
  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = {
      card("vsHead", {
        ui.row { width = "100%", height = "10vh", crossAlign = "center", spacing = "2vh", children = {
          ui.image { icon = "sf:wrench.and.screwdriver.fill", size = "6vh", corner = "1.4vh",
            background = { from = HERO_FROM, to = HERO_TO, angle = 45 }, style = { tint = C.white } },
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vsName", text = "未选择版本", style = { font = "2.9vh", weight = "bold", color = C.dark } },
            ui.text { id = "vsMeta", text = "版本独立设置 · 与全局设置互不影响", style = { font = "2.1vh", color = C.mid } },
          } },
          pillButton("vsOpenDir", "游戏目录", false),
        } },
      }, { width = "94%" }),
      ui.row { id = "vsCatRow", width = "94%", spacing = "1.2vh", crossAlign = "center", children = chips },
      (function()
        local out = {}
        for _, sec in ipairs(sections) do out[#out + 1] = sec end
        return ui.column { id = "vsSections", width = "100%", spacing = "1.6vh", crossAlign = "center", children = out }
      end)(),
      ui.row { id = "vsStatusBar", width = "94%", background = C.hintBg, corner = "1vh",
        crossAlign = "center", spacing = "1.2vh", padding = "1.5vh", children = {
          ui.image { icon = "sf:info.circle.fill", size = "2.6vh", style = { tint = C.accent } },
          ui.text { id = "vsStatus", weight = 1, text = "修改会写入当前版本的独立配置。",
            style = { font = "2.2vh", color = C.dark } },
        } },
    } }
end

-- ============ 版本管理页 ============
local function buildVersionManagerPage()
  local kids = {
    ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
      ui.text { text = CONFIG.versionManager.title, weight = 1, style = { font = "3vh", weight = "bold", color = C.accent } },
      pillButton("vmAdd", "添加", true, CONFIG.versionManager.addAction),
    } },
  }
  for i = 1, 5 do
    kids[#kids + 1] = ui.row { id = "vmSlot_" .. i, action = "vmSlot_" .. i, width = "100%", height = "7vh",
      crossAlign = "center", spacing = "1.5vh", padding = "1.1vh", corner = "1vh", hoverColor = C.hover,
      visible = false, children = {
        ui.image { icon = "sf:cube.fill", size = "4.2vh", corner = "1vh", background = C.hintBg, style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
          ui.text { id = "vmSlot_" .. i .. "_name", text = "· · ·", style = { font = "2.5vh", color = C.dark } },
          ui.text { id = "vmSlot_" .. i .. "_meta", text = "", style = { font = "1.9vh", color = C.mid } },
        } },
        chevron(),
      } }
  end
  kids[#kids + 1] = ui.text { id = "vmEmpty", text = CONFIG.versionManager.emptyText,
    style = { font = "2.2vh", color = C.mid } }
  return ui.column { id = "pageVersionManager", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = { card("vmCard", kids, { width = "94%" }) } }
end

-- ============ 账号管理页 ============
local function buildAccountManagerPage()
  local kids = {
    ui.row { width = "100%", height = "7vh", crossAlign = "center", children = {
      ui.text { text = CONFIG.accountManager.title, weight = 1, style = { font = "3vh", weight = "bold", color = C.accent } },
      pillButton("amAdd", "添加", true, CONFIG.accountManager.addAction),
    } },
  }
  for i = 1, 4 do
    kids[#kids + 1] = ui.row { id = "amSlot_" .. i, action = "amSlot_" .. i, width = "100%", height = "7.5vh",
      crossAlign = "center", spacing = "1.5vh", padding = "1.1vh", corner = "1vh", hoverColor = C.hover,
      visible = false, children = {
        ui.image { icon = "sf:person.crop.circle.fill", size = "4.6vh", corner = "pill",
          background = C.avatarBg, style = { tint = C.accent } },
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
    padding = "1.8vh", spacing = "1.6vh", children = { card("amCard", kids, { width = "94%" }) } }
end

-- ============ 游戏目录页 ============
local function buildGameDirectoryPage()
  local kids = {
    ui.text { text = CONFIG.gameDirectory.title, width = "100%", style = { font = "3vh", weight = "bold", color = C.accent } },
    ui.row { width = "100%", height = "6vh", crossAlign = "center", spacing = "1.2vh", children = {
      ui.input { id = "gdNameIn", weight = 1, height = "6vh", placeholder = CONFIG.gameDirectory.addPlaceholder,
        corner = "1vh", border = BORDER, background = C.card, textColor = C.dark, placeholderColor = C.mid },
      pillButton("gdCreate", "新建", true),
    } },
  }
  for i = 1, 4 do
    kids[#kids + 1] = listRow {
      id = "gd_" .. i, action = "gd_" .. i, icon = "sf:folder.fill", tint = C.orange,
      title = "· · ·", titleId = "gd_" .. i .. "_name", sub = "游戏目录", subId = "gd_" .. i .. "_sub",
      valueId = "gd_" .. i .. "_tag", value = "",
    }
  end
  kids[#kids + 1] = ui.text { id = "gdEmpty", text = CONFIG.gameDirectory.emptyText,
    style = { font = "2.2vh", color = C.mid } }
  return ui.column { id = "pageGameDirectory", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = { card("gdCard", kids, { width = "94%" }) } }
end

-- ============ 版本详情页 ============
local function buildVersionDetailPage()
  local loaderBtns = {}
  for li, lname in ipairs(CONFIG.download.loaders) do
    loaderBtns[#loaderBtns + 1] = ui.row { id = "vdL_" .. li, action = "vdL_" .. li, corner = "pill", height = "6vh",
      crossAlign = "center", justify = "center",
      padding = { left = "2.4vh", right = "2.4vh", top = "0.7vh", bottom = "0.7vh" },
      background = (li == 1) and C.faintBlue or C.card, border = BORDER_A, hoverColor = C.hover,
      children = { ui.text { id = "vdL_" .. li .. "_t", text = lname,
        style = { font = "2.3vh", color = C.dark } } } }
  end
  return ui.column { id = "pageVersionDetail", weight = 1, crossAlign = "center",
    padding = "1.8vh", spacing = "1.6vh", children = {
      card("vdCard", {
        ui.text { text = CONFIG.detail.title, width = "100%", style = { font = "3vh", weight = "bold", color = C.accent } },
        ui.row { width = "100%", height = "10vh", crossAlign = "center", spacing = "2vh", children = {
          ui.image { icon = "sf:cube.fill", size = "6.6vh", corner = "1.4vh",
            background = { from = HERO_FROM, to = HERO_TO, angle = 45 }, style = { tint = C.white } },
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vdVersion", text = "未选择版本", style = { font = "2.9vh", weight = "bold", color = C.dark } },
            ui.text { id = "vdType", text = "原版 · 未安装", style = { font = "2.2vh", color = C.mid } },
          } },
        } },
        ui.text { text = "模组加载器", width = "100%", style = { font = "2.2vh", weight = "bold", color = C.dark } },
        ui.row { id = "vdLoaderRow", width = "100%", spacing = "1.2vh", crossAlign = "center", children = loaderBtns },
        ui.divider { height = "0.08vh", background = C.cardBorder },
        ui.row { width = "100%", justify = "end", children = {
          ui.row { id = "vdInstall", action = "vdInstall", corner = "pill",
            padding = { left = "3.4vh", right = "3.4vh", top = "1vh", bottom = "1vh" },
            background = C.accent, hoverColor = C.accentBorder, children = {
              ui.text { text = "下载并安装", style = { font = "2.5vh", weight = "bold", color = C.white } },
            } },
        } },
      }, { width = "94%", spacing = "1.4vh" }),
    } }
end

-- ============ 壳 + 构建 ============
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

  local railKids = {
    ui.text { id = "railBrand", text = "Pear", width = "100%",
      style = { font = "1.7vh", weight = "bold", color = C.mid } },
  }
  for _, r in ipairs(RAIL) do railKids[#railKids + 1] = railItem(r) end
  railKids[#railKids + 1] = ui.spacer { weight = 1 }

  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0,
    children = {
      -- 顶栏（浅色通栏：品牌 + 窗口按钮）
      ui.row { id = "titlebar", height = "7vh", background = C.topbar, crossAlign = "center",
        spacing = "1.2vh", padding = { left = "2.2vh", right = "1.8vh" }, children = {
          ui.image { id = "logoIcon", icon = "sf:cube.transparent.fill", size = "3vh", style = { tint = C.accent } },
          ui.text { id = "logo", text = "Pear", style = { font = "3vh", weight = "bold", color = C.accent } },
          ui.text { id = "logoSub", text = "启动器", style = { font = "2vh", color = C.mid } },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.4vh", style = { tint = C.mid } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.4vh", style = { tint = C.mid } },
        } },
      -- 主体：窄图标导航栏 + 内容区
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0, children = {
        ui.column { id = "rail", width = "8vh", background = C.card, crossAlign = "center",
          spacing = "0.8vh", padding = { left = "0.6vh", right = "0.6vh", top = "1.2vh", bottom = "1.2vh" },
          children = railKids },
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
local mpBranch = 1

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
end

local function refreshVersion()
  local ver = launcher.state and launcher.state.version
  local name = (type(ver) == "table" and ver.name) or ""
  local label = (name ~= "" and name) or "未选择"
  if launcher.view("panelVersion") then launcher.view("panelVersion"):setText(label) end
  if launcher.view("homeVer_v") then launcher.view("homeVer_v"):setText(label) end
  if launcher.view("vdVersion") then launcher.view("vdVersion"):setText(label) end
  if launcher.view("vsName") then launcher.view("vsName"):setText(label) end
end

local function refreshBrand()
  local st = launcher.getState and launcher.getState() or nil
  local sui = (type(st) == "table" and type(st.ui) == "table") and st.ui or nil
  local brand = (sui and sui.name and sui.name ~= "") and sui.name or "Pear"
  if launcher.view("railBrand") then launcher.view("railBrand"):setText(brand) end
end

local function refreshSettingsCats()
  for _, g in ipairs(CONFIG.settingsGroups) do
    local chip = launcher.view("setCat_" .. g.id)
    if chip then
      chip:setStyle((g.id == setSelCat)
        and { background = C.faintBlue, borderColor = C.accentBorder }
        or  { background = C.card, borderColor = C.cardBorder })
    end
    local sec = launcher.view("setSec_" .. g.id)
    if sec then sec:setVisible(g.id == setSelCat) end
  end
end

local function refreshVersionSettings()
  for _, cat in ipairs(CONFIG.vs_categories) do
    local chip = launcher.view("vsCat_" .. cat.token)
    if chip then
      chip:setStyle((cat.token == vsSelCat)
        and { background = C.faintBlue, borderColor = C.accentBorder }
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

function onReady()
  refreshAccount()
  refreshVersion()
  refreshBrand()
  onPageChange(currentPage)
end

function onLayout() end

function onAccountChange(account)
  if type(account) ~= "table" then return end
  if launcher.view("accountName") then launcher.view("accountName"):setText(account.name or "未登录") end
  if launcher.view("accountType") then
    launcher.view("accountType"):setText((account.type or account.kind or "离线") .. " 账号")
  end
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

function onPageChange(page)
  currentPage = page
  if launcher.view("titlebar") then launcher.view("titlebar"):setVisible(true) end
  if launcher.view("rail") then launcher.view("rail"):setVisible(true) end

  local railId = PAGE_RAIL[page]
  for _, r in ipairs(RAIL) do
    local sel = (r.id == railId)
    local rv = launcher.view(r.id)
    if rv then rv:setStyle({ background = sel and C.faintBlue or C.transparent }) end
    local iv = launcher.view(r.id .. "_ico")
    if iv then iv:setStyle({ tint = sel and C.accent or C.mid }) end
  end

  if page == "download" then
    dlLevel = "groups"
    refreshDownloadVersions()
    refreshDownloadState()
  elseif page == "settings" then
    refreshSettingsCats()
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
end

-- 设置项行为（供带后缀的控件与整行点击共用）
local function applyToggle(key)
  local on = not (setToggleState[key] == true)
  setToggleState[key] = on
  local sw = launcher.view("set_" .. key .. "_sw")
  if sw then sw:setStyle({ background = on and C.accent or C.fieldBorder }) end
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

function onClick(id)
  id = tostring(id or ""):gsub(":", "_")

  -- 导航栏（顶栏/图标栏 id 兜底）
  for _, r in ipairs(RAIL) do
    if r.id == id then
      if launcher.action then launcher.action(r.action) end
      return
    end
  end

  -- 设置分类切换
  local scat = id:match("^setCat_(.+)$")
  if scat then
    setSelCat = scat
    refreshSettingsCats()
    return
  end

  -- 版本设置分类切换
  local vcat = id:match("^vsCat_(.+)$")
  if vcat then
    vsSelCat = vcat
    refreshVersionSettings()
    return
  end

  -- 下载：安装预览
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
  local cpv = id:match("^dlCompV_(%d+)_(%d+)$")
  if cpv then
    local i = tonumber(cpv[1])
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
    for i = 1, 2 do
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

  -- 版本管理 / 账号 / 目录 槽位
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

  -- 版本详情：加载器切换 / 安装
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
