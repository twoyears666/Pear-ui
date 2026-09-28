-- Pear 启动器 · 仿 PCL 浅色 UI 包 —— v1.13.3
--
-- 契约（引擎通用，零特例）：
--   主题：仿 PCL 浅色——蓝顶栏 topbar #0A5FC4、内容区浅蓝灰对角渐变
--         background_start #E3EEF9 → background_end #D5E5F5、白卡 background_card #FFFFFF、
--         深色文字 cardText #333333。禁止任何黑色/深色/透明兜底（背景必须在 colors.json）。
--   尺寸：全部按窗口高 1H 比例（vh = 0.01H）；横向用 %。
--   布局：只通过容器组件表达，禁止绝对定位、禁止规格外元素、禁止大字号漂浮文字。
--         容器语义（引擎原生原语）：split_column ≈ row（横向分栏）、vertical_flow ≈
--         column（通栏纵向流，内容 94% 即左右留边 3%）、card ≈ 白底圆角卡片 column、
--         row_item ≈ 整行条目 row。所有子元素只在父容器内流式排布。
--   页面：内容区 content 内挂纯 Lua 页子树，页 token ∈ CONFIG.pages。
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：
--   pageHome / pageDownload / pageMulti / pageSettings / pageMore / pageVersionSettings

function describe()
  return { name = "PCL 浅色", version = "1.24.0-beta" }
end

local C = {
  topbar      = "$color:topbar",              -- 顶栏蓝 #0A5FC4
  topbarFrom  = "$color:topbarFrom",          -- 顶栏渐变起点（较亮的蓝）
  topbarTo    = "$color:topbarTo",            -- 顶栏渐变终点 = 主题蓝 #0A5FC4
  pageFrom    = "$color:pageFrom",            -- 渐变左上 #E3EEF9
  pageTo      = "$color:pageTo",              -- 渐变右下 #D5E5F5
  bg          = "$color:background_start",    -- 页面底色起点 #E3EEF9（渐变同 background_gradient）
  card        = "$color:card",                -- 卡片 #FFFFFF = background_card
  cardBorder  = "$color:cardBorder",          -- 卡片描边 #D9E4F0
  dark        = "$color:cardText",            -- 主文字 #333333
  mid         = "$color:subText",             -- 次要文字 #999999
  white       = "$color:white",
  transparent = "$color:transparent",
  accent      = "$color:accent",              -- 强调蓝 #0B84FF
  accentBorder = "$color:accentBorder",
  hover       = "$color:hover",               -- hover 浅蓝 #EAF3FC
  avatarBg    = "$color:avatarBg",
  avatarLine  = "$color:avatarLine",
  success     = "$color:success",
  danger      = "$color:danger",
  orange      = "$color:brandOrange",
  green       = "$color:brandGreen",
  purple      = "$color:brandPurple",
  cyan        = "$color:brandCyan",
  pink        = "$color:brandPink",
  hintBg      = "$color:faintBlue",           -- 提示条浅蓝底 #EAF3FC
  faintBlue   = "$color:faintBlue",           -- 浅蓝底（胶囊按钮/图标底）
  fieldBorder = "$color:fieldBorder",
}

local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local BORDER_D = { width = "0.18vh", color = C.danger }
local SHADOW   = { blur = "0.3vh", opacity = 0.07, x = 0, y = "0.15vh" }

-- 当前设置分类选中项（文件顶部声明，避免 buildSettingsPage 前置引用读到 nil 全局）
local setSelCat = "launcher_settings"

local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",                             action = "open:home",       page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",                 action = "open:download",   page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:antenna.radiowaves.left.and.right",      action = "open:multi",       page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:gearshape.fill",                         action = "open:settings",   page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",                   action = "open:more",       page = "more" },
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
    gameDirectory = "pageGameDirectory",
  },
  home = {
    secondaryLinks = { { label = "购买正版", action = "open:download" }, { label = "更换皮肤", action = "open:settings" } },
  },
  download = {
    -- 下载页左侧分类目录（仿 PCL PageDownloadLeft）
    sidebarGroups = {
      { name = "原版游戏", items = {
        { id = "dlCat_1", label = "原版游戏" },
      } },
      { name = "社区资源", items = {
        { id = "dlCat_2", label = "Mod" },
        { id = "dlCat_3", label = "整合包" },
        { id = "dlCat_4", label = "数据包" },
        { id = "dlCat_5", label = "资源包" },
        { id = "dlCat_6", label = "光影包" },
      } },
    },
    titleByCat = { "原版游戏", "Mod", "整合包", "数据包", "资源包", "光影包" },
    -- 社区搜索源回退（真实来源优先取 community.sources；引擎未就绪时用此兜底）
    searchSources = { { id = "modrinth", name = "Modrinth" } },
    searchObjects = { "mod", "modpack", "datapack", "resourcepack", "shader" },
    communityResultSlots = 6, -- 社区资源搜索结果槽位数（下载页一次展示的最大结果数）
    keywordPlaceholder = "点击输入关键词…",
    searchStatusPreset = "点击「搜索」获取社区资源，点击结果条目可下载最新版本",
    installHint = "安装后请留意版本与 Mod 兼容性；Fabric/Forge 需安装对应加载器。",
    defaultVersion = "1.20.1", -- 安装面板默认选中的版本 id
    -- 下载页首屏「版本分组」列表（仿 PCL 下载→原版游戏）：点分组展开内联具体版本，
    -- 点具体版本进入安装面板。latest = download.versions 的 latestRelease + latestSnapshot。
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "测试版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
    maxVersionRows = 12,     -- 每张版本卡最多渲染的版本行（真实列表很长，滚动超出部分截断）
    mcLabel = "Minecraft",
  },
  online = {
    branch = { "局域网", "在线" },
    rooms = {}, -- 房间列表由 MultiplayerManager 在运行时填充
  },
  moreGroups = {
    { name = "启动", rows = {
        { id = "moreLaunch",         icon = "sf:play.rectangle.fill",  label = "启动选项",   right = "chevron", action = "open:settings" },
    } },
    { name = "资源", rows = {
        { id = "moreDefaultVersion", icon = "sf:cube.fill",            label = "默认版本",   right = "version", action = "open:versionManager" },
        { id = "moreMods",           icon = "sf:hud",                  label = "资源中心",   right = "chevron", action = "open:mods" },
        { id = "moreVersions",       icon = "sf:square.grid.3x3.fill", label = "版本管理",   right = "chevron", action = "open:versionManager" },
    } },
    { name = "其他", rows = {
        { id = "moreAbout",          icon = "sf:info.circle.fill",     label = "关于加载器", right = "chevron", action = "open:settings" },
    } },
    { name = "帮助", rows = {
        { id = "moreFeedback",       icon = "sf:exclamationmark.bubble.fill", label = "问题反馈", right = "chevron", action = "open:more" },
        { id = "moreLogs",           icon = "sf:doc.text.fill",         label = "日志",       right = "chevron", action = "open:more" },
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
  -- 设置页数据源（数据驱动）：左侧目录 + 右侧单一大白卡分组条目。
  -- 每项 type：toggle=开关 / select=取值行 / button=描边蓝字按钮 / text=仅展示。
  -- settingsGroups 恒非常规非空渲染，侧栏与内容都不依赖引擎运行时（M1/M4 根治）。
  settingsGroups = {
    { id = "launcher_settings", label = "启动器设置", icon = "sf:slider.horizontal.3", rows = {
      { id = "st_theme",  label = "浅色主题",     type = "toggle", value = true  },
      { id = "st_lang",   label = "界面语言",     type = "select", value = "简体中文", options = { "简体中文", "English", "日本語" } },
      { id = "st_update", label = "自动检查更新", type = "toggle", value = true  },
      { id = "st_mirror", label = "下载镜像",     type = "select", value = "自动检测", options = { "自动检测", "Mojang 源", "BMCLAPI" } },
    } },
    { id = "download_mirror", label = "下载镜像", icon = "sf:arrow.down.circle.fill", rows = {
      { id = "sd_source", label = "下载源",       type = "select", value = "官源", options = { "官源", "镜像", "Modrinth", "CurseForge" } },
      { id = "sd_latency",label = "自动检测延迟", type = "toggle", value = false },
      { id = "sd_multi",  label = "多线程下载",   type = "toggle", value = true  },
    } },
    { id = "video_settings", label = "视频设置", icon = "sf:display", rows = {
      { id = "sv_res",   label = "最大分辨率",   type = "select", value = "自动", options = { "自动", "480p", "720p", "1080p", "2K" } },
      { id = "sv_vsync", label = "垂直同步",     type = "toggle", value = false },
      { id = "sv_ratio", label = "渲染占比",     type = "select", value = "100%", options = { "25%", "50%", "75%", "100%" } },
    } },
    { id = "gl_renderer", label = "GL 渲染器", icon = "sf:memorychip.fill", rows = {
      { id = "sg_layer", label = "OpenGL 兼容层", type = "select", value = "自动", options = { "自动", "OpenGL 2.1", "OpenGL 3.2", "Vulkan" } },
      { id = "sg_debug", label = "开启调试日志",  type = "toggle", value = false },
      { id = "sg_reset", label = "重置渲染器设置", type = "button" },
    } },
    { id = "control_keys", label = "控制键", icon = "sf:keyboard.fill", rows = {
      { id = "sk_layout", label = "按键布局",   type = "select", value = "默认", options = { "默认", "简洁", "紧凑" } },
      { id = "sk_joystick",label = "摇杆模式", type = "select", value = "跟随", options = { "跟随", "翻转", "关闭" } },
      { id = "sk_custom", label = "自定义按键", type = "button" },
    } },
    { id = "java_tuning", label = "Java 调整", icon = "sf:wrench.and.screwdriver.fill", rows = {
      { id = "sj_ram",   label = "内存分配",  type = "select", value = "2048 MB", options = { "1024 MB", "2048 MB", "4096 MB", "6144 MB" } },
      { id = "sj_jvm",   label = "JVM 参数",  type = "text",   value = "-Xmx2G" },
      { id = "sj_reset", label = "重置 JVM 参数", type = "button" },
    } },
    { id = "ui_theme", label = "UI 设置", icon = "sf:paintbrush.fill", rows = {
      { id = "su_scale",  label = "界面缩放",   type = "select", value = "自动", options = { "自动", "0.75x", "1x", "1.25x", "1.5x" } },
      { id = "su_pack",   label = "主题材质包", type = "select", value = "PCL 浅色", options = { "PCL 浅色", "默认浅色" } },
    } },
    { id = "ai_assistant", label = "AI 助手", icon = "sf:sparkles", rows = {
      { id = "sa_provider", label = "服务商",   type = "select", value = "未配置", options = { "未配置", "OpenAI", "Anthropic", "本地" } },
      { id = "sa_model",    label = "对话模型", type = "select", value = "默认", options = { "默认", "快速", "专注" } },
    } },
  },
  settingsStatus = "设置项已按分组展示；点击开关或按钮可即时反馈（数据驱动配色，方便日后切换主题）。",
  -- token → 分组中文名（小字标题用）
  settingsGroupNames = {
    launcher_settings = "常规", download_mirror = "网络", video_settings = "显示",
    gl_renderer = "兼容", control_keys = "控制", java_tuning = "性能",
    ui_theme = "外观", ai_assistant = "助手",
  },
}

-- ===== 通用构件 =====
local function pushAll(dst, src) for _, v in ipairs(src) do dst[#dst + 1] = v end end

-- 节点 id 后缀归一化：引擎派发的 onClick 是「节点 id」（不是 action 名）。行内子节点
-- id = 行 id + 后缀，点击子节点时用 baseId 剥掉后缀还原到行 id 再分发（长后缀优先）。
local ID_SUFFIXES = {
  "_status", "_title", "_date", "_name", "_meta", "_ico", "_btn", "_sw", "_v",
  "Title", "Sub", "Name", "Meta", "Val", "Txt", "Icon", "Text",
}
local function baseId(id)
  if type(id) ~= "string" then return id end
  local dot = id:match("^dlCatDot_(%d+)$")
  if dot then return "dlCat_" .. dot end
  for _, sfx in ipairs(ID_SUFFIXES) do
    if #id > #sfx and id:sub(-#sfx) == sfx then return id:sub(1, #id - #sfx) end
  end
  return id
end

local function settingsGroupByToken(token)
  for _, g in ipairs(CONFIG.settingsGroups) do
    if g.id == token then return g end
  end
  return nil
end

-- 设置页分类：真源为引擎 settings.list（action = "open_subpage:<token>"）；未就绪时回退 CONFIG.settingsGroups。
-- 每分类在右侧渲染 setSec_<token> 行内区（不依赖 open_subpage 导航）。
local SET_CATS = {}
local function computeSettingsCats()
  local out = {}
  local resp = launcher.service and launcher.service("settings", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for _, it in ipairs(items) do
    local token = (type(it) == "table" and type(it.action) == "string")
      and it.action:match("open_subpage:(.+)$") or nil
    if token and token ~= "" then
      out[#out + 1] = { token = token, label = it.label or token, icon = it.icon, desc = it.desc }
    end
  end
  if #out == 0 then
    for _, g in ipairs(CONFIG.settingsGroups) do
      out[#out + 1] = { token = g.id, label = g.label, icon = g.icon, desc = nil }
    end
  end
  return out
end
local SET_ROW_BY_ID = {}
local function settingsRowById(id)
  if SET_ROW_BY_ID[id] ~= nil then return SET_ROW_BY_ID[id] end
  for _, g in ipairs(CONFIG.settingsGroups) do
    for _, s in ipairs(g.rows or {}) do
      if s.id == id then SET_ROW_BY_ID[id] = s; return s end
    end
  end
  SET_ROW_BY_ID[id] = false
  return nil
end

-- 版本设置页可写回项：引擎 versionSettings.set 仅接受白名单 key，值为字符串。
-- 点击行内取值循环切换候选并写回（真实 source of truth 仍是 profiles）。
local VS_SETTING_OPTIONS = {
  versionIsolation = { "false", "true" },
  ramType          = { "自动", "全局", "自定义" },
  ramOptimize      = { "true", "false" },
  loginMode        = { "正版登录", "离线登录", "第三方登录" },
}

-- 版本 / 账号 / 游戏目录管理页的固定槽位数（引擎列表超出部分截断，占位槽位隐藏）
local MANAGER_SLOTS = 8

-- 进度条：引擎 setStyle 不支持 width；track = 底槽 row，fill = 绝对定位填充 column。
-- 更新用 getFrame() 取底槽宽 × pct/100 后 setFrame 覆盖。
local function makeBar(trackId, fillId)
  return ui.row { id = trackId, width = "100%", height = "1.6vh", background = C.faintBlue,
    corner = "pill",
    children = {
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

local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.mid } }
end

-- 顶栏页签（选中态由 setStyle 套白底全圆药丸，不做绝对定位游标）
local function topTab(t)
  return ui.button {
    id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill",
    padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" },
  }
end

-- 白底圆角卡片（通用卡片规范，apply to all 界面）：
--   外边距：水平居中、两侧各留白 15% —— 卡宽 70%；垂直：首卡距顶 4%、卡距 2%。
--   内边距：内容距卡缘水平 3%(用 vh 近似)、垂直 1.5%。
--   圆角：= 屏高 1%（1vh）。
-- opts 可覆盖 width/padding/spacing/crossAlign/visible/height。
local function card(id, children, opts)
  opts = opts or {}
  return ui.column { id = id, width = opts.width or "70%", background = C.card, border = BORDER,
    corner = opts.corner or "1vh", shadow = SHADOW,
    padding = opts.padding or { left = "2.4vh", right = "2.4vh", top = "1.5vh", bottom = "1.5vh" },
    spacing = opts.spacing or "2vh", crossAlign = opts.crossAlign,
    height = opts.height, visible = opts.visible, children = children }
end

-- 整行条目卡（row_item）：左图标 + 中列(标题/副题) + 右文本；整行可点、hover 浅蓝，图标圆角
local function listEntry(id, icon, tint, title, sub, rightText, action)
  return ui.row {
    id = id, height = "8vh", background = C.card, corner = "1.2vh",
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.6vh", action = action,
    children = {
      ui.image { icon = icon, size = "5vh", corner = "pill",
        background = { from = C.accent, to = tint, angle = 30 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
        ui.text { id = id .. "Title", text = title, style = { font = "2.8vh", weight = "bold", color = C.dark } },
        ui.text { id = id .. "Sub", text = sub, style = { font = "2.1vh", color = C.mid } },
      } },
      rightText and ui.text { text = rightText, style = { font = "2vh", color = C.mid } } or nil,
    },
  }
end

local function bigItem(id, icon, tint, title, meta, rightText, action)
  return ui.row {
    id = id, height = "14vh", background = C.card, corner = "1.2vh",
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.8vh", action = action,
    children = {
      ui.image { icon = icon, size = "10vh", corner = "pill",
        background = { from = tint, to = C.accent, angle = 30 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
        ui.text { text = title, style = { font = "2.5vh", weight = "bold", color = C.dark } },
        ui.text { text = meta, style = { font = "2.1vh", color = C.mid } },
        rightText and ui.text { text = rightText, style = { font = "2vh", color = C.mid } } or nil,
      } },
    },
  }
end

-- 分段选择：等分横排的 n 个按钮，选中项白底全圆药丸
local function segmentRow(id, labels, spacing)
  local kids = {}
  for i, lab in ipairs(labels) do
    kids[#kids + 1] = ui.button { id = id .. "_" .. i, label = lab, weight = 1,
      height = "4.5vh", corner = "pill", action = id .. "_" .. i, hoverColor = C.hover,
      style = { background = C.transparent, tint = C.dark, font = "2.3vh", weight = "bold" } }
  end
  return ui.row { width = "94%", height = "5.5vh", crossAlign = "center", spacing = spacing, children = kids }
end

local function pickerRow(id, label, valueText, valueId)
  return ui.row {
    id = id, height = "4.5vh", width = "100%", crossAlign = "center",
    children = {
      ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
      ui.spacer { weight = 1 },
      ui.row { weight = 3, width = "70%", height = "4.5vh", background = C.card,
        border = { width = "0.12vh", color = C.fieldBorder }, corner = "0.8vh", crossAlign = "center",
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { id = valueId, text = valueText, weight = 1, style = { font = "2.2vh", color = C.dark } },
          ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
        } },
    },
  }
end

local function plainButton(id, label, accent, action)
  return ui.button { id = id, label = label, height = "5.5vh", weight = 1, background = C.card,
    corner = "0.7vh", border = (accent and BORDER_A or BORDER), action = action,
    style = { font = "2.4vh", tint = C.dark } }
end

-- 设置页分组行：标签 + 当前值 + ›
local function settingsRow(id, label, value, action)
  return ui.row {
    id = id, height = "6.5vh", width = "100%", crossAlign = "center",
    spacing = "1.5vh", hoverColor = C.hover, action = action,
    children = {
      ui.text { text = label, weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { text = value or "···", style = { font = "2.3vh", color = C.mid } },
      chevron(),
    } }
end

-- 开关状态表（id → bool），默认取 CONFIG 定义（M5：点击真正切换）。
local setToggles = {}
local function toggleOn(id)
  if setToggles[id] ~= nil then return setToggles[id] end
  for _, g in ipairs(CONFIG.settingsGroups) do
    for _, s in ipairs(g.rows or {}) do
      if s.id == id then setToggles[id] = (s.value == true); return setToggles[id] end
    end
  end
  return false
end

-- 设置项交互：按 CONFIG.settingsGroups 中的 type 切换开关 / 循环选项 / 触发按钮，落点 setStatus。
local function applySettingToggle(base)
  local def = settingsRowById(base)
  if not def then return end
  local statusView = launcher.view("setStatus")
  local label = "「" .. (def.label or base) .. "」"
  if def.type == "toggle" then
    local on = not toggleOn(base)
    setToggles[base] = on
    local sw = launcher.view("setit_" .. base .. "_sw")
    if sw then
      sw:setText(on and "开" or "关")
      sw:setStyle(on and { background = C.accent, tint = C.white }
        or { background = C.cardBorder, tint = C.white })
    end
    if statusView then statusView:setText(label .. "已" .. (on and "开启" or "关闭")) end
  elseif def.type == "select" then
    local opts = def.options or {}
    if #opts > 0 then
      local cur = 0
      for i, o in ipairs(opts) do
        if tostring(o) == tostring(def.value) then cur = i break end
      end
      local nxt = opts[(cur % #opts) + 1]
      def.value = nxt
      local vv = launcher.view("setit_" .. base .. "_v")
      if vv then vv:setText(tostring(nxt)) end
      if statusView then statusView:setText(label .. "已切换为：" .. tostring(nxt)) end
    end
  elseif def.type == "button" then
    if statusView then statusView:setText("已执行：" .. label) end
  else
    local vv = launcher.view("setit_" .. base .. "_v")
    if vv then vv:setText(tostring(def.value or "")) end
    if statusView then statusView:setText(label .. "：" .. tostring(def.value or "")) end
  end
end

-- 版本设置可写回项：循环候选值并调用 versionSettings.set（白名单 key，值为字符串）。
local function cycleVersionSetting(key)
  if type(key) ~= "string" or key == "" then return end
  local opts = VS_SETTING_OPTIONS[key]
  if type(opts) ~= "table" or #opts == 0 then return end
  local vv = launcher.view("vsSet_" .. key .. "Val")
  local curVal = vv and vv:getText() or ""
  local cur = 0
  for i, o in ipairs(opts) do
    if tostring(o) == tostring(curVal) then cur = i break end
  end
  local nxt = opts[(cur % #opts) + 1]
  launcher.service("versionSettings", "set", { key = key, value = tostring(nxt) })
  if vv then vv:setText(tostring(nxt)) end
end

-- 设置项（数据驱动，type 字段决定控件形态；所有颜色走 C 变量）
local function settingsItemRow(s)
  local id = "setit_" .. s.id
  if s.type == "toggle" then
    local on = toggleOn(s.id)
    return ui.row {
      id = id, action = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.button { id = id .. "_sw", label = (on and "开" or "关"), width = "13vh", height = "4.4vh",
          corner = "pill", action = id, hoverColor = C.hover,
          style = { background = on and C.accent or C.cardBorder, tint = C.white,
                    font = "2.2vh", weight = "bold" } },
      } }
  elseif s.type == "button" then
    return ui.button { id = id, label = s.label, height = "5.6vh", width = "100%",
      background = C.card, border = BORDER_A, corner = "0.7vh", action = id, hoverColor = C.hover,
      style = { font = "2.4vh", tint = C.accent, weight = "bold" } }
  elseif s.type == "text" then
    return ui.row { id = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = id .. "_v", text = s.value or "", style = { font = "2.3vh", color = C.mid } },
      } }
  else -- select
    return ui.row { id = id, action = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = id .. "_v", text = s.value or "", style = { font = "2.3vh", color = C.mid } },
        ui.text { text = " ▾", style = { font = "2.3vh", color = C.mid } },
      } }
  end
end

-- ============ 启动页左栏（split_column 左 1/3，仿 PCL2 主页左侧）============
local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.spacer { height = "2.5vh" }
  -- 账号类型胶囊：Mojang / 微软 / 离线（PCL2 为三态 pill）
  kids[#kids + 1] = ui.row { id = "capsules", width = "90%", height = "4vh", spacing = "1vh",
    children = {
      ui.button { id = "cap.mojang", label = "Mojang", height = "4vh", weight = 1, corner = "pill",
        action = "cap.mojang", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
      ui.button { id = "cap.microsoft", label = "微软", height = "4vh", weight = 1, corner = "pill",
        action = "cap.microsoft", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
      ui.button { id = "cap.offline", label = "离线", height = "4vh", weight = 1, corner = "pill",
        action = "cap.offline", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
    } }
  -- 头像在中（PCL2 皮肤预览较大，用像素风格占位）
  kids[#kids + 1] = ui.spacer { height = "2.5vh" }
  kids[#kids + 1] = ui.column { id = "avatarBox", width = "15vh", height = "15vh", corner = "1.2vh",
    background = C.avatarBg, border = BORDER, justify = "center", crossAlign = "center",
    children = {
      ui.image { id = "avatar", icon = "sf:person.crop.square.fill", size = "10vh",
        background = C.transparent, style = { tint = C.avatarLine } },
    } }
  kids[#kids + 1] = ui.spacer { height = "1.5vh" }
  kids[#kids + 1] = ui.text { id = "accountName", text = "未登录", width = "90%",
    style = { font = "2.4vh", weight = "bold", color = C.dark } }
  kids[#kids + 1] = ui.text { id = "accountType", text = "点击登录账号", width = "90%",
    style = { font = "2vh", color = C.mid } }
  kids[#kids + 1] = ui.spacer { height = "1.8vh" }
  -- 登录 / 管理账号
  kids[#kids + 1] = ui.button { id = "loginBtn", label = "登录 / 管理账号", width = "90%", height = "5vh",
    background = C.accent, corner = "0.8vh", action = "open:accountManager",
    style = { font = "2.3vh", weight = "bold", tint = C.white } }
  kids[#kids + 1] = ui.row { id = "homeLinks", width = "90%", height = "4vh", crossAlign = "center", spacing = "1vh",
    children = {
      ui.button { id = "linkBuy", label = "购买正版", weight = 1, height = "4vh", corner = "pill",
        action = "open:download", hoverColor = C.hover,
        style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
      ui.button { id = "linkSkin", label = "更换皮肤", weight = 1, height = "4vh", corner = "pill",
        action = "open:settings", hoverColor = C.hover,
        style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  -- 启动游戏大按钮：白底 + 蓝色边框（PCL2 风格）
  kids[#kids + 1] = ui.column { id = "launchBtn", action = "launch", width = "90%", height = "10vh",
    corner = "1.2vh", background = C.card, border = BORDER_A, justify = "center", crossAlign = "center",
    spacing = "0.6vh", hoverColor = C.hover,
    children = {
      ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3.2vh", weight = "bold", color = C.accent } },
      ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
    } }
  kids[#kids + 1] = ui.spacer { weight = 1 }
  -- 版本选择 / 版本设置（PCL2 底部并排按钮）
  kids[#kids + 1] = ui.row { id = "versionRow", width = "90%", height = "5.5vh", spacing = "1.2vh",
    children = {
      ui.button { id = "pickVersion", label = "版本选择", action = "open:versionManager", weight = 1,
        height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
      ui.button { id = "versionSetup", label = "版本设置", action = "open:version_settings", weight = 1,
        height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  return kids
end

-- ============ 启动页右区（仿 PCL2 主页右侧大公告卡片）============
local function buildHomePage()
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center", padding = "1.6vh",
    spacing = "1.6vh",
    children = {
      card("homeNotice", {
        ui.row { width = "100%", height = "5vh", crossAlign = "center", spacing = "1.5vh",
          children = {
            ui.image { icon = "sf:info.circle.fill", size = "4vh", corner = "pill",
              background = C.faintBlue, style = { tint = C.accent } },
            ui.text { text = "公告", style = { font = "2.8vh", weight = "bold", color = C.dark } },
          } },
        ui.divider { height = "0.2vh", background = C.cardBorder },
        ui.text { text = "欢迎使用 Pear 启动器。", style = { font = "2.4vh", color = C.dark } },
        ui.text { text = "· 在左侧选择账号类型并登录。", width = "100%", style = { font = "2.2vh", color = C.mid } },
        ui.text { text = "· 点击「版本选择」安装或切换游戏版本。", width = "100%", style = { font = "2.2vh", color = C.mid } },
        ui.text { text = "· 点击「启动游戏」即可开始游玩。", width = "100%", style = { font = "2.2vh", color = C.mid } },
        ui.button { id = "homeNoticeBtn", label = "了解更多", width = "28vh", height = "5vh",
          background = C.accent, corner = "0.8vh", action = "open:more",
          style = { font = "2.3vh", weight = "bold", tint = C.white } },
      }, { spacing = "2vh" }),
    } }
end

-- ============ 下载页状态 ============
local dlGroups = {}        -- download.versions 分组缓存：groupKey → { versionItem... }
local dlOpenGroup = {}     -- 首屏分组展开状态：groupKey → bool
local dlGroupAppended = {} -- 已把该组版本行 append 进容器的分组（只追加一次）
local dlSelCat = 1         -- 下载页左侧分类选中项（1=原版游戏，2..6=社区资源五类）

-- 行内安装面板状态
local PLC = {}             -- 安装面板当前选中项
PLC.mc = CONFIG.download.defaultVersion or ""
PLC.mcOpen = false         -- Minecraft 版本选择列表展开

-- 由 download.versions 平铺填充 Minecraft 行内版本列表
local flatVersions = {}

-- 下载页层级：groups(分组列表，首屏) / install(行内安装面板，点具体版本后进入)
dlLevel = "groups"

-- 前向声明：这两个刷新函数定义在本块之后，供 refreshDownloadVersions 调用。
local refreshDownloadGroups, refreshInstallPanel

-- download.versions 的 groups 容错取值：引擎返回数组 [{key,items}]，部分环境可能返回 map。
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

-- 拉取远程版本清单，填充分组缓存与平铺列表（供分组展开与行内 Minecraft 列表使用）。
local function refreshDownloadVersions()
  local p = launcher.service("download", "versions")
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

-- 行内安装面板刷新：Minecraft 行内列表可见性与高亮 + 预览/Minecraft 卡文本
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
  launcher.view("insVersion"):setText(label)
  launcher.view("dlMcVersion"):setText(label)
end

-- 下载页版本分组内单个版本行（由 append 动态挂入列表容器；row 带 action 使整行可点）
local function dlGrpVersionRow(gkey, j, it)
  local vid = (type(it) == "table" and it.id) or ""
  local sub = (type(it) == "table" and (it.date or it.name)) or ""
  return ui.row { id = "dlGrpVer_" .. gkey .. "_" .. j, width = "100%", height = "6.5vh",
    background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
    hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
    padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGrpVer:" .. gkey .. ":" .. j,
    children = {
      ui.image { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_ico", icon = "sf:cube.fill",
        size = "2.6vh", style = { tint = C.accent } },
      ui.column { weight = 1, crossAlign = "stretch", spacing = "0.5vh", children = {
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_name", text = vid,
          width = "100%", style = { font = "2.3vh", color = C.dark } },
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_date", text = sub, width = "100%",
          style = { font = "1.9vh", color = C.mid } },
      } },
      chevron(),
    } }
end

-- 下载页首屏版本分组列表刷新：展开且未追加过时把该组全部版本行一次性 append 进列表容器
-- （引擎滚动完整列表，无数量上限）；此后折叠/展开只切换列表容器可见性。
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

-- 下载页层级切换：groups=版本分组列表 / install=行内安装面板
local function refreshDownloadState()
  launcher.view("dlGroupsCard"):setVisible(dlLevel == "groups")
  launcher.view("dlViewer"):setVisible(dlLevel == "install")
  if dlLevel == "groups" then
    refreshDownloadGroups()
  else
    refreshInstallPanel()
  end
end

-- ============ 下载页（无侧栏、通栏纵向流：分组卡片）============
-- 首屏 = 版本分组列表（dlGroupsCard）；点具体版本切到行内安装面板（dlViewer）。
local function buildDownloadPage()
  local D = CONFIG.download
  local maxR = D.maxVersionRows or 12

  -- 首屏版本分组：分组头（dlGh_<key>）+ 内联版本列表容器（dlGrpList_<key>，初始为空）。
  local grpRows = {}
  for _, g in ipairs(D.versionGroups or {}) do
    grpRows[#grpRows + 1] = ui.row { id = "dlGh_" .. g.key, height = "7vh", width = "100%",
      background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
      hoverColor = C.hover, crossAlign = "center", spacing = "1.4vh",
      padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGh:" .. g.key,
      children = {
        ui.image { icon = "sf:shippingbox.fill", size = "3vh", corner = "pill",
          background = C.faintBlue, style = { tint = C.accent } },
        ui.text { text = g.name, weight = 1, style = { font = "2.6vh", color = C.dark } },
        chevron(),
      } }
    grpRows[#grpRows + 1] = ui.column { id = "dlGrpList_" .. g.key, width = "100%",
      crossAlign = "stretch", spacing = "0", visible = false, children = {} }
  end
  local groupsCard = ui.column { id = "dlGroupsCard", width = "70%", background = C.card,
    border = BORDER, corner = "1vh", shadow = SHADOW, padding = "0", children = grpRows }

  -- Minecraft 卡内版本行（贴合：无外边距）
  local mcRows = {}
  for i = 1, maxR do
    mcRows[#mcRows + 1] = ui.row { id = "dlIv_" .. i, width = "100%", height = "7vh",
      background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
      hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.2vh", right = "1.2vh" }, action = "dlIv:" .. i, visible = false,
      children = {
        ui.image { id = "dlIv_" .. i .. "_ico", icon = "sf:cube.fill", size = "2.6vh",
          style = { tint = C.mid } },
        ui.column { weight = 1, crossAlign = "stretch", spacing = "0.4vh", children = {
          ui.text { id = "dlIv_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "dlIv_" .. i .. "_date", text = "", width = "100%",
            style = { font = "1.9vh", color = C.mid } },
        } },
        chevron(),
      } }
  end

  -- 行内安装面板（点分组内具体版本后显示）
  local viewer = ui.column { id = "dlViewer", width = "100%", crossAlign = "center",
    spacing = "2vh", visible = false, children = {
      -- 预览卡：版本概览 + 返回分组 + 开始安装
      ui.column { id = "dlPrevCard", width = "70%", background = C.card, border = BORDER,
        corner = "1vh", shadow = SHADOW,
        padding = { left = "2vh", right = "2vh", top = "1.5vh", bottom = "1.5vh" },
        spacing = "1.2vh", crossAlign = "stretch",
        children = {
          ui.row { width = "100%", height = "7vh", crossAlign = "center", spacing = "1.5vh",
            children = {
              ui.image { icon = "sf:shippingbox.fill", size = "6vh", corner = "1.2vh",
                background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
              ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
                ui.text { id = "insVersion", text = PLC.mc, width = "100%",
                  style = { font = "2.9vh", weight = "bold", color = C.dark } },
                ui.text { id = "insSummary", text = D.installHint, width = "100%",
                  style = { font = "2.1vh", color = C.mid } },
              } },
              ui.button { id = "dlBackGrp", label = "‹ 版本列表", width = "18vh", height = "5.5vh",
                background = C.faintBlue, corner = "0.9vh", action = "dlBackGrp",
                style = { font = "2.2vh", tint = C.accent, weight = "bold" } },
              ui.button { id = "insStart", label = "开始安装", width = "22vh", height = "5.5vh",
                background = C.accent, corner = "0.9vh", action = "insStart",
                style = { font = "2.4vh", weight = "bold", tint = C.white } },
            } },
        } },
      -- Minecraft 版本卡 + 行内列表（dlMcToggle 整行点击展开/收起）
      ui.column { id = "dlMcW", width = "70%", background = C.card, border = BORDER_A,
        corner = "1vh", shadow = SHADOW, padding = "0", children = {
          ui.row { id = "dlMcToggle", width = "100%", height = "7vh", background = C.card,
            hoverColor = C.hover, crossAlign = "center", spacing = "1vh",
            padding = { left = "1.6vh", right = "1.6vh" }, action = "dlMcToggle",
            children = {
              ui.text { text = D.mcLabel or "Minecraft", weight = 1,
                style = { font = "2.6vh", weight = "bold", color = C.accent } },
              ui.image { icon = "sf:cube.fill", size = "3vh", style = { tint = C.mid } },
              ui.text { id = "dlMcVersion", text = PLC.mc, style = { font = "2.4vh", color = C.dark } },
              ui.text { text = "▾", style = { font = "2.6vh", color = C.mid } },
            } },
          ui.column { id = "dlMcList", width = "100%", crossAlign = "stretch",
            spacing = "0", children = mcRows },
        } },
      -- 安装提示
      ui.row { width = "70%", background = C.faintBlue, corner = "1vh",
        crossAlign = "center", spacing = "1vh", padding = "1.2vh", children = {
          ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
          ui.text { text = D.installHint, weight = 1, style = { font = "2vh", color = C.dark } },
        } },
      -- 下载进度（track + fill 绝对填充；引擎 setStyle 不支持 width）
      ui.column { id = "dlProgress", width = "70%", visible = false, spacing = "1vh",
        crossAlign = "stretch", children = {
          makeBar("dlBarTrack", "dlBarFill"),
          ui.text { id = "dlProgressLabel", text = "准备中…", width = "100%",
            style = { font = "2.2vh", color = C.dark } },
          ui.button { id = "dlCancel", label = "取消下载", width = "100%", height = "5.2vh",
            background = C.card, border = BORDER_D, corner = "0.7vh", action = "dlCancel",
            style = { font = "2.3vh", tint = C.danger } },
        } },
    } }

  -- 社区资源：搜索 + 结果列表（随 dlSelCat 切换分类）
  local function commPickerRow(id, label, valueId, action)
    return ui.row { id = id, height = "4.8vh", width = "100%", crossAlign = "center",
      hoverColor = C.hover, action = action, children = {
        ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
        ui.spacer { weight = 1 },
        ui.row { width = "60%", height = "4.5vh", background = C.card,
          border = { width = "0.12vh", color = C.fieldBorder }, corner = "0.8vh",
          crossAlign = "center", padding = { left = "1.2vh", right = "1.2vh" }, children = {
            ui.text { id = valueId, text = "…", weight = 1, style = { font = "2.2vh", color = C.dark } },
            ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
          } },
      } }
  end
  local commSlots = {}
  for i = 1, (D.communityResultSlots or 6) do
    commSlots[#commSlots + 1] = ui.row {
      id = "dlComm_" .. i, height = "9vh", background = C.card, corner = "1.1vh",
      border = BORDER, hoverColor = C.hover, crossAlign = "center", spacing = "1.5vh",
      padding = "1.5vh", visible = false, action = "dlComm:" .. i, children = {
        ui.image { icon = "sf:cube.fill", size = "6vh", corner = "pill", background = C.accent,
          style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
          ui.text { id = "dlComm_" .. i .. "_title", text = "", width = "100%",
            style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { id = "dlComm_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "2vh", color = C.mid } },
        } },
        ui.text { id = "dlComm_" .. i .. "_btn", text = "下载",
          style = { font = "2.2vh", color = C.accent } },
      } }
  end
  local searchCard = card("dlSearchCard", {
    ui.text { text = "搜索社区资源", width = "100%",
      style = { font = "2.8vh", weight = "bold", color = C.dark } },
    commPickerRow("dlSrcRow", "搜索源", "dlSrcVal", "dlSrcRow"),
    commPickerRow("dlObjRow", "搜索对象", "dlObjVal", nil),
    commPickerRow("dlKwRow", "搜索关键词", "dlKwVal", "dlKwRow"),
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
      children = { plainButton("dlBtnSearch", "搜索", false, "dlBtnSearch"),
        plainButton("dlBtnReset", "重置", false, "dlBtnReset") } } })
  local resultCards = { ui.text { text = "结果", width = "100%",
    style = { font = "2.8vh", weight = "bold", color = C.dark } } }
  pushAll(resultCards, commSlots)
  resultCards[#resultCards + 1] = ui.text { id = "dlCommStatus", text = D.searchStatusPreset,
    width = "100%", style = { font = "2.2vh", color = C.mid } }
  resultCards[#resultCards + 1] = ui.column { id = "dlCommBarBox", width = "100%", visible = false,
    spacing = "1vh", crossAlign = "stretch", children = {
      makeBar("dlCommBarTrack", "dlCommBarFill"),
      ui.text { id = "dlCommBarLabel", text = "", width = "100%",
        style = { font = "2.2vh", color = C.dark } },
    } }
  local resultCard = card("dlResultCardC", resultCards, { spacing = "1.5vh" })

  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = {
      ui.text { id = "dlTitle", text = D.titleByCat[dlSelCat] or "原版游戏", width = "100%",
        style = { font = "3vh", weight = "bold", color = C.dark } },
      -- 分类1：原版游戏 → 版本分组列表 / 行内安装面板
      ui.column { id = "dlSec_1", width = "100%", crossAlign = "center", spacing = "2vh",
        children = { groupsCard, viewer } },
      -- 分类2..6：社区资源 → 搜索 + 结果列表
      ui.column { id = "dlSecC", width = "100%", crossAlign = "center", spacing = "2vh",
        visible = false, children = { searchCard, resultCard } },
    } }
end

-- ============ 联机页（两分支 + 加入/创建行 + 状态行 + 房间条目卡）============
local MP_MAX_ROOMS = 6

local function mpRoomSlot(i)
  return ui.row { id = "mpRoom_" .. i, height = "7vh", background = C.card,
    border = BORDER, corner = "1.2vh", hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
    padding = "1.5vh", visible = false,
    children = {
      ui.image { id = "mpRoom_" .. i .. "_ico", icon = "sf:square.3.layers.3d", size = "4.4vh",
        corner = "1vh", background = C.accent, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
        ui.text { id = "mpRoom_" .. i .. "_name", text = "", width = "100%",
          style = { font = "2.4vh", weight = "bold", color = C.dark } },
        ui.text { id = "mpRoom_" .. i .. "_status", text = "", width = "100%",
          style = { font = "2vh", color = C.mid } },
      } },
      -- 房间行本身不可点（无 action）：连接/断开与删除都是子按钮
      ui.button { id = "mpRoomC_" .. i, label = "连接", width = "12vh", height = "4.5vh",
        corner = "pill", action = "mpRoomC:" .. i, hoverColor = C.hover,
        style = { font = "2.2vh", tint = C.white, background = C.accent, weight = "bold" } },
      ui.button { id = "mpRoomD_" .. i, label = "删除", width = "10vh", height = "4.5vh",
        corner = "pill", action = "mpRoomD:" .. i, hoverColor = C.hover,
        style = { font = "2.2vh", tint = C.danger, background = C.card, weight = "bold" } },
    } }
end

local function buildMultiPage()
  local slots = {}
  for i = 1, MP_MAX_ROOMS do slots[#slots + 1] = mpRoomSlot(i) end
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      segmentRow("segM", CONFIG.online.branch, "1vh"),
      -- 加入行
      ui.row { id = "mpJoinRow", width = "94%", height = "5.5vh", background = C.card, border = BORDER,
        corner = "1.2vh", crossAlign = "center", padding = "1.5vh", spacing = "1.2vh", hoverColor = C.hover,
        children = {
          ui.image { icon = "sf:link", size = "2.6vh", style = { tint = C.mid } },
          ui.text { weight = 1, text = "输入房间连接码加入房间…", style = { font = "2.2vh", color = C.mid } },
          ui.button { id = "mpJoin", label = "加入", height = "4vh", background = C.accent,
            corner = "pill", style = { font = "2.2vh", tint = C.white } },
        } },
      -- 创建行
      ui.row { id = "mpCreateRow", width = "94%", height = "5.5vh", background = C.card, border = BORDER,
        corner = "1.2vh", crossAlign = "center", padding = "1.5vh", spacing = "1.2vh", hoverColor = C.hover,
        children = {
          ui.image { icon = "sf:plus.circle", size = "2.6vh", style = { tint = C.mid } },
          ui.text { weight = 1, text = "输入 Network ID 创建房间…", style = { font = "2.2vh", color = C.mid } },
          ui.button { id = "mpCreate", label = "创建", height = "4vh", background = C.accent,
            corner = "pill", style = { font = "2.2vh", tint = C.white } },
        } },
      -- 状态行
      ui.row { id = "mpStatusRow", width = "94%", background = C.hintBg, corner = "1vh", crossAlign = "center",
        spacing = "1.2vh", padding = "1.5vh",
        children = {
          ui.text { id = "mpStatusIcon", text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
          ui.text { id = "mpStatus", weight = 1, text = "联机需要双方都能访问服务器，房间连接码用于分享。",
            style = { font = "2.2vh", color = C.dark } },
          ui.button { id = "mpShare", label = "分享房间", width = "16vh", height = "4.5vh",
            corner = "pill", action = "mpShare", hoverColor = C.hover,
            style = { font = "2.2vh", tint = C.accent, background = C.card, weight = "bold" } },
        } },
      -- 房间条目卡
      card("mpRoomCard", (function()
        local k = { ui.text { text = "在线房间", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
        pushAll(k, slots)
        return k
      end)()),
    } }
end

-- ============ 设置页（PCL2 风格：关于卡 + 分组白卡，每组标题 + 行）============
local function buildSettingsPage()
  local kids = {}
  -- 关于卡
  kids[#kids + 1] = ui.column { id = "setAbout", width = "94%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = "3vh", crossAlign = "center", spacing = "1.2vh",
    children = {
      ui.image { icon = "sf:shippingbox.fill", size = "8vh", corner = "1.6vh",
        background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
      ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { text = "版本 · · ·", style = { font = "2.2vh", color = C.mid } },
      ui.text { text = "系统信息 …  ·  设备架构 …", style = { font = "2.2vh", color = C.mid } },
    } }
  -- 分类内容：每分类一个 section（id=setSec_<token>），随左侧目录选中切换可见（行内展开，非跳子页）
  for _, cat in ipairs(SET_CATS) do
    local g = settingsGroupByToken(cat.token)
    local rows = {}
    rows[#rows + 1] = ui.text { text = (CONFIG.settingsGroupNames[cat.token] or cat.label),
      width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } }
    if type(cat.desc) == "string" and cat.desc ~= "" then
      rows[#rows + 1] = ui.text { text = cat.desc, width = "100%",
        style = { font = "2vh", color = C.mid } }
    end
    if g then
      for _, s in ipairs(g.rows or {}) do
        rows[#rows + 1] = settingsItemRow(s)
      end
    else
      rows[#rows + 1] = ui.text { text = "该分类暂无可调项。", width = "100%",
        style = { font = "2.2vh", color = C.mid } }
    end
    kids[#kids + 1] = ui.column { id = "setSec_" .. cat.token, width = "94%", crossAlign = "center",
      spacing = "2vh", visible = (cat.token == setSelCat),
      children = { card("setCard_" .. cat.token, rows, { spacing = "1.5vh" }) } }
  end
  -- 状态提示条（开关/按钮的即时反馈落点；浅蓝底 H）
  kids[#kids + 1] = ui.row { id = "setStatusBar", width = "94%", background = C.hintBg,
    corner = "1vh", crossAlign = "center", spacing = "1.2vh", padding = "1.5vh",
    children = {
      ui.text { id = "setStatusIcon", text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
      ui.text { id = "setStatus", weight = 1, text = CONFIG.settingsStatus,
        style = { font = "2.2vh", color = C.dark } },
    } }
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 更多页（左侧分类 + 右侧分组卡片，仿 PCL 更多页）============
local function buildMorePage()
  local kids = {}
  -- 主题包（Material Pack）信息卡：名称 + 当前加载版本（版本动态填充，不硬编码）
  kids[#kids + 1] = ui.column { id = "moreSec_theme", width = "94%", spacing = "1.2vh",
    crossAlign = "stretch",
    children = {
      ui.text { text = "主题包", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
        padding = "1vh", spacing = "0.5vh",
        children = {
          ui.row { id = "moreThemeName", height = "6.5vh", crossAlign = "center",
            spacing = "1.6vh", padding = "1.8vh",
            children = {
              ui.image { icon = "sf:paintbrush.fill", size = "4.5vh", corner = "pill",
                background = C.faintBlue, style = { tint = C.accent } },
              ui.text { text = "主题包名称", weight = 1, style = { font = "2.6vh", color = C.dark } },
              ui.text { id = "moreThemeName_text", text = "PCL 浅色", style = { font = "2.5vh", color = C.mid } },
            } },
          ui.row { id = "moreThemeVer", height = "6.5vh", crossAlign = "center",
            spacing = "1.6vh", padding = "1.8vh",
            children = {
              ui.image { icon = "sf:tag.fill", size = "4.5vh", corner = "pill",
                background = C.faintBlue, style = { tint = C.accent } },
              ui.text { text = "主题包版本", weight = 1, style = { font = "2.6vh", color = C.dark } },
              ui.text { id = "moreThemeVersion", text = "· · ·", style = { font = "2.5vh", color = C.mid } },
            } },
        } } } }
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, rr in ipairs(g.rows) do
      local rightNode
      if rr.right == "version" then
        rightNode = ui.text { id = rr.id .. "_val", text = "· · ·", style = { font = "2.6vh", color = C.mid } }
      else
        rightNode = chevron()
      end
      rows[#rows + 1] = ui.row { id = rr.id, height = "7vh", crossAlign = "center",
        spacing = "1.6vh", padding = "1.8vh", hoverColor = C.hover, action = (rr.action or "open:more"),
        children = {
          ui.image { icon = rr.icon or "sf:gearshape.fill", size = "4.5vh",
            corner = "pill", background = C.faintBlue, style = { tint = C.accent } },
          ui.text { text = rr.label, weight = 1, style = { font = "2.7vh", color = C.dark } },
          rightNode,
        } }
    end
    kids[#kids + 1] = ui.column { id = "moreSec_" .. g.name, width = "94%", spacing = "1.2vh",
      crossAlign = "stretch",
      children = {
        ui.text { text = g.name, width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
        ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
          padding = "1vh", spacing = "0.5vh", children = rows },
      } }
  end
  if #kids == 0 then
    kids[#kids + 1] = ui.text { text = "暂无更多选项。", style = { font = "2.2vh", color = C.mid } }
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 版本设置页（PCL2 风格：概览 / 设置 / Mod 管理 / 资源 / 高级）============
-- vsSelCat 必须在 buildVersionSettingsPage 之前声明，否则函数体前置引用读到 nil 全局。
local vsSelCat = "info"
local VS_SETTING_KEYS = { "versionIsolation", "windowTitle", "windowInfo", "javaVersion",
  "ramType", "ram", "ramOptimize", "serverIp", "loginMode" }
local VS_MOD_SLOTS = 8      -- Mod 列表固定槽位（引擎列表超出部分滚动/截断）
local VS_SHADER_SLOTS = 8   -- 光影包列表固定槽位
local VS_SETTING_LABELS = {
  versionIsolation = "默认版本隔离",
  windowTitle      = "游戏窗口标题",
  windowInfo       = "自定义信息",
  javaVersion      = "游戏 Java",
  ramType          = "内存分配",
  ram              = "内存大小",
  ramOptimize      = "启动前内存优化",
  serverIp         = "服务器地址",
  loginMode        = "登录模式",
}
local function buildVersionSettingsPage()
  local section = function(token, children)
    return ui.column { id = "vsSec_" .. token, width = "100%", crossAlign = "center",
      spacing = "2.5vh", visible = (token == vsSelCat), children = children }
  end
  -- 概览：版本信息 + 个性化 + 快捷方式 + 高级管理
  local overviewRows = {
    card("vsOverviewCard", {
      ui.row { width = "100%", height = "11vh", crossAlign = "center", spacing = "2vh", padding = "1vh",
        children = {
          ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent,
            corner = "1.2vh", style = { tint = C.white } },
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vsName", text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
            ui.text { id = "vsMeta", text = "版本信息 · · ·", style = { font = "2.1vh", color = C.mid } },
          } },
        } },
    }, { spacing = "1.2vh" }),
    card("vsPersonalize", {
      ui.text { text = "个性化", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      pickerRow("vsIcon",     "图标", "自动", "vsIconVal"),
      pickerRow("vsCategory", "分类", "自动", "vsCategoryVal"),
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsRename", "修改版本名", false),
          plainButton("vsDesc",   "修改描述",   false),
          plainButton("vsFav",    "加入收藏夹", false),
        } },
    }, { spacing = "1.8vh" }),
    card("vsShortcuts", {
      ui.text { text = "快捷方式", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsOpenDir",   "版本文件夹", false, "vsOpenDir"),
          plainButton("vsOpenSaves", "存档文件夹", false, "vsOpenSaves"),
          plainButton("vsOpenMods",  "Mod 文件夹", false, "vsOpenMods"),
        } },
    }, { spacing = "1.8vh" }),
    card("vsAdvOverview", {
      ui.text { text = "高级管理", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsExport",   "导出启动脚本", false),
          plainButton("vsComplete", "补全文件",     false, "vsComplete"),
        } },
      ui.button { id = "vsDeleteTop", label = "删除本版本", width = "100%", height = "5.5vh",
        background = C.card, border = BORDER_D, corner = "0.7vh", action = "vsDelete",
        style = { font = "2.4vh", tint = C.danger } },
    }, { spacing = "1.8vh" }),
  }
  -- 设置：从 engine versionSettings.list 动态取值；点行内取值循环切换并写回（versionSettings.set）
  local settingsRows = {}
  for _, k in ipairs(VS_SETTING_KEYS) do
    settingsRows[#settingsRows + 1] = ui.row { id = "vsSet_" .. k, action = "vsSet:" .. k,
      height = "6.5vh", width = "100%", crossAlign = "center", spacing = "1.5vh",
      hoverColor = C.hover, padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = VS_SETTING_LABELS[k] or k, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = "vsSet_" .. k .. "Val", text = "···", style = { font = "2.3vh", color = C.mid } },
        ui.text { text = " ▾", style = { font = "2.3vh", color = C.mid } },
      } }
  end
  settingsRows[#settingsRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
    children = { plainButton("vsReset", "重置版本设置", false, "vsReset") } }

  -- Mod 管理：mods.list 真实填充固定槽位，支持启用/停用（toggle）与删除（delete）
  local modRows = {
    ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh",
      children = {
        plainButton("vsModOpenDir",  "打开 Mod 文件夹", false, "vsModOpenDir"),
        plainButton("vsModRefresh",  "刷新列表",        false, "vsModRefresh"),
        plainButton("vsModDownload", "下载新 Mod",      false, "open:download"),
      } },
    ui.text { id = "vsModEmpty", text = "当前版本未安装 Mod 加载器或暂无 Mod。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
  }
  for i = 1, VS_MOD_SLOTS do
    modRows[#modRows + 1] = ui.row { id = "vsMod_" .. i, height = "7vh", width = "100%",
      background = C.card, border = BORDER, corner = "0.8vh", crossAlign = "center",
      spacing = "1.2vh", padding = { left = "1.2vh", right = "1.2vh" }, visible = false,
      children = {
        ui.image { id = "vsMod_" .. i .. "_ico", icon = "sf:puzzlepiece.extension.fill", size = "3vh",
          style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "vsMod_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "vsMod_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "1.9vh", color = C.mid } },
        } },
        ui.button { id = "vsModT_" .. i, label = "启用", width = "12vh", height = "4.2vh",
          corner = "pill", action = "vsModT:" .. i, hoverColor = C.hover,
          style = { font = "2.1vh", tint = C.accent, background = C.faintBlue, weight = "bold" } },
        ui.button { id = "vsModX_" .. i, label = "删除", width = "10vh", height = "4.2vh",
          corner = "pill", action = "vsModX:" .. i, hoverColor = C.hover,
          style = { font = "2.1vh", tint = C.danger, background = C.card, weight = "bold" } },
      } }
  end

  -- 资源包 / 光影：shaders 服务同构（list/refresh/toggle/delete）
  local shaderRows = {
    ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh",
      children = {
        plainButton("vsShadeOpenDir", "打开版本目录", false, "vsShadeOpenDir"),
        plainButton("vsShadeRefresh", "刷新列表",     false, "vsShadeRefresh"),
      } },
    ui.text { id = "vsShadeEmpty", text = "当前版本暂无光影包。",
      width = "100%", style = { font = "2.2vh", color = C.mid } },
  }
  for i = 1, VS_SHADER_SLOTS do
    shaderRows[#shaderRows + 1] = ui.row { id = "vsShade_" .. i, height = "7vh", width = "100%",
      background = C.card, border = BORDER, corner = "0.8vh", crossAlign = "center",
      spacing = "1.2vh", padding = { left = "1.2vh", right = "1.2vh" }, visible = false,
      children = {
        ui.image { id = "vsShade_" .. i .. "_ico", icon = "sf:sparkles", size = "3vh",
          style = { tint = C.cyan } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "vsShade_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "vsShade_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "1.9vh", color = C.mid } },
        } },
        ui.button { id = "vsShadeT_" .. i, label = "启用", width = "12vh", height = "4.2vh",
          corner = "pill", action = "vsShadeT:" .. i, hoverColor = C.hover,
          style = { font = "2.1vh", tint = C.accent, background = C.faintBlue, weight = "bold" } },
        ui.button { id = "vsShadeX_" .. i, label = "删除", width = "10vh", height = "4.2vh",
          corner = "pill", action = "vsShadeX:" .. i, hoverColor = C.hover,
          style = { font = "2.1vh", tint = C.danger, background = C.card, weight = "bold" } },
      } }
  end

  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      section("info",     overviewRows),
      section("launch",   { card("vsSettingsCard", settingsRows, { spacing = "1.5vh" }) }),
      section("mod",      { card("vsModCard", modRows, { spacing = "1.5vh" }) }),
      section("resource", { card("vsResource", shaderRows, { spacing = "1.5vh" }) }),
      section("advanced", {
        card("vsAdv", {
          ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
            children = {
              plainButton("vsAdv1", "打开安装目录", false, "vsOpenDir"),
              plainButton("vsAdv2", "存档文件夹",   false, "vsOpenSaves"),
              plainButton("vsAdv3", "重置版本",     false, "vsReset"),
            } },
          ui.button { id = "vsAdvDanger", label = "删除本版本", width = "100%", height = "5.5vh",
            background = C.card, border = BORDER_D, corner = "0.7vh", action = "vsDelete",
            style = { font = "2.4vh", tint = C.danger } },
        }),
      }),
    } }
end

-- ============ 版本管理二级页（列表 + 选中 + 返回可回首页）============
local function buildVersionManagerPage()
  local kids = {
    -- 页眉：返回首页 + 标题
    ui.row { id = "vmHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "vmBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.versionManager.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  -- 固定槽位：onPageChange 用 version.list 填充；多余槽位 setVisible(false)
  for i = 1, MANAGER_SLOTS do
    kids[#kids + 1] = ui.row { id = "vm_" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      hoverColor = C.hover, visible = false, action = "vmSel:" .. i,
      children = {
        ui.image { id = "vm_" .. i .. "_ico", icon = "sf:cube.fill", size = "4.5vh", corner = "1vh",
          background = C.accent, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "vm_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { id = "vm_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "2vh", color = C.mid } },
        } },
        chevron(),
      } }
  end
  kids[#kids + 1] = ui.text { id = "vmEmpty", text = CONFIG.versionManager.emptyText, width = "94%",
    style = { font = "2.2vh", color = C.mid } }
  kids[#kids + 1] = plainButton("vmAdd", "前往下载新版本", false, "open:download")
  return ui.column { id = "pageVersionManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 账号管理二级页（已登录账号列表 + 返回首页）============
local function buildAccountManagerPage()
  local kids = {
    ui.row { id = "amHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "amBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.accountManager.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for i = 1, MANAGER_SLOTS do
    kids[#kids + 1] = ui.row { id = "am_" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      hoverColor = C.hover, visible = false, action = "amSel:" .. i,
      children = {
        ui.image { id = "am_" .. i .. "_ico", icon = "sf:person.crop.circle.fill", size = "4.5vh", corner = "1vh",
          background = C.avatarBg, style = { tint = C.avatarLine } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "am_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { id = "am_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "2vh", color = C.mid } },
        } },
        chevron(),
      } }
  end
  kids[#kids + 1] = ui.text { id = "amEmpty", text = CONFIG.accountManager.emptyText, width = "94%",
    style = { font = "2.2vh", color = C.mid } }
  kids[#kids + 1] = plainButton("amAdd", "登录 / 添加账号", true, "amAdd")
  return ui.column { id = "pageAccountManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 游戏目录二级页（默认 + instances 子目录列表，新建目录）============
local function buildGameDirectoryPage()
  local kids = {
    ui.row { id = "gdHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "gdBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.gameDirectory.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for i = 1, MANAGER_SLOTS do
    kids[#kids + 1] = ui.row { id = "gd_" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      hoverColor = C.hover, visible = false,
      children = {
        ui.image { id = "gd_" .. i .. "_ico", icon = "sf:folder.fill", size = "4.5vh", corner = "1vh",
          background = C.faintBlue, style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "gd_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { id = "gd_" .. i .. "_meta", text = "", width = "100%",
            style = { font = "2vh", color = C.mid } },
        } },
        ui.button { id = "gdPick_" .. i, label = "使用", width = "26%", height = "5vh",
          action = "gdSel:" .. i, corner = "pill", hoverColor = C.hover,
          background = C.card, border = BORDER_A,
          style = { font = "2.3vh", tint = C.accent, weight = "bold" } },
      } }
  end
  kids[#kids + 1] = ui.text { id = "gdEmpty", text = CONFIG.gameDirectory.emptyText, width = "94%",
    style = { font = "2.2vh", color = C.mid } }
  -- 新建目录输入行（输入框节点，引擎 updateText/getText 落点）
  kids[#kids + 1] = ui.row { width = "94%", height = "6vh", background = C.card, border = BORDER,
    corner = "1.2vh", crossAlign = "center", padding = "1.2vh", spacing = "1.2vh",
    children = {
      ui.input { id = "gdNewIn", placeholder = CONFIG.gameDirectory.addPlaceholder, weight = 1,
        height = "4.6vh", background = C.card, corner = "0.8vh", border = BORDER,
        style = { font = "2.3vh", tint = C.dark } },
      ui.button { id = "gdCreate", label = "新建", width = "26%", height = "5vh",
        action = "gdCreate", corner = "pill", hoverColor = C.hover,
        background = C.card, border = BORDER_A,
        style = { font = "2.3vh", tint = C.accent, weight = "bold" } },
    } }
  return ui.column { id = "pageGameDirectory", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 根构建 ============
-- 联机房间列表刷新：multiplayer.list 填充固定槽位；连接/删除按钮 id = mpRoomC_<i> / mpRoomD_<i>
local function refreshMultiRooms()
  local resp = launcher.service and launcher.service("multiplayer", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  for i = 1, MP_MAX_ROOMS do
    local it = items[i]
    local row = launcher.view("mpRoom_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        local status = it.status or "未连接"
        if it.hostIP and it.hostIP ~= "" then
          status = status .. " · " .. tostring(it.hostIP) .. ":" .. tostring(it.hostPort or "25565")
        end
        launcher.view("mpRoom_" .. i .. "_name"):setText(it.name or ("房间 " .. i))
        launcher.view("mpRoom_" .. i .. "_status"):setText(status)
        launcher.view("mpRoomC_" .. i):setText((it.isCurrent == true) and "断开" or "连接")
      end
    end
  end
end

-- 通用侧边栏条目：左图标 + 标题，可选选中指示（圆点）
-- 文本包一层 weight=1 的列（与该启用的版本行结构一致），确保标签始终可见。
local function sidebarItem(id, icon, label, action, dotId)
  local kids = {}
  if icon then
    kids[#kids + 1] = ui.image { id = id .. "Icon", icon = icon, size = "3vh", corner = "pill",
      background = C.faintBlue, style = { tint = C.accent } }
  end
  if dotId then
    kids[#kids + 1] = ui.image { id = dotId, icon = "sf:circle", size = "2.6vh",
      style = { tint = C.mid } }
  end
  kids[#kids + 1] = ui.column { weight = 1, crossAlign = "stretch", children = {
    ui.text { id = id .. "Txt", text = label, width = "100%", style = { font = "2.3vh", color = C.dark } },
  } }
  return ui.row {
    id = id, height = "6vh", width = "100%", background = C.card, corner = "0.9vh",
    hoverColor = C.hover, action = action, crossAlign = "center", spacing = "1vh",
    padding = { left = "1.4vh", right = "1.4vh" },
    children = kids,
  }
end

-- 侧栏项选中态：PCL2 左侧目录选中项为「主题蓝实底 + 白字」，未选中为白底深字。
-- 依赖 sidebarItem 为图标/文字生成的 `<id>Icon` / `<id>Txt` 子节点 id。
local function applySidebarSel(id, sel)
  local row = launcher.view(id)
  if row then
    row:setStyle(sel
      and { background = C.accent, borderColor = C.accentBorder }
      or  { background = C.card, borderColor = C.cardBorder })
  end
  local txt = launcher.view(id .. "Txt")
  if txt then txt:setTextColor(sel and C.white or C.dark) end
  local ic = launcher.view(id .. "Icon")
  if ic then
    ic:setStyle(sel
      and { background = C.white, tint = C.accent }
      or  { background = C.faintBlue, tint = C.accent })
  end
end

-- 设置页左侧分类目录侧栏（仿 PCL PageSetupLeft；数据驱动 SET_CATS=settings.list，未就绪回退 CONFIG）
local function buildSettingsSidebar()
  local kids = { ui.text { text = "设置", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, cat in ipairs(SET_CATS) do
    kids[#kids + 1] = sidebarItem("setCat_" .. cat.token, cat.icon, cat.label, "setCat:" .. cat.token)
  end
  return kids
end

-- 版本设置页左侧分类目录侧栏（仿 PCL PageVersionSetupLeft）
local VS_CATS = {
  { token = "info",     label = "概览",       icon = "sf:info.circle.fill" },
  { token = "launch",   label = "设置",       icon = "sf:play.fill" },
  { token = "mod",      label = "Mod 管理",   icon = "sf:hud" },
  { token = "resource", label = "资源包 / 光影", icon = "sf:sun.max.fill" },
  { token = "advanced", label = "高级管理",   icon = "sf:gearshape.2.fill" },
}
local function buildVersionSettingsSidebar()
  local kids = { ui.text { text = "版本设置", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, c in ipairs(VS_CATS) do
    kids[#kids + 1] = sidebarItem("vsCat_" .. c.token, c.icon, c.label, "vsCat:" .. c.token)
  end
  return kids
end

-- 更多页左侧分类目录侧栏（moreGroups 的名称即分类 token）
local moreSelCat = "启动"
local function buildMoreSidebar()
  local kids = { ui.text { text = "更多", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, g in ipairs(CONFIG.moreGroups) do
    kids[#kids + 1] = sidebarItem("moreCat_" .. g.name, nil, g.name, "moreCat:" .. g.name)
  end
  return kids
end

-- 下载页左侧分类目录侧栏（仿 PCL PageDownloadLeft：原版游戏 / 社区资源各类）
-- dlSelCat 已在文件上方「下载页状态」块声明，此处不可再 local（否则与 buildDownloadPage 读到不同变量）。
local function buildDownloadSidebar()
  local kids = {}
  local idx = 0
  for _, g in ipairs(CONFIG.download.sidebarGroups) do
    kids[#kids + 1] = ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } }
    for _, it in ipairs(g.items) do
      idx = idx + 1
      kids[#kids + 1] = sidebarItem(it.id, nil, it.label, "dlCat:" .. idx, "dlCatDot_" .. idx)
    end
  end
  return kids
end

local function refreshDownloadSidebar()
  for i = 1, #CONFIG.download.titleByCat do
    local sel = (i == dlSelCat)
    launcher.view("dlCatDot_" .. i):setImage(sel and "sf:circle.inset.filled" or "sf:circle")
    launcher.view("dlCatDot_" .. i):setStyle(sel and { tint = C.accent } or { tint = C.mid })
  end
end

-- ============ 社区资源（下载页）搜索与下载 ============
local dlSource = 1        -- 搜索源索引（CONFIG.download.searchSources）
local dlKeyword = ""      -- 当前搜索关键词
local dlCommItems = {}    -- 最近一次结果缓存（槽位索引 → 条目）供点击下载使用
local commDownloading = false

local function commCategory()
  return CONFIG.download.searchObjects[dlSelCat - 1] or "mod"
end

local function commSource()
  return CONFIG.download.searchSources[dlSource] or CONFIG.download.searchSources[1]
end

local function clearCommunityResults()
  for i = 1, CONFIG.download.communityResultSlots do
    launcher.view("dlComm_" .. i):setVisible(false)
  end
  dlCommItems = {}
end

local function refreshCommunitySearch()
  launcher.view("dlSrcVal"):setText(commSource().name or "…")
  launcher.view("dlObjVal"):setText(CONFIG.download.titleByCat[dlSelCat] or "…")
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or CONFIG.download.keywordPlaceholder)
  clearCommunityResults()
  launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
  launcher.view("dlCommBarBox"):setVisible(false)
  commDownloading = false
end

local function doCommunitySearch()
  if dlSelCat <= 1 then return end
  local kw = tostring(dlKeyword):gsub("^%s+", ""):gsub("%s+$", "")
  if kw == "" then
    launcher.view("dlCommStatus"):setText("请先点击「搜索关键词」输入要搜索的内容")
    return
  end
  launcher.service("community", "search", {
    source = commSource().id, category = commCategory(),
    keyword = kw, limit = CONFIG.download.communityResultSlots,
  })
  launcher.view("dlCommStatus"):setText("正在搜索「" .. kw .. "」…")
end

-- 事件：搜索完成，填充结果槽位
function onCommunityResults(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  for i = 1, CONFIG.download.communityResultSlots do
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
  launcher.view("dlCommStatus"):setText(#items == 0
    and "未找到结果，换个关键词试试"
    or ("共 " .. #items .. " 条结果，点击条目下载最新版本"))
end

-- 事件：下载/搜索进度或状态提示
function onCommunityStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or ""
  if msg == "" then return end
  if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText(msg) end
  if msg:find("已下载", 1, true) or msg:find("完成", 1, true) then
    launcher.view("dlCommBarBox"):setVisible(false)
    commDownloading = false
  end
end

-- 事件：下载进度推流，更新进度条与文本
function onCommunityProgress(payload)
  local p = (type(payload) == "table" and payload.items and payload.items[1]) or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  launcher.view("dlCommBarBox"):setVisible(true)
  updateBar("dlCommBarTrack", "dlCommBarFill", pct)
  launcher.view("dlCommBarLabel"):setText(p.finished and "下载完成" or ("下载中 " .. pct .. "%…"))
end

-- 事件：关键词输入弹窗返回
function onCommunityKeyword(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  dlKeyword = (items[1] ~= nil) and items[1] or ""
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or CONFIG.download.keywordPlaceholder)
end

function build(ui)
  SET_CATS = computeSettingsCats()
  if #SET_CATS > 0 then
    local okCat = false
    for _, c in ipairs(SET_CATS) do if c.token == setSelCat then okCat = true break end end
    if not okCat then setSelCat = SET_CATS[1].token end
  end
  local homeSidebar = buildHomeSidebar()
  local pageHome = buildHomePage()
  -- 内容区页子树：显式页（token ∈ CONFIG.pages；设置分类为页内行内切换，不建子页）
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
  }

  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0,
    children = {
      -- 顶栏：蓝色渐变通栏（PCL2 顶栏为渐变而非纯色），页签选中态套白底全圆药丸
      ui.row { id = "titlebar", height = "8.5vh",
        background = { from = C.topbarFrom, to = C.topbarTo, angle = 90 }, crossAlign = "center",
        padding = { left = "1.4vh", right = "1.5vh" },
        children = {
          -- PCL II 徽标：白底圆角方块 + 主题蓝字，右侧「II」
          ui.row { id = "logoBadge", corner = "0.7vh", background = C.white, crossAlign = "center",
            padding = { left = "0.9vh", right = "0.9vh", top = "0.35vh", bottom = "0.35vh" },
            children = {
              ui.text { id = "logo", text = "PCL", style = { font = "2.7vh", weight = "bold", color = C.topbarTo } },
            } },
          ui.text { id = "logoII", text = "II", style = { font = "2.3vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row { id = "tabs", spacing = "5vh", crossAlign = "center",
            children = (function()
              local nodes = {}
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
              return nodes
            end)() },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        } },
      -- 内容区（split_column：左 32% 白侧栏 + 右 68%）
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0,
        children = {
          ui.column { id = "left", width = "32%", background = C.card, crossAlign = "center",
            spacing = "0.4vh", padding = { left = "2vh", right = "2vh", top = "1vh", bottom = "1vh" },
            children = {
              -- 左栏按页切换：启动=账号卡；下载=分类目录；设置/版本设置/更多=各自分类目录
              ui.column { id = "leftHome", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", children = homeSidebar },
              ui.column { id = "leftDownload", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildDownloadSidebar() },
              ui.column { id = "leftSettings", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildSettingsSidebar() },
              ui.column { id = "leftVersionSettings", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildVersionSettingsSidebar() },
              ui.column { id = "leftMore", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildMoreSidebar() },
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
local selectedCap = 3
local CAPS = { "mojang", "microsoft", "offline" }
local CAPS_LABEL = { "Mojang", "微软", "离线" }
local segSel = { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }

local function selectTab(tabId)
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.card, tint = C.accent, corner = "pill" }
      or  { background = C.transparent, tint = C.white, corner = "pill" })
  end
end

local function selectCap(idx)
  selectedCap = idx
  for i, key in ipairs(CAPS) do
    local sel = (i == idx)
    launcher.view("cap." .. key):setStyle(sel
      and { background = C.accent, tint = C.white, borderWidth = 1.5, borderColor = C.accent }
      or  { background = C.card, tint = C.accent, borderWidth = 1.5, borderColor = C.accent })
  end
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  launcher.view("accountName"):setText(name)
  launcher.view("accountType"):setText(CAPS_LABEL[idx])
end

-- 分段标签选中：白底全圆药丸（labels 由调用方给出，避免读到已删除的配置）
local function selectSegment(prefix, labels, idx)
  if type(labels) ~= "table" then return end
  segSel[prefix] = idx
  for i = 1, #labels do
    local sel = (i == idx)
    launcher.view(prefix .. "_" .. i):setStyle(sel
      and { background = C.card, tint = C.accent, corner = "pill" }
      or  { background = C.transparent, tint = C.dark, corner = "pill" })
  end
end

local function refreshAccount()
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  launcher.view("accountName"):setText(name)
end

local function refreshVersion()
  local ver = launcher.state and launcher.state.version
  launcher.view("launchSub"):setText((ver and ver.name) or "尚未选择版本")
end

function onReady()
  refreshAccount()
  refreshVersion()
  selectCap(selectedCap)
  selectSegment("segM", CONFIG.online.branch, segSel["segM"] or 1)
  -- 预取远程版本清单，使下载页首屏分组展开与行内安装面板可用
  refreshDownloadVersions()
  onPageChange(currentPage)
end

function onLayout()
  -- 无绝对定位游标，无需在布局后补定位；保留钩子供引擎调用
end

function onAccountChange(account)
  if type(account) ~= "table" then return end
  launcher.view("accountName"):setText(account.name or "未登录")
end

-- 联机房间列表/状态刷新
function onMultiplayerRooms(payload)
  refreshMultiRooms()
end

function onMultiplayerStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "联机状态已更新"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
  refreshMultiRooms()
end

function onMultiplayerProgress(payload)
  local msg = (type(payload) == "table" and payload.message) or "连接中…"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
end

-- 真下载进度推流（download.start 后由引擎每 0.3s 上报）：更新进度条与文本。
function onDownloadUpdate(payload)
  local p = payload or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  updateBar("dlBarTrack", "dlBarFill", pct)
  launcher.view("dlProgressLabel"):setText(p.finished and ("安装完成（" .. pct .. "%）") or ("下载中 " .. pct .. "%…"))
end

-- 版本清单异步拉取完成：刷新下载页原版版本分组卡。
function onRemoteVersions(payload)
  refreshDownloadVersions()
end

local function refreshSettingsSidebar()
  for _, cat in ipairs(SET_CATS) do
    local sel = (cat.token == setSelCat)
    applySidebarSel("setCat_" .. cat.token, sel)
    local sec = launcher.view("setSec_" .. cat.token)
    if sec then sec:setVisible(sel) end
  end
end

local function refreshVersionSettingsSidebar()
  for _, c in ipairs(VS_CATS) do
    local sel = (c.token == vsSelCat)
    applySidebarSel("vsCat_" .. c.token, sel)
  end
end

local function refreshVersionSettingsContent()
  for _, c in ipairs(VS_CATS) do
    local v = launcher.view("vsSec_" .. c.token)
    if v then v:setVisible(c.token == vsSelCat) end
  end
end

local function refreshVersionSettingsValues()
  local ver = launcher.state and launcher.state.version
  local name = (ver and ver.name) or "未选择版本"
  if launcher.view("vsName") then launcher.view("vsName"):setText(name) end
  if launcher.view("vsMeta") then
    launcher.view("vsMeta"):setText("版本信息 · " ..
      (name == "未选择版本" and "请先在版本选择中指定" or "本地版本"))
  end
  local resp = launcher.service and launcher.service("versionSettings", "list", {}) or nil
  if type(resp) == "table" and resp.ok and type(resp.items) == "table" then
    for _, it in ipairs(resp.items) do
      local k = it.key
      local v = launcher.view("vsSet_" .. k .. "Val")
      if v then v:setText(tostring(it.value or "···")) end
    end
  end
end

local function refreshMoreSidebar()
  for _, g in ipairs(CONFIG.moreGroups) do
    local sel = (g.name == moreSelCat)
    applySidebarSel("moreCat_" .. g.name, sel)
  end
end

local function refreshMoreContent()
  for _, g in ipairs(CONFIG.moreGroups) do
    local v = launcher.view("moreSec_" .. g.name)
    if v then v:setVisible(g.name == moreSelCat) end
  end
  -- 动态填充更多页版本类条目：主题信息卡 + 标注 right="version" 的行。
  -- 数据来自 launcher.getState() 快照（引擎 source of truth），不在此硬编码。
  local st = launcher.getState and launcher.getState() or {}
  local ui = (type(st.ui) == "table") and st.ui or nil
  local themeName = launcher.view("moreThemeName_text")
  local themeVersion = launcher.view("moreThemeVersion")
  if themeName and ui and ui.name and ui.name ~= "" then themeName:setText(ui.name) end
  if themeVersion and ui and ui.version and ui.version ~= "" then
    themeVersion:setText(ui.version)
  else
    -- 引擎未提供包版本时退回「本地已安装默认版本」，避免显示"···"旧占位。
    local defVer = launcher.view("moreDefaultVersion_val")
    if themeVersion and defVer then themeVersion:setText(defVer:getText() or "") end
  end
  for _, g in ipairs(CONFIG.moreGroups) do
    for _, rr in ipairs(g.rows or {}) do
      if rr.right == "version" and rr.id then
        local val = launcher.view(rr.id .. "_val")
        if val then
          local text
          if rr.id == "moreDefaultVersion" then
            local acc = (type(st.version) == "table" and st.version.name) or ""
            text = (acc ~= "" and acc) or "未选择"
          else
            text = "· · ·" -- 其他 future 版本行暂保结构占位
          end
          val:setText(text)
        end
      end
    end
  end
end

-- 版本管理页：version.list 填充固定槽位，selected 高亮（点行 → version.select）。
local function refreshVersionManager()
  local resp = launcher.service and launcher.service("version", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for i = 1, MANAGER_SLOTS do
    local it = items[i]
    local row = launcher.view("vm_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("vm_" .. i .. "_name"):setText(it.id or "")
        launcher.view("vm_" .. i .. "_meta"):setText((it.selected == true)
          and "当前使用 · 已安装" or (tostring(it.type or "custom") .. " · 已安装"))
      end
    end
  end
  launcher.view("vmEmpty"):setVisible(#items == 0)
end

-- 账号管理页：account.list 填充固定槽位，selected 高亮（点行 → account.select）。
local function refreshAccountManager()
  local resp = launcher.service and launcher.service("account", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  local TYPE_LABEL = { offline = "离线账号", microsoft = "微软账号", thirdparty = "第三方账号" }
  for i = 1, MANAGER_SLOTS do
    local it = items[i]
    local row = launcher.view("am_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("am_" .. i .. "_name"):setText(it.username or it.id or "")
        local tl = TYPE_LABEL[it.type] or "账号"
        launcher.view("am_" .. i .. "_meta"):setText((it.selected == true) and (tl .. " · 当前账号") or tl)
      end
    end
  end
  launcher.view("amEmpty"):setVisible(#items == 0)
end

-- 游戏目录页：gameDir.list 填充固定槽位，selected 标记「使用中」（点按钮 → gameDir.set）。
local function refreshGameDirectory()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for i = 1, MANAGER_SLOTS do
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
  launcher.view("gdEmpty"):setVisible(#items == 0)
end

-- 版本设置 · Mod 管理：mods.list 填充固定槽位（toggle/delete 用 0 起 index）。
local function refreshVersionSettingsMods()
  local resp = launcher.service and launcher.service("mods", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for i = 1, VS_MOD_SLOTS do
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
  launcher.view("vsModEmpty"):setVisible(#items == 0)
end

-- 版本设置 · 资源包 / 光影：shaders.list 填充固定槽位（与 mods 同构）。
local function refreshVersionSettingsShaders()
  local resp = launcher.service and launcher.service("shaders", "list", {}) or nil
  local items = (type(resp) == "table" and type(resp.items) == "table") and resp.items or {}
  for i = 1, VS_SHADER_SLOTS do
    local it = items[i]
    local row = launcher.view("vsShade_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("vsShade_" .. i .. "_name"):setText(it.name or it.fileName or "")
        local meta = {}
        if type(it.author) == "string" and it.author ~= "" then meta[#meta + 1] = it.author end
        if type(it.gameVersion) == "string" and it.gameVersion ~= "" then meta[#meta + 1] = it.gameVersion end
        launcher.view("vsShade_" .. i .. "_meta"):setText(#meta > 0 and table.concat(meta, " · ") or (it.fileName or ""))
        launcher.view("vsShadeT_" .. i):setText((it.enabled == true) and "停用" or "启用")
      end
    end
  end
  launcher.view("vsShadeEmpty"):setVisible(#items == 0)
end

function onPageChange(page)
  currentPage = page or currentPage
  page = currentPage
  local isDownload = (page == "download")
  local isSettings = (page == "settings")
  local isVersionSettings = (page == "version_settings")
  local isMore = (page == "more")
  local isMulti = (page == "multi")
  local isFull = (page == "versionManager") or (page == "accountManager") or (page == "gameDirectory")

  launcher.view("titlebar"):setVisible(true)
  -- 有左栏的页：启动 / 下载 / 设置 / 版本设置 / 更多；管理类二级页与联机为全幅无左栏。
  launcher.view("left"):setVisible(not isFull and not isMulti)
  launcher.view("leftHome"):setVisible(page == "home")
  launcher.view("leftDownload"):setVisible(isDownload)
  launcher.view("leftSettings"):setVisible(isSettings)
  launcher.view("leftVersionSettings"):setVisible(isVersionSettings)
  launcher.view("leftMore"):setVisible(isMore)

  if isDownload then
    refreshDownloadSidebar()
    refreshDownloadVersions()
    dlLevel = "groups" -- 每次进入下载页都从版本分组列表开始
    launcher.view("dlTitle"):setText(CONFIG.download.titleByCat[dlSelCat] or "")
    launcher.view("dlSec_1"):setVisible(dlSelCat == 1)
    launcher.view("dlSecC"):setVisible(dlSelCat > 1)
    refreshDownloadState()
    if dlSelCat > 1 then refreshCommunitySearch() end
  elseif isSettings then
    refreshSettingsSidebar()
  elseif isVersionSettings then
    refreshVersionSettingsSidebar()
    refreshVersionSettingsContent()
    refreshVersionSettingsValues()
    refreshVersionSettingsMods()
    refreshVersionSettingsShaders()
  elseif isMore then
    refreshMoreSidebar()
    refreshMoreContent()
  elseif isMulti then
    refreshMultiRooms()
  elseif page == "versionManager" then
    refreshVersionManager()
  elseif page == "accountManager" then
    refreshAccountManager()
  elseif page == "gameDirectory" then
    refreshGameDirectory()
  end

  local tabId = PAGE_TAB[page]
  if tabId then selectTab(tabId) end
end

-- 下载结束事件（download.start 后引擎回调）：成功刷新版本列表，失败/取消恢复进度区文案。
function onDownloadFinished(payload)
  local p = payload or {}
  if p.cancelled then
    launcher.view("dlProgressLabel"):setText("下载已取消")
    updateBar("dlBarTrack", "dlBarFill", 0)
  elseif p.success then
    launcher.view("dlProgressLabel"):setText("安装完成：" .. tostring(p.versionId or PLC.mc or ""))
    refreshVersionManager()
    refreshVersion()
  else
    launcher.view("dlProgressLabel"):setText("下载失败：" .. tostring(p.error or "未知错误"))
  end
end

-- 资源中心 / 光影包异步扫描完成
function onModsUpdated(payload)
  refreshVersionSettingsMods()
end

function onShadersUpdated(payload)
  refreshVersionSettingsShaders()
end

-- 点击分发：引擎把被点节点 id 交给 onClick（非 action 名）。先用 baseId 剥掉子节点
-- 后缀（如 _sw/_v/_name/_btn）还原到行 id，再按行 id 分发；带参数的按钮 id 单独匹配。
function onClick(id)
  launcher.log("[Lua.onClick] id=" .. tostring(id))
  -- 顶栏页签
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id) return end
  end
  -- 账号类型胶囊
  if id == "cap.mojang" then selectCap(1) return end
  if id == "cap.microsoft" then selectCap(2) return end
  if id == "cap.offline" then selectCap(3) return end

  local base = baseId(id)

  -- ===== 下载页：分组展开 / 版本选择 / 安装 / 取消 =====
  local dgh = base:match("^dlGh_(.+)$")
  if dgh then
    -- 分组无版本数据时不展开（避免 toggle 后出现空列表）
    if #(dlGroups[dgh] or {}) == 0 then return end
    dlOpenGroup[dgh] = not (dlOpenGroup[dgh] == true)
    refreshDownloadGroups()
    return
  end
  -- 注意：string.match 多捕获返回多值，必须分别接收（不能当表用）
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
  if base == "dlBackGrp" then
    dlLevel = "groups"
    refreshDownloadState()
    return
  end
  if base == "insStart" then
    if PLC.mc == "" or PLC.mc == nil then
      launcher.view("dlProgressLabel"):setText("请先选择 Minecraft 版本")
      launcher.view("dlProgress"):setVisible(true)
      return
    end
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("准备下载 " .. PLC.mc .. " …")
    updateBar("dlBarTrack", "dlBarFill", 0)
    launcher.service("download", "start", { versionId = PLC.mc })
    return
  end
  if base == "dlCancel" then
    launcher.service("download", "cancel", {})
    return
  end
  -- 下载页左侧分类目录
  local dlc = base:match("^dlCat_(%d+)$")
  if dlc then
    dlSelCat = tonumber(dlc) or 1
    refreshDownloadSidebar()
    launcher.view("dlTitle"):setText(CONFIG.download.titleByCat[dlSelCat] or "")
    launcher.view("dlSec_1"):setVisible(dlSelCat == 1)
    launcher.view("dlSecC"):setVisible(dlSelCat > 1)
    if dlSelCat > 1 then refreshCommunitySearch() end
    return
  end

  -- ===== 下载页 · 社区资源 =====
  if base == "dlSrcRow" then
    dlSource = (dlSource % #CONFIG.download.searchSources) + 1
    launcher.view("dlSrcVal"):setText(commSource().name or "…")
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
    return
  end
  if base == "dlObjRow" then
    -- 对象随左侧分类联动，无需切换
    return
  end
  if base == "dlKwRow" then
    launcher.service("community", "promptKeyword", { category = commCategory() })
    return
  end
  if base == "dlBtnSearch" then doCommunitySearch() return end
  if base == "dlBtnReset" then
    dlKeyword = ""
    launcher.view("dlKwVal"):setText(CONFIG.download.keywordPlaceholder)
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
    launcher.view("dlCommBarBox"):setVisible(false)
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
      launcher.service("community", "download", {
        source = commSource().id, category = commCategory(),
        projectId = it.id, title = it.title,
      })
    end
    return
  end

  -- ===== 设置页 =====
  local sc = base:match("^setCat_(.+)$")
  if sc then
    setSelCat = sc
    refreshSettingsSidebar()
    return
  end
  local se = base:match("^setit_(.+)$")
  if se then
    applySettingToggle(se)
    return
  end

  -- ===== 版本设置页 =====
  local vsc = base:match("^vsCat_(.+)$")
  if vsc then
    vsSelCat = vsc
    refreshVersionSettingsSidebar()
    refreshVersionSettingsContent()
    return
  end
  local vsk = base:match("^vsSet_(.+)$")
  if vsk then
    cycleVersionSetting(vsk)
    return
  end
  local vmt = id:match("^vsModT_(%d+)$")
  if vmt then
    launcher.service("mods", "toggle", { index = tonumber(vmt) - 1 })
    return
  end
  local vmx = id:match("^vsModX_(%d+)$")
  if vmx then
    launcher.service("mods", "delete", { index = tonumber(vmx) - 1 })
    return
  end
  local vst = id:match("^vsShadeT_(%d+)$")
  if vst then
    launcher.service("shaders", "toggle", { index = tonumber(vst) - 1 })
    return
  end
  local vsx = id:match("^vsShadeX_(%d+)$")
  if vsx then
    launcher.service("shaders", "delete", { index = tonumber(vsx) - 1 })
    return
  end
  if base == "vsModRefresh" then launcher.service("mods", "refresh", {}) return end
  if base == "vsShadeRefresh" then launcher.service("shaders", "refresh", {}) return end
  if base == "vsModOpenDir" or base == "vsShadeOpenDir" or base == "vsOpenMods" then
    launcher.service("versionSettings", "openMods", {})
    return
  end
  if base == "vsOpenDir" or base == "vsAdv1" then
    launcher.service("versionSettings", "openDir", {})
    return
  end
  if base == "vsOpenSaves" or base == "vsAdv2" then
    launcher.service("versionSettings", "openSaves", {})
    return
  end
  if base == "vsReset" or base == "vsAdv3" then
    launcher.service("versionSettings", "reset", {})
    refreshVersionSettingsValues()
    return
  end
  if base == "vsDeleteTop" or base == "vsAdvDanger" then
    launcher.service("versionSettings", "delete", {})
    return
  end

  -- ===== 更多页 =====
  local mc = base:match("^moreCat_(.+)$")
  if mc then
    moreSelCat = mc
    refreshMoreSidebar()
    refreshMoreContent()
    return
  end

  -- ===== 联机页 =====
  local segm = id:match("^segM_(%d+)$")
  if segm then
    selectSegment("segM", CONFIG.online.branch, tonumber(segm))
    return
  end
  if base == "mpJoinRow" or id == "mpJoin" then
    launcher.service("multiplayer", "promptJoin", {})
    return
  end
  if base == "mpCreateRow" or id == "mpCreate" then
    launcher.service("multiplayer", "promptCreate", {})
    return
  end
  if id == "mpShare" then
    launcher.service("multiplayer", "share", {})
    return
  end
  local mpC = id:match("^mpRoomC_(%d+)$")
  if mpC then
    launcher.service("multiplayer", "connect", { index = tonumber(mpC) })
    return
  end
  local mpD = id:match("^mpRoomD_(%d+)$")
  if mpD then
    launcher.service("multiplayer", "delete", { index = tonumber(mpD) })
    return
  end

  -- ===== 版本 / 账号 / 游戏目录管理页 =====
  local vms = base:match("^vm_(%d+)$")
  if vms then
    local it = (launcher.service and launcher.service("version", "list", {}) or {}).items
    local item = (type(it) == "table") and it[tonumber(vms)] or nil
    if item and item.id then launcher.service("version", "select", { id = item.id }) end
    refreshVersionManager()
    return
  end
  if base == "vmAdd" then launcher.action("open:download") return end
  local ams = base:match("^am_(%d+)$")
  if ams then
    local it = (launcher.service and launcher.service("account", "list", {}) or {}).items
    local item = (type(it) == "table") and it[tonumber(ams)] or nil
    if item and (item.id or item.username) then
      launcher.service("account", "select", { id = item.id or item.username })
    end
    refreshAccountManager()
    return
  end
  if base == "amAdd" then launcher.service("account", "manage", {}) return end
  local gds = base:match("^gdPick_(%d+)$") or base:match("^gd_(%d+)$")
  if gds then
    local r = launcher.service and launcher.service("gameDir", "list", {}) or nil
    local its = (type(r) == "table" and type(r.items) == "table") and r.items or {}
    local m = its[tonumber(gds)]
    if m and type(m.name) == "string" and m.name ~= "" then
      launcher.service("gameDir", "set", { name = m.name })
    end
    refreshGameDirectory()
    return
  end
  if base == "gdCreate" then
    local name = (launcher.view("gdNewIn") and launcher.view("gdNewIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if name ~= "" and name ~= CONFIG.gameDirectory.addPlaceholder then
      launcher.service("gameDir", "new", { name = name })
      refreshGameDirectory()
    end
    return
  end

  -- 兜底：home 页「版本设置」入口等其余未显式处理的 id 静默忽略（引擎 action 白名单已各自导航）
end